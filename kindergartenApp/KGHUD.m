//
//  FuniHUD.m
//  funiApp
//
//  Created by qian.luo on 13-5-20.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import "KGHUD.h"
#import "MBProgressHUD.h"

#define HUD_TAG     10000

@implementation KGHUD {
    MBProgressHUD * hud;
}


+ (KGHUD *)sharedHud{
    static KGHUD *_sharedHud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHud = [KGHUD new];
    });
    
    return _sharedHud;
}


/**
 *  show HUD
 *
 *  @param parentView 承载HUD的View
 */
- (void)show:(UIView *)parentView {
    [self hide:parentView];
    hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.tag = HUD_TAG;
    hud.margin = 5.f;
    hud.removeFromSuperViewOnHide = YES;
}


/**
 *  show HUD
 *
 *  @param parentView 承载HUD的View
 *  @param msgText    显示文本
 */
- (void)show:(UIView *)parentView onlyMsg:(NSString *)msgText {
    [self hide:parentView];
    hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.tag = HUD_TAG;
    hud.detailsLabelText = msgText;
    hud.margin = 5.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    [hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}


#pragma mark - Execution code

- (void)myTask {
    sleep(2.0f);
}


/**
 *  show HUD
 *
 *  @param parentView 承载HUD的View
 *  @param msgText    显示文本
 */
- (void)show:(UIView *)parentView msg:(NSString *)msgText {
    [self hide:parentView];
    hud = [[MBProgressHUD alloc] initWithView:parentView];
    hud.tag = HUD_TAG;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelFont = [UIFont boldSystemFontOfSize:HUDTEXTSIZE];
    [parentView addSubview:hud];
    hud.labelText = msgText;
    [hud show:YES];
}


/**
 *  show扇形HUD
 *
 *  @param parentView 承载HUD的View
 *  @param msgText    显示文本 不显示则为nil
 */
- (void)showSector:(UIView *)parentView msg:(NSString *)msgText {
    [self hide:parentView];
    hud = [[MBProgressHUD alloc] initWithView:parentView];
    hud.tag = HUD_TAG;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelFont = [UIFont boldSystemFontOfSize:HUDTEXTSIZE];
    [parentView addSubview:hud];
    hud.labelText = msgText;
    [hud show:YES];
}


/**
 *  改变进度
 *
 *  @param parentView    承载HUD的View
 *  @param currentLength 当前完成length
 *  @param totalLength   总length
 */
- (void)changeProgress:(UIView *)parentView currentLength:(long long)currentLength totalLength:(long long)totalLength {
    hud.progress = currentLength / (float)totalLength;
}


/**
 *  改变提示文本
 *
 *  @param parentView 承载HUD的View
 *  @param text       修改后文本
 */
- (void)changeText:(UIView *)parentView text:(NSString *)text {
    MBProgressHUD * tempHUD = (MBProgressHUD *)[parentView viewWithTag:HUD_TAG];
    tempHUD.labelText = text;
}


/**
 *  隐藏HUD
 */
- (void)hide:(UIView *)parentView {
    MBProgressHUD * tempHUD = (MBProgressHUD *)[parentView viewWithTag:HUD_TAG];
    [tempHUD hide:YES];
}


@end
