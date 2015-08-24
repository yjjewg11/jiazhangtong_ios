//
//  RecipesItemVO.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

//cell类型
typedef enum {
    RecipesItem_Base   = 0,  //基本信息
    RecipesItem_Recip  = 1,  //食谱
    RecipesItem_Desc   = 2,  //营养分析
    RecipesItem_None   = 3   //无数据
} RecipesItemType;

#import <Foundation/Foundation.h>
#import "RecipesDomain.h"

@interface RecipesItemVO : NSObject

@property (strong, nonatomic) NSString * headStr;
@property (strong, nonatomic) RecipesDomain * recipesDomain;
@property (assign, nonatomic) NSInteger  headHeight;
@property (assign, nonatomic) NSInteger  cellHeight;
@property (strong, nonatomic) NSArray  * cookbookArray;
@property (strong, nonatomic) UIView   * dzReplyView; //点赞回复视图
@property (assign, nonatomic) RecipesItemType recipesItemType;

- (instancetype)initItemVO:(NSString *)head cbArray:(NSArray *)cbArray;

@end
