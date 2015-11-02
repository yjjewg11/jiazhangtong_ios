//
//  FuniMessageView.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/5/30.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGMessageView.h"

@implementation KGMessageView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor    = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.layer.cornerRadius = 4;
    self.alpha              = 0;
    CGFloat width = APPWINDOWWIDTH - 80;
    [self setWidth:width];
    [self setX:(APPWINDOWWIDTH-width) / 2];
    [self setY:26];
}


/**
 *  设置消息文本
 *
 *  @param msg 消息文本
 */
- (void)setMessageText:(NSString *)msg{
    messageLabel.text = msg;
    [self showMessageViewAnimate];
}


/**
 *  动画show消息
 */
- (void)showMessageViewAnimate{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideMessageViewAnimate) userInfo:nil repeats:NO];
                     }];
}


/**
 *  动画hide消息
 */
- (void)hideMessageViewAnimate{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [timer invalidate];
                     }];
}

@end
