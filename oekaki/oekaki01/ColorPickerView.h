//
//  ColorPickerView.h
//  Created by moca on 2014/01/23.
//  Dual licensed under the MIT and GPL

#import <UIKit/UIKit.h>

@interface ColorPickerView : UIView
{
    CGFloat RED;
    CGFloat GREEN;
    CGFloat BLUE;
    CGFloat ALPHA;
    CGFloat LINE;
    NSInteger TOUCH_COLOR;
    UIView *touchView;
    UIView *baseView;
    UITextView *value;
    UIView *setColorView;
    UIView *alphaView;
}
@end
