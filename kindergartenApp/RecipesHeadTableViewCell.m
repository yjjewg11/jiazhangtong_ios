//
//  RecipesHeadTableViewCell.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/3.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "RecipesHeadTableViewCell.h"

@implementation RecipesHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)resetHead:(NSString *)headStr {
    headLabel.text = headStr;
}

@end
