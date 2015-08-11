//
//  RecipesStudentInfoTableViewCell.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/2.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipesDomain.h"

@interface RecipesStudentInfoTableViewCell : UITableViewCell {
    
    IBOutlet UIImageView * headImageView;
    IBOutlet UILabel * timeLabel;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)resetCellParam:(RecipesDomain *)recipes;

@end
