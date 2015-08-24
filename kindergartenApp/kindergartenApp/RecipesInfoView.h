//
//  RecipesInfoView.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/8.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyDomain.h"
#import "RecipesDomain.h"
#import "TopicInteractionView.h"
#import "PromptView.h"

@interface RecipesInfoView : UIView <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView    * recipesTableView;
    NSMutableArray * recipesDataSourceMArray;
    TopicInteractionView * topicView;
    UITableViewCell * topicViewCell;
}

@property (strong, nonatomic) NSMutableArray * tableDataSource; //根据食谱对象重新封装
@property (strong, nonatomic) RecipesDomain  * recipesDomain;

//加载食谱数据
- (void)loadRecipesData:(RecipesDomain *)recipes;

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain;


@end
