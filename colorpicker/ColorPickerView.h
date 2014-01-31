//
//  ColorPickerView.h
//  oekaki01
//
//  Created by moca on 2014/01/27.
//  Copyright (c) 2014年 moca. All rights reserved.
//

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
-(NSInteger)setInteger;
@end
