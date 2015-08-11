//
//  QueryChatsVO.h
//  kindergartenApp
//  查询和老师或者园长的Request VO
//  Created by You on 15/8/4.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryChatsVO : NSObject

@property (strong, nonatomic) NSString * uuid; //查询和老师为老师UUID  查询和园长则为幼儿园UUID
@property (assign, nonatomic) NSInteger  pageNo;
@property (assign, nonatomic) BOOL       isTeacher; // 1=老师，0=园长

@end
