//  ColorPickerView.m
//  Created by moca on 2014/01/23.
//  Dual licensed under the MIT and GPL

#import "ColorPickerView.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ColorPickerView()

@property(nonatomic)CGFloat redColor;

@end


@implementation ColorPickerView

- (id)init
{
    self = [super init];
    if (self) {
        RED = 0.0;
        GREEN = 0.0;
        BLUE = 0.0;
        ALPHA = 0.0;
        TOUCH_COLOR = 0;
        [self initPicker];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

-(void)initPicker
{
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0,0,260,300)];
    [baseView setBackgroundColor:RGBA(0, 0, 0, 0.8)];
    [self addSubview:baseView];
    UIView *red = [[UIView alloc]initWithFrame:CGRectMake(20,50,40,127.5)];
    red.tag = 1000;
    [red addSubview:[self colorScale]];
    [red addSubview:[self text]];
    [baseView addSubview:red];
    UIView *green = [[UIView alloc]initWithFrame:CGRectMake(80,50,40,127.5)];
    green.tag = 1001;
    [green addSubview:[self colorScale]];
    [green addSubview:[self text]];
    [baseView addSubview:green];
    UIView *blue = [[UIView alloc]initWithFrame:CGRectMake(140,50,40,127.5)];
    blue.tag = 1002;
    [blue addSubview:[self colorScale]];
    [blue addSubview:[self text]];
    [baseView addSubview:blue];
    UIView *alpha = [[UIView alloc]initWithFrame:CGRectMake(200,50,40,127.5)];
    alpha.tag = 1003;
    [alpha addSubview:[self colorScale]];
    [alpha addSubview:[self text]];
    [baseView addSubview:alpha];
    [self renderPicker];
    setColorView = [[UIView alloc]initWithFrame:CGRectMake(20,200,60,60)];
    [setColorView setBackgroundColor:RGBA(0, 0, 0, 0.8)];
    setColorView.tag = 9;
    setColorView.layer.cornerRadius = 5;
    setColorView.clipsToBounds = true;
    [baseView addSubview:setColorView];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(100,210,140,40)];
    [line setBackgroundColor:RGBA(250, 250, 250, 0.3)];
    line.tag = 1004;
    line.layer.cornerRadius = 5;
    line.clipsToBounds = true;
    [line addSubview:[self lineScale]];
    [line addSubview:[self widthText]];
    [baseView addSubview:line];
    [self renderLineWidth:1.0];

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}
-(UILabel *)text
{
    UILabel *ob = [[UILabel alloc]initWithFrame:CGRectMake(0,-30,40,20)];
    ob.textColor = RGB(255, 255, 255);
    ob.backgroundColor = RGBA(255, 255, 255, 0.0);
    ob.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0];
    ob.textAlignment = NSTextAlignmentCenter;
    ob.tag = 120;
    ob.text = @"0";
    return ob;
}

-(UILabel *)widthText
{
    UILabel *ob = [[UILabel alloc]initWithFrame:CGRectMake(50,0,40,15)];
    ob.textColor = RGB(255, 255, 255);
    ob.backgroundColor = RGBA(255, 255, 255, 0.0);
    ob.font = [UIFont fontWithName:@"Helvetica Neue" size:9.0];
    ob.textAlignment = NSTextAlignmentCenter;
    ob.tag = 120;
    ob.text = @"0.5";
    return ob;
}

