//
//  RecipesItemVO.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipesItemVO : NSObject


@property (strong, nonatomic) NSString * headStr;
@property (strong, nonatomic) NSArray  * cookbookArray;

- (instancetype)initItemVO:(NSString *)head cbArray:(NSArray *)cbArray;

@end
