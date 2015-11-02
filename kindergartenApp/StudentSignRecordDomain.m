//
//  StudentSignRecordDomain.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentSignRecordDomain.h"

@implementation StudentSignRecordDomain


- (void)setType:(NSString *)type {
    _type = type;
    
    switch ([_type integerValue]) {
        case 1:
            _type = @"家长打卡";
            break;
        case 2:
            _type = @"老师签到";
            break;
        case 3:
            _type = @"家长签到";
            break;
    }
}

@end
