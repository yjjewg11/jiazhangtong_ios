//
//  ClassNewsDomain.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/22.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TopicDomain.h"
#import "MJExtension.h"

@implementation TopicDomain

//属性名映射
+(void)initialize{
    [super initialize];
    
    [self setupObjectClassInArray:^NSDictionary *{
        return @{@"imgsList"   : @"NSSring"};
    }];
}


- (void)setContent:(NSString *)content {
    _content = [[content stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
}


@end
