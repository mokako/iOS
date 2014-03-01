//
//  ViewController.m
//  oekaki01
//
//  Created by moca on 2014/01/23.
//  Dual licensed under the MIT and GPL

#import "ViewController.h"
#import "ColorPickerView.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface ViewController ()
{
    int moveCount;
}


@property(nonatomic)UIBezierPath *bezierPath;
@property(nonatomic)UIBezierPath *dummyPath;
@property(nonatomic)CGPoint lastPoint;
@property(nonatomic)CALayer *atNewLayer;
@property(nonatomic)UIImage *atNewImage;
@property(nonatomic)UIImage *lastDrawImage;
@property(nonatomic)UIImage *atDummyImage;
@property(nonatomic)CALayer *atDummyLayer;


@property(nonatomic)NSMutableArray *undoStack;
@property(nonatomic)NSMutableArray *redoStack;
@property(nonatomic)UIImageView *canvas;
@property(nonatomic)UIToolbar *toolbar;




@property(nonatomic)UIView *ocToolbar;
@property(nonatomic)UIView *pickerView;
@property(nonatomic)UIColor *strokeColor;
@property(nonatomic)UITextView *lineWidthText;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [self initializeMethods];
    [self initializeColorPicker];
    [super viewDidLoad];
    self.undoStack = [[NSMutableArray alloc]init];
    self.redoStack = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)initializeMethods
{
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake( 0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50 )];
    //space
    UIBarButtonItem *gap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //gap.tintColor = [self RGBAColorWithRed:0 green:45 blue:55 alpha:1.0];
    
    //connect
    UIButton *a = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    a.frame = CGRectMake(0, 0, 50, 50);
    [a setTitle:@"undo" forState:UIControlStateNormal];
    [a addTarget:self action:@selector(undoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ab = [[UIBarButtonItem alloc]initWithCustomView:a];
    
    
    //Layer
    UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b.frame = CGRectMake(0, 0, 50, 50);
    [b setTitle:@"redo" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(redoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bb = [[UIBarButtonItem alloc]initWithCustomView:b];
    
    
    //Setting
    UIButton *s = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    s.frame = CGRectMake(0, 0, 50, 50);
    [s setTitle:@"clear" forState:UIControlStateNormal];
    [s addTarget:self action:@selector(clearBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sb = [[UIBarButtonItem alloc]initWithCustomView:s];
    
    

    
    
    self.toolbar.tag = 2;
    
    self.toolbar.items = [NSArray arrayWithObjects:ab,gap,bb,gap,sb,nil];
    [self.view addSubview:self.toolbar];
    
    self.canvas = [[UIImageView alloc]initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height - 90)];
    self.canvas.image = nil;
    [self.view addSubview:self.canvas];
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.canvas.frame;
    layer.name = @"layer";
    
    [self.canvas.layer addSublayer:layer];

    
}


-(void)initializeColorPicker
{
    
    //color picker 用　tab
    self.ocToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 20, 50)];
    self.ocToolbar.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ocToolbarView:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.ocToolbar addGestureRecognizer:swipeLeftGesture];
    
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ocToolbarView:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.ocToolbar addGestureRecognizer:swipeRightGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocToolbarView:)];
    [self.ocToolbar addGestureRecognizer:tap];
    [self.view addSubview:self.ocToolbar];
    [self.view bringSubviewToFront:self.ocToolbar];
    //color picker 本体

    self.pickerView = [[ColorPickerView alloc]init];
    self.pickerView.frame = CGRectMake(-260,50,self.pickerView.bounds.size.width,self.pickerView.bounds.size.height);
    [self.view addSubview:self.pickerView];
    
    self.lineWidthText = (UITextView *)[[self.pickerView viewWithTag:1004]viewWithTag:120];
    
}

-(void)ocToolbarView:(UIView *)sender
{
    [UIView animateWithDuration:0.2f
                     animations:^{
                         // アニメーションをする処理
                         
                         if(self.ocToolbar.frame.origin.x == 0)
                         {
                             self.pickerView.frame= CGRectMake(0, 50, 260, 300);
                             self.ocToolbar.frame = CGRectMake(260,50, 20, 50);
                         }else if(self.ocToolbar.frame.origin.x == 260){
                             self.pickerView.frame= CGRectMake(-260, 50, 260, 300);
                             self.ocToolbar.frame = CGRectMake(0,50, 20, 50);
                         }
                     }
                     completion:^(BOOL finished){
                         // アニメーションが終わった後実行する処理
                     }];
}


