//
//  RecipesCollectionViewCell.h
//  kindergartenApp
//  食谱Cell
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipesDomain.h"

@interface RecipesCollectionViewCell : UICollectionViewCell <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView * recipesTableView;
    NSMutableArray       * recipesDataSourceMArray;
    RecipesDomain  * recipes;
}

@property (strong, nonatomic) NSMutableArray * tableDataSource; //根据食谱对象重新封装

//加载食谱数据
- (void)loadRecipesData:(RecipesDomain *)recipesDomain;

//加载食谱数据
- (void)loadRecipesInfoByData:(NSString *)dateStr;



@end
