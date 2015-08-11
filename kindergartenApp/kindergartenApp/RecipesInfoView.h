//
//  RecipesInfoView.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/8.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipesDomain.h"

@interface RecipesInfoView : UIView <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView    * recipesTableView;
    NSMutableArray * recipesDataSourceMArray;
}

@property (strong, nonatomic) NSMutableArray * tableDataSource; //根据食谱对象重新封装
@property (strong, nonatomic) RecipesDomain  * recipesDomain;

//加载食谱数据
- (void)loadRecipesData:(RecipesDomain *)recipes;


@end
