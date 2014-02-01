//
//  ColorPickerView.h
//  copyleft
//  I admit the distribution and modified freely.

#import <UIKit/UIKit.h>
#import "UIViewPlus.h"

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
