//
//  TopicInteractionView.h
//  kindergartenApp
//  帖子互动部分  包含： 点赞、回复按钮和列表
//  Created by You on 15/7/30.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DianZanDomain.h"
#import "ReplyPageDomain.h"
#import "HBVLinkedTextView.h"
#import "KGTextField.h"
#import "ReplyDomain.h"
#import "MLEmojiLabel.h"
#import "TopicInteractionFrame.h"

@interface TopicInteractionView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) TopicInteractionFrame * topicInteractionFrame;
@property (strong, nonatomic) DianZanDomain   * dianzan;//点赞数据
@property (strong, nonatomic) ReplyPageDomain * replyPage; //帖子回复列表
@property (strong, nonatomic) NSString        * topicUUID; //帖子UUID
@property (assign, nonatomic) KGTopicType       topicType; //帖子类型

/** 功能按钮视图 */
@property (strong, nonatomic) UIView   * funView;
/** 发帖时间 */
@property (strong, nonatomic) UILabel  * dateLabel;
/** 浏览次数icon */
@property (strong, nonatomic) UIImageView  * browseCountImageView;
/** 浏览次数 */
@property (strong, nonatomic) UILabel  * browseCountLabel;
/** 点赞按钮 */
@property (strong, nonatomic) UIButton * dianzanBtn;
/** 回复按钮 */
@property (strong, nonatomic) UIButton * replyBtn;
/** 点赞列表视图 */
@property (strong, nonatomic) UIView   * dianzanView;
/** 点赞列表ICON */
@property (strong, nonatomic) UIImageView * dianzanIconImg;
/** 点赞列表文本 */
@property (strong, nonatomic) MLEmojiLabel  * dianzanLabel;
/** 回复列表视图 */
@property (strong, nonatomic) MLEmojiLabel  * replyView;
/** 显示更多*/
@property (strong, nonatomic) UIButton * moreBtn;
/** 回复输入框 */
@property (strong, nonatomic) KGTextField * replyTextField;


//重置点赞列表
- (void)resetDZName:(BOOL)isAdd name:(NSString *)name;

//重置回复
- (void)resetReplyList:(ReplyDomain *)replyDomain;

@end
