//
//  FuniPullReFresh.m
//  Guarantee
//
//  Created by rockyang on 14-5-14.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import "KGTableParam.h"

@implementation KGTableParam

- (id)init{
    self = [super init];
    if(self){
        _sectionCount    = 1;
        _isPullReFresh   = YES;
        _isUpPullReFresh = YES;
        _paramMDict      = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
