//
//  ReplyDomain.h
//  kindergartenApp
//  帖子回复对象
//  Created by yangyangxun on 15/7/25.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"
#import "DianZanDomain.h"

@interface ReplyDomain : KGBaseDomain

@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * newsuuid;
@property (strong, nonatomic) NSString * img;
@property (assign, nonatomic) KGTopicType type;
@property (strong, nonatomic) NSString * classuuid;   //关联班级id.需要转换成班级名
@property (strong, nonatomic) NSString * title;   //标题
@property (strong, nonatomic) NSString * create_user;   //创建人名
@property (strong, nonatomic) NSString * create_useruuid;//创建人uuid
@property (strong, nonatomic) NSString * create_img;      //创建人头像
@property (strong, nonatomic) NSString * create_time;    //创建时间
@property (strong, nonatomic) NSString * reply_time;     //最新回复时间
@property (strong, nonatomic) NSString * update_time;    //最新更新时间
@property (assign, nonatomic) NSInteger  count; //点赞次数
@property (strong, nonatomic) DianZanDomain * dianzan;//点赞数据

@end
