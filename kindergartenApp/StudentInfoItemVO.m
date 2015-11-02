//
//  StudentInfoItemVO.m
//  kindergartenApp
//
//  Created by You on 15/7/23.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentInfoItemVO.h"

@implementation StudentInfoItemVO

- (instancetype)init {
    self = [super init];
    if(self) {
        _isArrow = YES;
        _cellHeight = 35;
        _headHeight = Cell_Height2;
    }
    return self;
}

@end
