//
//  AnnouncementTableViewCell.m
//  kindergartenApp
//
//  Created by You on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AnnouncementTableViewCell.h"
#import "AnnouncementDomain.h"
#import "KGDateUtil.h"
#import "KGNSStringUtil.h"
#import "KGHttpService.h"
#import "UIImageView+WebCache.h"

@implementation AnnouncementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setData:(AnnouncementDomain *)domain
{
    titleLabel.text = domain.title;
    subTitleLabel.text = domain.message;
    groupLabel.text = [[KGHttpService sharedService] getGroupNameByUUID:domain.groupuuid];
    if(domain.create_time) {
        NSDate * date = [KGDateUtil getDateByDateStr:domain.create_time format:dateFormatStr2];
        timeLabel.text = [KGNSStringUtil compareCurrentTime:date];
    }
    
    NSString * groupImg = [[KGHttpService sharedService] getGroupImgByUUID:domain.groupuuid];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:groupImg] placeholderImage:[UIImage imageNamed:@"group_head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [headImageView setBorderWithWidth:Number_Zero color:[UIColor clearColor] radian:headImageView.width / Number_Two];
    }];

}

@end
