//
//  LoginRespDomain.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/19.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "LoginRespDomain.h"

@implementation LoginRespDomain

//- (id)init {
//    if (self = [super init]) {
//        self.list = [[NSMutableArray alloc] init];
//    }
//    return self;
//}

- (NSDictionary *)objectClassInArray
{
    return @{@"list" : [KGUser class]};
}

@end
