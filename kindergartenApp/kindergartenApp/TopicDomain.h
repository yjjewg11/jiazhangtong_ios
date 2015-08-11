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
#import "ReplyPageDomain.h"

@interface TopicDomain : NSObject

@property (strong, nonatomic) NSString * uuid;      //Id

@property (strong, nonatomic) NSString * classuuid;  //关联班级id.需要转换成班级名

@property (strong, nonatomic) NSString * title;      //标题

@property (strong, nonatomic) NSString * content;    //内容HTML

@property (strong, nonatomic) NSString * imgs;       //帖子图片id 逗号分隔

@property (strong, nonatomic) NSArray  * imgsList;   //帖子图片列表

@property (strong, nonatomic) NSString * create_user;      //创建人名

@property (strong, nonatomic) NSString * create_useruuid;  //创建人uuid

@property (strong, nonatomic) NSString * create_time;  //创建时间

@property (strong, nonatomic) NSString * reply_time;   //最新回复时间

@property (strong, nonatomic) NSString * update_time;  //最新更新时间

@property (strong, nonatomic) NSString * share_url; //用于分享的全路径

@property (assign, nonatomic) NSInteger count; //流量次数

@property (assign, nonatomic) NSInteger usertype; //

@property (strong, nonatomic) DianZanDomain * dianzan;//点赞数据

@property (strong, nonatomic) ReplyPageDomain * replyPage; //帖子回复列表

/** rongyugaodu */
@property (nonatomic,assign)CGFloat cellH;
@property (nonatomic,assign)CGFloat contentLabH;


@end
