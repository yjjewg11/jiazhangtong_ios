//
//  MeFunTableViewCell.m
//  kindergartenApp
//
//  Created by You on 15/7/23.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "MeFunTableViewCell.h"

@implementation MeFunTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)resetCellParam:(NSString *)funText img:(NSString *)funImg {
    _funTextLabel.text = funText;
}

@end
