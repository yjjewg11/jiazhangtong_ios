//
//  RecipesStudentInfoTableViewCell.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/2.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "RecipesStudentInfoTableViewCell.h"

@implementation RecipesStudentInfoTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"RecipesStudentInfoTableViewCell";
    RecipesStudentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecipesStudentInfoTableViewCell"  owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)resetCellParam:(RecipesDomain *)recipes {
    timeLabel.text = recipes.plandate;
}

@end
