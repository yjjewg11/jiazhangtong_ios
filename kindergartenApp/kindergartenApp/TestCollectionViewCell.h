//
//  TestCollectionViewCell.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/2.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipesDomain.h"

@interface TestCollectionViewCell : UICollectionViewCell {
    
    
    IBOutlet UILabel *testLabel;
    
}


//加载食谱数据
- (void)loadRecipesData:(RecipesDomain *)recipesDomain;

@end
