//
//  NoDataTableViewCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/7.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "NoDataTableViewCell.h"

@implementation NoDataTableViewCell

- (void)awakeFromNib
{    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
