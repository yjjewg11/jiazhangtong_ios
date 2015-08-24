//
//  MessageTableViewCell.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MessageDomain.h"
#import "KGHttpService.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/**
 *  重置cell内容
 *
 *  @param baseDomain   cell需要的数据对象
 *  @param parameterDic 扩展字典
 */
- (void)resetValue:(id)baseDomain parame:(NSMutableDictionary *)parameterDic {
    MessageDomain * domain = (MessageDomain *)baseDomain;
    _titleLabel.text = domain.title;
    _subTitleLabel.text = domain.message;
    _timeLabel.text = domain.create_time;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[KGHttpService sharedService].groupDomain.img] placeholderImage:[UIImage imageNamed:@"group_head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.headImageView setBorderWithWidth:Number_Zero color:[UIColor clearColor] radian:self.headImageView.width / Number_Two];
    }];
    
    _unReadIconImageView.hidden = domain.isread;
}

@end
