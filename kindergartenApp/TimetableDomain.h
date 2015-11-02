//
//  TimetableDomain.h
//  kindergartenApp
//
//  Created by You on 15/8/10.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"
#import "DianZanDomain.h"
#import "ReplyPageDomain.h"

@interface TimetableDomain : KGBaseDomain

@property (strong, nonatomic) NSString * afternoon; //上午课程
@property (strong, nonatomic) NSString * classuuid; //班级uuid
@property (assign, nonatomic) NSInteger  count;
@property (strong, nonatomic) NSString * create_useruuid;
@property (strong, nonatomic) NSString * morning; //下午课程
@property (strong, nonatomic) NSString * plandate;//日期
@property (strong, nonatomic) DianZanDomain * dianzan;//点赞数据
@property (strong, nonatomic) ReplyPageDomain * replyPage; //帖子回复列表

@end
