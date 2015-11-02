//
//  UIColor+MFColor.m
//  maifangbao
//
//  Created by whb on 15/5/24.
//  Copyright (c) 2015年 whb. All rights reserved.
//


#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}


-(void)setBorderWithWidth:(CGFloat)width color:(UIColor *)color {
    self.layer.borderColor =[UIColor grayColor].CGColor;
    self.layer.borderWidth = width;
}


-(void)setBorderWithWidth:(CGFloat)width color:(UIColor *)color radian:(CGFloat)radian {
    [self setBorderWithWidth:width color:color];
    [[self layer]setCornerRadius:radian];//圆角
    [self.layer setMasksToBounds:YES];
}

- (void)viewHiddenAnimate:(BOOL)hidden{
    [UIView animateWithDuration:Number_ViewAlpha_Five
                     animations:^{
                         self.hidden = hidden;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)viewAlphaAnimate:(CGFloat)initVal targetVal:(CGFloat)targetVal{
    self.alpha = initVal;
    [UIView animateWithDuration:Number_ViewAlpha_Five
                     animations:^{
                         self.alpha = targetVal;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)viewAlphaAnimate:(CGFloat)initVal targetVal:(CGFloat)targetVal finish:(void(^)())finish{
    self.alpha = initVal;
    [UIView animateWithDuration:Number_ViewAlpha_Five
                     animations:^{
                         self.alpha = targetVal;
                     }
                     completion:^(BOOL finished){
                         finish();
                     }];
}

//view旋转动画
- (void)rotationAnimation:(CGFloat)f{
    [UIView animateWithDuration:Number_ViewAlpha_Five
                     animations:^{
                         self.transform = CGAffineTransformMakeRotation(f * M_PI/180.0);
                     }
                     completion:^(BOOL finished){
                     }];
}


//隐藏拖动webview时黑色背景
- (void)hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        [self hideGradientBackground:subview];
    }
}

+ (void)viewAnimate:(void(^)())animate time:(float)time{
    [UIView animateWithDuration:time
                     animations:^{
                         animate();
                     }
                     completion:^(BOOL finished){
                     }];
}
@end
