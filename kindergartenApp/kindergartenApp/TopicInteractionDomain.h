//
//  TopicInteractionDomain.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/16.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DianZanDomain.h"
#import "ReplyPageDomain.h"

@interface TopicInteractionDomain : NSObject

@property (strong, nonatomic) DianZanDomain   * dianzan;   //点赞数据
@property (strong, nonatomic) ReplyPageDomain * replyPage; //帖子回复列表
@property (strong, nonatomic) NSString        * topicUUID; //帖子UUID
@property (assign, nonatomic) KGTopicType       topicType; //帖子类型
@property (assign, nonatomic) KGTopicBrowseType borwseType;//浏览类型
@property (strong, nonatomic) NSString        * createTime;//贴子创建时间

@end
