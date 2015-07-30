//
//  ClassNewsDomain.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/22.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DianZanDomain.h"
#import "ReplyDomain.h"

@interface TopicDomain : NSObject

@property (strong, nonatomic) NSString * uuid;      //Id

@property (strong, nonatomic) NSString * classuuid;  //关联班级id.需要转换成班级名

@property (strong, nonatomic) NSString * title;      //标题

@property (strong, nonatomic) NSString * content;    //内容HTML

@property (strong, nonatomic) NSString * create_user;      //创建人名

@property (strong, nonatomic) NSString * create_useruuid;  //创建人uuid

@property (strong, nonatomic) NSString * create_time;  //创建时间

@property (strong, nonatomic) NSString * reply_time;   //最新回复时间

@property (strong, nonatomic) NSString * update_time;  //最新更新时间

@property (strong, nonatomic) NSString * share_url; //用于分享的全路径

@property (assign, nonatomic) NSInteger count; //流量次数

@property (strong, nonatomic) DianZanDomain * dianZanDomain;//点赞数据

@property (strong, nonatomic) NSMutableArray * replyMArray; //帖子回复列表

@property (assign, nonatomic) BOOL isReqDianZan;//是否请求过点赞数据

@property (assign, nonatomic) BOOL isReqReplyMArray; //是否请求过帖子回复列表


/** rongyugaodu */
@property (nonatomic,assign)CGFloat cellH;
@property (nonatomic,assign)CGFloat contentLabH;


@end
