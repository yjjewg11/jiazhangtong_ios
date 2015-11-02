//
//  ReplyPageDomain.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/7.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "ReplyPageDomain.h"
#import "MJExtension.h"

@implementation ReplyPageDomain


- (instancetype)init {
    self = [super init];
    if(self) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

//属性名映射
+(void)initialize{
    [super initialize];
    
    [self setupObjectClassInArray:^NSDictionary *{
        return @{@"data"   : @"ReplyDomain"};
    }];
}

@end
