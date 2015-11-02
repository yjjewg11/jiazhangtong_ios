//
//  TopicInteractionFrame.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/16.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicInteractionDomain.h"

@interface TopicInteractionFrame : NSObject

@property (strong, nonatomic) TopicInteractionDomain * topicInteractionDomain;

/** 功能按钮视图 */
@property (assign, nonatomic) CGRect    funViewF;
/** 发帖时间 */
@property (assign, nonatomic) CGRect    dateLabelF;
/** 浏览次数icon */
@property (assign, nonatomic) CGRect    browseCountImageViewF;
/** 浏览次数 */
@property (assign, nonatomic) CGRect    browseCountLabelF;
/** 点赞按钮 */
@property (assign, nonatomic) CGRect    dianzanBtnF;
/** 回复按钮 */
@property (assign, nonatomic) CGRect    replyBtnF;
/** 点赞列表视图 */
@property (assign, nonatomic) CGRect    dianzanViewF;
/** 点赞列表ICON */
@property (assign, nonatomic) CGRect    dianzanIconImgF;
/** 点赞列表文本 */
@property (assign, nonatomic) CGRect    dianzanLabelF;
/** 回复列表视图 */
@property (assign, nonatomic) CGRect    replyViewF;
/** 显示更多*/
@property (assign, nonatomic) CGRect    moreBtnF;
/** 回复输入框 */
@property (assign, nonatomic) CGRect    replyTextFieldF;

@property (assign, nonatomic) CGFloat   topicInteractHeight;

@end
