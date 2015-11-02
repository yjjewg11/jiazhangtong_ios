//
//  PageInfoDomain.m
//  kindergartenApp
//
//  Created by You on 15/7/21.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "PageInfoDomain.h"

@implementation PageInfoDomain


- (instancetype)initPageInfo:(NSInteger)page size:(NSInteger)size {
    self = [super init];
    if(self) {
        _pageNo = page;
        _pageSize = size;
    }
    
    return self;
}

@end
