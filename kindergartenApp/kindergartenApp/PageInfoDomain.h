//
//  PageInfoDomain.h
//  kindergartenApp
//  page信息
//  Created by You on 15/7/21.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageInfoDomain : NSObject

@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger totalNo;
@property (strong, nonatomic) NSArray * data;


- (instancetype)initPageInfo:(NSInteger)page size:(NSInteger)size;

@end
