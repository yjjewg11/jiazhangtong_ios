//
//  SPTimetableDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/10/20.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"
#import "DianZanDomain.h"
#import "ReplyPageDomain.h"

@interface SPTimetableDomain : KGBaseDomain


@property (strong, nonatomic) NSString * name;              //课程名
@property (strong, nonatomic) NSString * readyfor;          //准备物品
@property (strong, nonatomic) NSString * address;           //上课地址
@property (strong, nonatomic) NSString * class_name;        //班级名称
@property (strong, nonatomic) NSString * group_name;        //培训机构名
@property (strong, nonatomic) NSString * student_headimg;   //学生头像
@property (strong, nonatomic) NSString * plandate;          //上课时间，年月日时分秒
@property (strong, nonatomic) DianZanDomain * dianzan;      //点赞数据
@property (strong, nonatomic) ReplyPageDomain * replyPage;  //帖子回复列表

@end
