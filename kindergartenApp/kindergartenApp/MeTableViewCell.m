//
//  MeTableViewCell.m
//  kindergartenApp
//
//  Created by You on 15/7/23.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "MeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Extension.h"
#import "UIView+Extension.h"

@implementation MeTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



- (void)resetCellParam:(KGUser *)user {
    
    _nameLabel.text = user.name;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.headimg] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:self.headImageView.width / Number_Two];
    }];

    NSString * otherInfoStr = [NSString stringWithFormat:@"昵称:%@   %@   %@", user.nickname, user.sex==Number_One ? @"女" : @"男", user.birthday];
    _otherInfoLabel.text = otherInfoStr;
}

@end
