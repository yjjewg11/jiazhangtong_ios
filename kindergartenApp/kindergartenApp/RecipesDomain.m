//
//  RecipesDomain.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "RecipesDomain.h"
#import "CookbookDomain.h"
#import "MJExtension.h"

@implementation RecipesDomain


//属性名映射
+(void)initialize{
    [super initialize];
    [RecipesDomain setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"list_time_1" : @"CookbookDomain",
                 @"list_time_2" : @"CookbookDomain",
                 @"list_time_3" : @"CookbookDomain",
                 @"list_time_4" : @"CookbookDomain",
                 @"list_time_5" : @"CookbookDomain"
                 };
    }];
}

@end
