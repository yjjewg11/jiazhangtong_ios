//
//  TopicInteractViewController.h
//  kindergartenApp
//  有点赞回复的base VC
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"
#import "ReplyDomain.h"

@interface BaseTopicInteractViewController : BaseKeyboardViewController

@property (strong, nonatomic) NSString        * topicUUID;  //帖子UUID
@property (assign, nonatomic) KGTopicType       topicType; //帖子类型

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain;

@end
