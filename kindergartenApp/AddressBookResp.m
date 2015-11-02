//
//  AddressBookResp.m
//  kindergartenApp
//
//  Created by You on 15/8/4.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AddressBookResp.h"
#import "MJExtension.h"

@implementation AddressBookResp

//属性名映射
+(void)initialize{
    [super initialize];
    
    [self setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"list"   : @"AddressBookDomain",
                 @"listKD" : @"AddressBookDomain"
                 };
    }];
}

@end