-(void)renderPicker
{
    UIGraphicsBeginImageContextWithOptions(baseView.frame.size,NO,1.0);
    UIImage *old = [[UIImage alloc]initWithCGImage:(CGImageRef)baseView.layer.contents];
    [old drawAtPoint:CGPointZero];
    CGContextRef context = UIGraphicsGetCurrentContext();
    int i = 0;
    for(i = 0; i <= 255; ++i)
    {
        CGContextSetFillColorWithColor(context, [RGB(i,GREEN,BLUE) CGColor]);

        CGContextFillRect(context, CGRectMake(30,(i / 2) + 50,20,0.5));
        
        CGContextSetFillColorWithColor(context, [RGB(RED,i,BLUE) CGColor]);
        CGContextFillRect(context, CGRectMake(90,(i / 2) + 50,20,0.5));
        
        CGContextSetFillColorWithColor(context, [RGB(RED,GREEN,i) CGColor]);
        CGContextFillRect(context, CGRectMake(150,(i / 2) + 50,20,0.5));
        if(i <= 100){
            CGContextSetFillColorWithColor(context, [RGBA(RED,GREEN,BLUE,(float)i / 100) CGColor]);
            CGContextFillRect(context, CGRectMake(210,(i * 1.275) + 50,20,1.275));
        }
        
    }
    
    [setColorView setBackgroundColor:RGBA(RED,GREEN,BLUE,ALPHA)];
    [baseView.layer setContents:(id)[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
    UIGraphicsEndImageContext();
}
-(void)renderLineWidth:(CGFloat)widthPoint
{
    UIGraphicsBeginImageContextWithOptions(baseView.frame.size,NO,1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *old = [[UIImage alloc]initWithCGImage:(CGImageRef)baseView.layer.contents];
    [old drawAtPoint:CGPointZero];
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context,[RGB(255,255,255) CGColor]);
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context,100,230);
    CGContextAddLineToPoint(context,widthPoint + 100,230);
    CGContextStrokePath(context);
    CGContextSetStrokeColorWithColor(context, [RGB(100,100,100) CGColor]);
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context,widthPoint + 100,230);
    CGContextAddLineToPoint(context,240,230);
    CGContextStrokePath(context);
    [baseView.layer setContents:(id)[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
    UIGraphicsEndImageContext();
}




-(UIView *)colorScale
{
    UIView *scale = [[UIView alloc]initWithFrame:CGRectMake(0,-10,40,20)];
    scale.tag = 100;
    UIGraphicsBeginImageContextWithOptions(scale.frame.size,NO,1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [RGB(255,255,255) CGColor]);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 30,5);
    CGContextAddLineToPoint(context, 36, 5);
    CGContextAddLineToPoint(context, 36, 15);
    CGContextAddLineToPoint(context, 30, 15);
    CGContextAddLineToPoint(context, 27, 10);
    CGContextMoveToPoint(context, 4,5);
    CGContextAddLineToPoint(context, 10, 5);
    CGContextAddLineToPoint(context, 13, 10);
    CGContextAddLineToPoint(context, 10, 15);
    CGContextAddLineToPoint(context, 4, 15);
    CGContextFillPath(context);
    UIImageView *v = [[UIImageView alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    
    [scale addSubview:v];
    return scale;
}

-(UIView *)lineScale
{
    UIView *scale = [[UIView alloc]initWithFrame:CGRectMake(0,0,20,40)];
    scale.tag = 100;
    UIGraphicsBeginImageContextWithOptions(scale.frame.size,NO,1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [RGB(255,255,255) CGColor]);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 5, 5);
    CGContextAddLineToPoint(context, 15, 5);
    CGContextAddLineToPoint(context, 15, 10);
    CGContextAddLineToPoint(context, 10, 15);
    CGContextAddLineToPoint(context, 5, 10);
    CGContextMoveToPoint(context, 5, 35);
    CGContextAddLineToPoint(context, 15, 35);
    CGContextAddLineToPoint(context, 15, 30);
    CGContextAddLineToPoint(context, 10, 25);
    CGContextAddLineToPoint(context, 5, 30);
    CGContextFillPath(context);
    UIImageView *v = [[UIImageView alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    
    [scale addSubview:v];
    return scale;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    if((currentPoint.y - 40) >= 0 && (currentPoint.y - 40) <= 127.5)
    {
        //NSLog(@"x : %f",currentPoint.y);
        if(touch.view.tag == 100){
            touchView = touch.view;
            UIView *parent = [touch.view superview];
            value = (UITextView *)[parent viewWithTag:120];
        }else if(touch.view.tag == 1000 || touch.view.tag == 1001 || touch.view.tag == 1002 || touch.view.tag == 1003 || touch.view.tag == 1004){
            touchView = [[self viewWithTag:touch.view.tag] viewWithTag:100];
            value = (UITextView *)[[self viewWithTag:touch.view.tag] viewWithTag:120];
        }
        if(currentPoint.x >= 20 && currentPoint.x <= 60)
        {
            TOUCH_COLOR = 1;
            RED = (currentPoint.y - 40) * 2;
            value.text = [NSString stringWithFormat:@"%ld",(long)(currentPoint.y - 40) * 2];
            touchView.center = CGPointMake(20,(currentPoint.y - 40));
        }else if(currentPoint.x >= 80 && currentPoint.x <= 120)
        {
            TOUCH_COLOR = 2;
            GREEN = (currentPoint.y - 40) * 2;
            value.text = [NSString stringWithFormat:@"%ld",(long)(currentPoint.y - 40) * 2];
            touchView.center = CGPointMake(20,(currentPoint.y - 40));
        }else if(currentPoint.x >= 140 && currentPoint.x <= 180){
            TOUCH_COLOR = 3;
            BLUE = (currentPoint.y - 40) * 2;
            value.text = [NSString stringWithFormat:@"%ld",(long)(currentPoint.y - 40) * 2];
            touchView.center = CGPointMake(20,(currentPoint.y - 40));
        }else if(currentPoint.x >= 200 && currentPoint.x <= 240){
            TOUCH_COLOR = 4;
            ALPHA = (currentPoint.y - 40) / 127.5;
            value.text = [NSString stringWithFormat:@"%.4f",ALPHA];
            touchView.center = CGPointMake(20,(currentPoint.y - 40));
        }
        [self renderPicker];
    }else if(currentPoint.x >= 100 && currentPoint.x <= 240 && currentPoint.y >= 210 && currentPoint.y <= 250){
        if(touch.view.tag == 100){
            touchView = touch.view;
            UIView *parent = [touch.view superview];
            value = (UITextView *)[parent viewWithTag:120];
        }else if(touch.view.tag == 1004){
            touchView = [[self viewWithTag:touch.view.tag] viewWithTag:100];
            value = (UITextView *)[[self viewWithTag:touch.view.tag] viewWithTag:120];
        }
        TOUCH_COLOR = 5;
        touchView.center = CGPointMake((currentPoint.x - 100),20);
        value.text = [NSString stringWithFormat:@"%.4f",currentPoint.x - 100];
        [self renderLineWidth:currentPoint.x - 100];
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    if(TOUCH_COLOR != 0 && TOUCH_COLOR != 5){
        if((currentPoint.y - 40) >= 0 && (currentPoint.y - 40) <= 127.5){
            touchView.center = CGPointMake(20,(currentPoint.y - 40));
            value.text = [NSString stringWithFormat:@"%ld",(long)(currentPoint.y - 40) * 2];
            switch (TOUCH_COLOR) {
                case 1:
                {
                    RED = (currentPoint.y - 40) * 2;
                }
                    break;
                case 2:
                {
                    GREEN = (currentPoint.y - 40) * 2;
                }
                    break;
                case 3:
                {
                    BLUE = (currentPoint.y - 40) * 2;
                }
                    break;
                case 4:
                {
                    ALPHA = (currentPoint.y - 40) / 127.5;
                    value.text = [NSString stringWithFormat:@"%.4f",ALPHA];
                }
                    break;
            }
            
        }else if ((currentPoint.y - 40) < 0){
            touchView.center = CGPointMake(20,0);
            value.text = [NSString stringWithFormat:@"%ld",(long)0];
            switch (TOUCH_COLOR) {
                case 1:
                {
                    RED = 0;
                }
                    break;
                case 2:
                {
                    GREEN = 0;
                }
                    break;
                case 3:
                {
                    BLUE = 0;
                }
                    break;
                case 4:
                {
                    ALPHA = 0.0;
                    value.text = [NSString stringWithFormat:@"%.4f",ALPHA];
                }
                    break;
            }
        }else if((currentPoint.y - 40) > 127.5){
            touchView.center = CGPointMake(20,127.5);
            value.text = [NSString stringWithFormat:@"%ld",(long)255];
            switch (TOUCH_COLOR) {
                case 1:
                {
                    RED = 255;
                }
                    break;
                case 2:
                {
                    GREEN = 255;
                }
                    break;
                case 3:
                {
                    BLUE = 255;
                }
                    break;
                case 4:
                {
                    ALPHA = 1.0;
                    value.text = [NSString stringWithFormat:@"%f",ALPHA];
                }
                    break;
            }
        }
        [self renderPicker];
    }else if(TOUCH_COLOR == 5){
        if(currentPoint.x >= 100 && currentPoint.x <= 240){
            if(currentPoint.x - 100 == 0){
                touchView.center = CGPointMake(0.5,20);
                [self renderLineWidth:0.5];
                value.text = [NSString stringWithFormat:@"%.4f",0.5];
            }else{
                touchView.center = CGPointMake((currentPoint.x - 100),20);
                [self renderLineWidth:currentPoint.x - 100];
                value.text = [NSString stringWithFormat:@"%.4f",currentPoint.x - 100];
            }
        }
    }
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    TOUCH_COLOR = 0;
    touchView = nil;
    value = nil;
}



@end