- (void)undoBtnPressed:(id)sender
{
    if([self.undoStack count] == 0){
        //NSLog(@"NO LINE STACK");
    }else{
        // undoスタックからパスを取り出しredoスタックに追加します。
        NSDictionary *undoPath = self.undoStack.lastObject;
        [self.undoStack removeLastObject];
        [self.redoStack addObject:undoPath];
        
        // 画面にパスを描画します。
        CALayer *child = [self.canvas.layer.sublayers objectAtIndex:0];
        CALayer *newLayer = [[CALayer alloc]init];
        newLayer.name = child.name;
        newLayer.frame = self.canvas.frame;
        for (NSMutableDictionary *path in self.undoStack) {
            UIGraphicsBeginImageContextWithOptions(self.canvas.frame.size,NO,1.0);
            // 描画領域に、前回までに描画した画像を、描画します。
            UIImage *old = [[UIImage alloc]initWithCGImage:(CGImageRef)newLayer.contents];
            [old drawAtPoint:CGPointZero];
            // 色をセットします。
            [path[@"color"] setStroke];
            // 線を引きます。
            [path[@"line"] stroke];
            // 描画した画像をcanvasにセットして、画面に表示します。
            newLayer.contents = (id)[UIGraphicsGetImageFromCurrentImageContext() CGImage];
            // 描画を終了します。
            UIGraphicsEndImageContext();
        }
        [self.canvas.layer replaceSublayer:[self.canvas.layer.sublayers objectAtIndex:0] with:newLayer];
    }
}

- (void)redoBtnPressed:(id)sender
{
    // redoスタックからパスを取り出しundoスタックに追加します。
    if([self.redoStack count] == 0){}else{
        NSDictionary *redoPath = [[NSDictionary alloc]initWithDictionary:self.redoStack.lastObject];
        
        
        [self.redoStack removeLastObject];
        [self.undoStack addObject:redoPath];
    
        // 画面にパスを描画します。
        CALayer *child = [self.canvas.layer.sublayers objectAtIndex:0];
        CALayer *newLayer = [[CALayer alloc]init];
        newLayer.name = child.name;
        newLayer.frame = self.canvas.frame;
        for (NSDictionary *path in self.undoStack) {
            UIGraphicsBeginImageContextWithOptions(self.canvas.frame.size,NO,1.0);
            // 描画領域に、前回までに描画した画像を、描画します。
            UIImage *old = [[UIImage alloc]initWithCGImage:(CGImageRef)newLayer.contents];
            [old drawAtPoint:CGPointZero];
            // 色をセットします。
            [path[@"color"] setStroke];
            // 線を引きます。
            [path[@"line"] stroke];
            // 描画した画像をcanvasにセットして、画面に表示します。
            newLayer.contents = (id)[UIGraphicsGetImageFromCurrentImageContext() CGImage];
            // 描画を終了します。
            UIGraphicsEndImageContext();
        }
        [self.canvas.layer replaceSublayer:[self.canvas.layer.sublayers objectAtIndex:0] with:newLayer];
    }
}

