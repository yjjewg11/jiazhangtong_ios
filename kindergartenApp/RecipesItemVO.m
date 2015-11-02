//
//  RecipesItemVO.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "RecipesItemVO.h"

@implementation RecipesItemVO


- (instancetype)initItemVO:(NSString *)head cbArray:(NSArray *)cbArray {
    self = [self init];
    if(self) {
        _headStr = head;
        _cookbookArray = cbArray;
    }
    
    return self;
}

@end
