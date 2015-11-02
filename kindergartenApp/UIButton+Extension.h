//
//  UIButton-Extension.h
//  kindergartenApp
//
//  Created by You on 15/6/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

@property (nonatomic, strong, readwrite) NSObject * targetObj;
@property (nonatomic, assign, readwrite) NSInteger  index;

/**
 *  设置按钮文本颜色
 *
 *  @param def <#def description#>
 *  @param sel <#sel description#>
 */
- (void)setTextColor:(UIColor *)def sel:(UIColor *)sel;


/**
 *  设置按钮文本
 *
 *  @param title   <#title description#>
 */
- (void)setText:(NSString *)title;


/**
 *  设置背景图片
 *
 *  @param defImageName <#defImageName description#>
 *  @param selImageName <#selImageName description#>
 */
- (void)setBackgroundImage:(NSString *)defImageName selImg:(NSString *)selImageName;


/**
 *  设置图片
 *
 *  @param defImageName <#defImageName description#>
 *  @param selImageName <#selImageName description#>
 */
- (void)setImage:(NSString *)defImageName selImg:(NSString *)selImageName;

@end
