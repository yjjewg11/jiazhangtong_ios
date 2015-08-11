//
//  RecipesDomain.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"
#import "DianZanDomain.h"
#import "ReplyPageDomain.h"

@interface RecipesDomain : KGBaseDomain

@property (strong, nonatomic) NSString * plandate;   //食谱日期.

@property (strong, nonatomic) NSString * analysis;   //膳食分析.纯文本

@property (strong, nonatomic) NSString * groupuuid;  //学校uuid

@property (strong, nonatomic) NSArray * list_time_1; //早餐列表

@property (strong, nonatomic) NSArray * list_time_2; //早上加餐列表

@property (strong, nonatomic) NSArray * list_time_3; //午餐列表

@property (strong, nonatomic) NSArray * list_time_4; //下午加餐列表

@property (strong, nonatomic) NSArray * list_time_5; //晚餐列表

@property (strong, nonatomic) NSString * share_url;  //用于分享的地址.全路径.

@property (assign, nonatomic) NSInteger count;       //浏览次数

@property (strong, nonatomic) DianZanDomain * dianzan;//点赞数据
@property (strong, nonatomic) ReplyPageDomain * replyPage; //帖子回复列表

@property (assign, nonatomic) BOOL isReqSuccessData;       //是否成功请求数据

@end
