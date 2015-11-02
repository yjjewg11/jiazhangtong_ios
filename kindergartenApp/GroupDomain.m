//
//  GroupDomain.m
//  kindergartenApp
//
//  Created by You on 15/7/27.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "GroupDomain.h"
#import "MJExtension.h"

@implementation GroupDomain

//属性名映射
+(void)initialize{
    [super initialize];
    [self setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"groupDescription":@"description",
                 };
    }];
}

@end
