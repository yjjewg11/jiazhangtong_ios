//
//  LoginRespDomain.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/19.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "LoginRespDomain.h"
#import "MJExtension.h"

@implementation LoginRespDomain

//属性名映射
+(void)initialize{
    [super initialize];
    
    [self setupObjectClassInArray:^NSDictionary *{
        return @{@"list"   : @"KGUser"};
    }];
}


@end
