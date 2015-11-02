//
//  StudentSignRecordDomain.h
//  kindergartenApp
//  签到记录
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface StudentSignRecordDomain : KGBaseDomain

@property (strong, nonatomic) NSString * type; //1:家长打卡,2:老师签到,3:家长签到

@property (strong, nonatomic) NSString * studentuuid; //关联学生uuid

@property (strong, nonatomic) NSString * cardid;    //刷卡的卡号.

@property (strong, nonatomic) NSString * sign_time; //刷卡时间.时间字符串

@property (strong, nonatomic) NSString * groupuuid; //刷卡幼儿园uuid

@property (strong, nonatomic) NSString * groupname; //刷卡地点,幼儿园名

@property (strong, nonatomic) NSString * sign_name; //刷卡人名


@end
