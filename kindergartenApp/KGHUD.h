//
//  FuniHUD.h
//  funiApp
//  HUD util
//  Created by qian.luo on 13-5-20.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HUDTEXTSIZE       12.0f

@interface KGHUD : UIView


+ (KGHUD *)sharedHud;


/**
 *  show HUD
 *
 *  @param parentView 承载HUD的View
 */
- (void)show:(UIView *)parentView;


/**
 *  show HUD
 *
 *  @param parentView 承载HUD的View
 *  @param msgText    显示文本
 */
- (void)show:(UIView *)parentView onlyMsg:(NSString *)msgText;


/**
 *  show HUD
 *
 *  @param parentView 承载HUD的View
 *  @param msgText    显示文本
 */
- (void)show:(UIView *)parentView msg:(NSString *)msgText;


/**
 *  show扇形HUD
 *
 *  @param parentView 承载HUD的View
 *  @param msgText    显示文本 不显示则为nil
 */
- (void)showSector:(UIView *)parentView msg:(NSString *)msgText;


/**
 *  改变进度
 *
 *  @param parentView    承载HUD的View
 *  @param currentLength 当前完成length
 *  @param totalLength   总length
 */
- (void)changeProgress:(UIView *)parentView currentLength:(long long)currentLength totalLength:(long long)totalLength;


/**
 *  改变提示文本
 *
 *  @param parentView 承载HUD的View
 *  @param text       修改后文本
 */
- (void)changeText:(UIView *)parentView text:(NSString *)text;


/**
 *  隐藏指定view中的HUD
 *
 *  @param parentView 承载HUD的View
 */
- (void)hide:(UIView *)parentView ;


@end
