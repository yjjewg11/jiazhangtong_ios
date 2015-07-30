//
//  TopicFrame.h
//  MYAPP
//
//  Created by Moyun on 15/7/1.
//  Copyright (c) 2015年 Moyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicDomain.h"
// 昵称字体

#define MYTopicCellTitleFont [UIFont boldSystemFontOfSize:16]
#define MYTopicCellNameFont [UIFont systemFontOfSize:14]
#define MYTopicCellContentFont [UIFont systemFontOfSize:15]
#define MYTopicCellDateFont [UIFont systemFontOfSize:10]
// cell的边框宽度
#define MYTopicCellBorderW 10
// cell内编剧
#define CELLPADDING  16
//cell内容宽度
#define CELLCONTENTWIDTH  [UIScreen mainScreen].bounds.size.width - 32

@interface TopicFrame : NSObject

@property (nonatomic,strong) TopicDomain * topic;

/** 用户信息 */
@property (nonatomic,assign) CGRect userViewF;
/** 用户信息 */
@property (nonatomic,assign) CGRect headImageViewF;
///** 用户名称 */
@property (nonatomic,assign) CGRect nameLabF;
/** 标题 */
@property (nonatomic,assign) CGRect titleLabF;

/** 内容 */
@property (nonatomic, assign) CGRect contentWebViewF;
/** 功能按钮视图 */
@property (nonatomic, assign) CGRect funViewF;
/** 发帖时间 */
@property (nonatomic,assign) CGRect dateLabelF;
/** 点赞按钮 */
@property (nonatomic,assign) CGRect dianzanBtnF;
/** 回复按钮 */
@property (nonatomic,assign) CGRect replyBtnF;

/** 点赞列表视图 */
@property (nonatomic, assign) CGRect dianzanViewF;
/** 点赞列表ICON */
@property (nonatomic, assign) CGRect dianzanIconImgF;
/** 点赞列表文本 */
@property (nonatomic, assign) CGRect dianzanLabelF;

/** 回复列表视图 */
@property (nonatomic, assign) CGRect replyViewF;
/** 回复输入框 */
@property (nonatomic, assign) CGRect replyTextFieldF;
/** 分割线 */
@property (nonatomic,assign) CGRect levelabF;


/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


@end
