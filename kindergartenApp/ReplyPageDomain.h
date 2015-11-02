//
//  ReplyPageDomain.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/7.
//  Copyright (c) 2015年 funi. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ReplyPageDomain : NSObject

@property (assign, nonatomic) NSInteger totalCount; //总数.
@property (assign, nonatomic) NSInteger pageSize; //每页显示限制.
@property (assign, nonatomic) NSInteger pageNo;   //当前页数
@property (strong, nonatomic) NSMutableArray * data;     //班级互动列表对象.下面内容说明


@end
