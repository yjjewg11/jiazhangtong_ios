//
//  UIButton+Extension.m
//  kindergartenApp
//
//  Created by You on 15/6/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>


static void * FuniUIButtonPorpertyKeyTargetObj = (void *)@"FuniUIButtonPorpertyKeyTargetObj";
static void * FuniUIButtonPorpertyKeyIndex     = (void *)@"FuniUIButtonPorpertyKeyIndex";

@implementation UIButton (Extension)

- (NSObject *)targetObj
{
    return objc_getAssociatedObject(self, FuniUIButtonPorpertyKeyTargetObj);
}

- (void)setTargetObj:(NSObject *)targetObj
{
    objc_setAssociatedObject(self, FuniUIButtonPorpertyKeyTargetObj, targetObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index
{
    return (NSInteger)objc_getAssociatedObject(self, FuniUIButtonPorpertyKeyIndex);
}

- (void)setIndex:(NSInteger)index
{
    objc_setAssociatedObject(self, FuniUIButtonPorpertyKeyIndex, [NSNumber numberWithInteger:index], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 *  设置按钮文本颜色
 *
 *  @param def <#def description#>
 *  @param sel <#sel description#>
 */
- (void)setTextColor:(UIColor *)def sel:(UIColor *)sel {
    [self setTitleColor:def forState:UIControlStateNormal];
    [self setTitleColor:def forState:UIControlStateHighlighted];
    [self setTitleColor:sel forState:UIControlStateSelected];
}


/**
 *  设置按钮文本
 *
 *  @param title   <#title description#>
 *  @param selText <#selText description#>
 */
- (void)setText:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
}


/**
 *  设置背景图片
 *
 *  @param defImageName <#defImageName description#>
 *  @param selImageName <#selImageName description#>
 */
- (void)setBackgroundImage:(NSString *)defImageName selImg:(NSString *)selImageName {
    [self setBackgroundImage:[UIImage imageNamed:defImageName] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:selImageName] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
}


/**
 *  设置图片
 *
 *  @param defImageName <#defImageName description#>
 *  @param selImageName <#selImageName description#>
 */
- (void)setImage:(NSString *)defImageName selImg:(NSString *)selImageName {
    [self setImage:[UIImage imageNamed:defImageName] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:selImageName] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
}

@end