- (void)clearBtnPressed:(id)sender
{

    // 保持しているパスを全部削除します。
    [self.undoStack removeAllObjects];
    [self.redoStack removeAllObjects];
    
    // 画面をクリアします。

    self.canvas.layer.sublayers = nil;
    CALayer *layer = [CALayer layer];
    layer.frame = self.canvas.frame;
    layer.name = @"layer";
    
    [self.canvas.layer addSublayer:layer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチした座標を取得します。
    CGPoint currentPoint = [[touches anyObject] locationInView:self.canvas];
    self.atNewLayer = [self.canvas.layer.sublayers objectAtIndex:0];
    self.atDummyLayer = [self.canvas.layer.sublayers objectAtIndex:0];
    self.atNewImage = [[UIImage alloc]initWithCGImage:(CGImageRef)self.atNewLayer.contents];
    self.atDummyImage = [[UIImage alloc]initWithCGImage:(CGImageRef)self.atDummyLayer.contents];
    self.bezierPath = [UIBezierPath bezierPath];
    self.bezierPath.lineCapStyle = kCGLineCapRound;
    self.dummyPath = [UIBezierPath bezierPath];
    self.dummyPath.lineCapStyle = kCGLineCapRound;
    [self.bezierPath moveToPoint:currentPoint];
    [self.dummyPath moveToPoint:currentPoint];
    self.lastPoint = currentPoint;
    self.strokeColor = [self.pickerView viewWithTag:9].backgroundColor;
    self.bezierPath.lineWidth = [self.lineWidthText.text floatValue];
    self.dummyPath.lineWidth = [self.lineWidthText.text floatValue];;
    moveCount = 0;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    ++moveCount;
    // タッチ開始時にパスを初期化していない場合は処理を終了します。
    CGPoint currentPoint = [[touches anyObject] locationInView:self.canvas];
    if (self.bezierPath == nil){
        return;
    }
    if(moveCount < 2)return;
    if(self.lastPoint.x - currentPoint.x >= -15 && self.lastPoint.x - currentPoint.x  <= 15 && self.lastPoint.y - currentPoint.y >= -15 && self.lastPoint.y - currentPoint.y  <= 15)return;
    
    // タッチした座標を取得します。
    // パスにポイントを追加します。
    
    CGPoint middlePoint = CGPointMake((self.lastPoint.x + currentPoint.x) / 2, (self.lastPoint.y + currentPoint.y) / 2);
    
    // パスにポイントを追加します。
    [self.bezierPath addQuadCurveToPoint:middlePoint controlPoint:self.lastPoint];
    
    
    // 線を描画します。
    UIGraphicsBeginImageContextWithOptions(self.canvas.frame.size,NO,1.0);
    
    [self.atDummyImage drawAtPoint:CGPointZero];
    // 描画領域に、前回までに描画した画像を、描画します。
    [self.dummyPath addLineToPoint:currentPoint];

    
    // 色をセットします。
    [self.strokeColor  setStroke];
        
    // 線を引きます。
    [self.dummyPath stroke];
        
    // 描画した画像をcanvasにセットして、画面に表示します。
    self.atDummyLayer.contents = (id)[UIGraphicsGetImageFromCurrentImageContext() CGImage];
    
    
    if(moveCount % 30 == 0){
        [self.dummyPath removeAllPoints];
        [self.dummyPath moveToPoint:currentPoint];
        self.atDummyImage = [[UIImage alloc]initWithCGImage:(CGImageRef)self.atDummyLayer.contents];
    }
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチ開始時にパスを初期化していない場合は処理を終了します。
    if (self.bezierPath == nil){
        return;
    }
    
    // タッチした座標を取得します。
    CGPoint currentPoint = [[touches anyObject] locationInView:self.canvas];
    
    // パスにポイントを追加します。
    CGPoint middlePoint = CGPointMake((self.lastPoint.x + currentPoint.x) / 2, (self.lastPoint.y + currentPoint.y) / 2);
    
    // パスにポイントを追加します。
    [self.bezierPath addQuadCurveToPoint:middlePoint controlPoint:self.lastPoint];
    // 線を描画します。
    UIGraphicsBeginImageContextWithOptions(self.canvas.frame.size,NO,1.0);
    // 描画領域に、前回までに描画した画像を、描画します。
    
    [self.atNewImage drawAtPoint:CGPointZero];
    
    // 色をセットします。
    [self.strokeColor  setStroke];
    // 線を引きます。
    [self.bezierPath stroke];
    
    
    
    // 描画した画像をcanvasにセットして、画面に表示します。
    self.atNewLayer.contents = (id)[UIGraphicsGetImageFromCurrentImageContext() CGImage];
    [self.canvas.layer replaceSublayer:[self.canvas.layer.sublayers objectAtIndex:0] with:self.atNewLayer];
    // 描画を終了します。
    UIGraphicsEndImageContext();
    
    // 今回描画した画像を保持します。
    
    // undo用にパスを保持して、redoスタックをクリアします。
    NSMutableDictionary *pt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.strokeColor,@"color",self.bezierPath,@"line",  nil];
    [self.undoStack addObject:pt];
    [self.redoStack removeAllObjects];
    
    self.bezierPath = nil;
    self.dummyPath = nil;
    moveCount = 0;
}


@end
