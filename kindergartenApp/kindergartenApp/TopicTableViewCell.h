//
//  TopicTableViewCell.h
//  MYAPP
//
//  Created by Moyun on 15/7/1.
//  Copyright (c) 2015年 Moyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBVLinkedTextView.h"
@class TopicFrame;

@interface TopicTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) TopicFrame * topicFrame;
@property(nonatomic,assign) NSInteger    cellForRowIndex;


/** 用户信息 */
@property (nonatomic,weak) UIView * userView;
/** 用户头像 */
@property (nonatomic,weak) UIImageView * headImageView;
///** 用户名称 */
@property (nonatomic,weak) UILabel * nameLab;
/** 标题 */
@property (nonatomic,weak) UILabel * titleLab;

/** 内容 */
@property (nonatomic, weak) UIWebView  * contentWebView;
/** 功能按钮视图 */
@property (nonatomic, weak) UIView  * funView;
/** 发帖时间 */
@property (nonatomic,weak) UILabel * dateLabel;
/** 点赞按钮 */
@property (nonatomic,weak) UIButton * dianzanBtn;
/** 回复按钮 */
@property (nonatomic,weak) UIButton * replyBtn;

/** 点赞列表视图 */
@property (nonatomic, weak) UIView  * dianzanView;
/** 点赞列表ICON */
@property (nonatomic, weak) UIImageView * dianzanIconImg;

/** 点赞列表文本 */
@property (nonatomic, weak) UILabel * dianzanLabel;

/** 回复列表视图 */
@property (nonatomic, weak) HBVLinkedTextView  * replyView;

/** 回复输入框 */
@property (nonatomic, weak) UITextField  * replyTextField;
/** 分割线 */
@property (nonatomic,weak) UILabel * levelab;

@end
