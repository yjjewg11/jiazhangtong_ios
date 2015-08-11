//
//  UIColor+MFColor.m
//  maifangbao
//  获取view位置  尺寸
//  Created by whb on 15/5/24.
//  Copyright (c) 2015年 whb. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

//设置边框
-(void)setBorderWithWidth:(CGFloat)width color:(UIColor *)color;
-(void)setBorderWithWidth:(CGFloat)width color:(UIColor *)color radian:(CGFloat)radian;
- (void)viewHiddenAnimate:(BOOL)hidden;
- (void)viewAlphaAnimate:(CGFloat)initVal targetVal:(CGFloat)targetVal;
- (void)viewAlphaAnimate:(CGFloat)initVal targetVal:(CGFloat)targetVal finish:(void(^)())finish;
//view旋转动画
- (void)rotationAnimation:(CGFloat)f;
//隐藏拖动webview时黑色背景
- (void)hideGradientBackground:(UIView*)theView;
//view动画
+ (void)viewAnimate:(void(^)())animate time:(float)time;
@end
