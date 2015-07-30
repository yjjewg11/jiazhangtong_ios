//
//  FuniMessageView.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/5/30.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGMessageView : UIView {
    //消息Label
    IBOutlet UILabel * messageLabel;
    //消息显示的timer
    NSTimer          * timer;
}

/**
 *  设置消息文本
 *
 *  @param msg 消息文本
 */
- (void)setMessageText:(NSString *)msg;

@end
