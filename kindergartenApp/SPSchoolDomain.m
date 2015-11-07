//
//  SPSchoolDomain.m
//  kindergartenApp
//
//  Created by Mac on 15/10/28.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPSchoolDomain.h"
#import "MJExtension.h"

@implementation SPSchoolDomain

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
