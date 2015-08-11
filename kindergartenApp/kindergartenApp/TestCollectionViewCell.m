//
//  TestCollectionViewCell.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/2.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TestCollectionViewCell.h"

@implementation TestCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

//加载食谱数据
- (void)loadRecipesData:(RecipesDomain *)recipesDomain; {
    testLabel.text = recipesDomain.analysis;
    
}

@end
