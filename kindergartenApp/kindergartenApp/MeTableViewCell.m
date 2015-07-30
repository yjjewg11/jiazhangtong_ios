//
//  MeTableViewCell.m
//  kindergartenApp
//
//  Created by You on 15/7/23.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "MeTableViewCell.h"

@implementation MeTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



- (void)resetCellParam:(KGUser *)user {
    
    _nameLabel.text = user.name;
    
    NSString * otherInfoStr = [NSString stringWithFormat:@"昵称:%@   %@   %@", user.nickname, user.sex==Number_Zero ? @"女" : @"男", user.birthday];
    _otherInfoLabel.text = otherInfoStr;
}

@end
