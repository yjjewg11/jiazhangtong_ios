//
//  ReplyTableViewCell.m
//  kindergartenApp
//
//  Created by You on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import "ReplyDomain.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "KGDateUtil.h"
#import "KGNSStringUtil.h"

@implementation ReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    messageLabel.customEmojiRegex = String_DefValue_EmojiRegex;
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
    ReplyDomain * domain = (ReplyDomain *)baseDomain;
    
    titleLabel.text = domain.title;
    messageLabel.text = domain.content;
    dzCountLabel.text = [NSString stringWithFormat:@"%ld", (long)domain.dianzan.count];
    
    NSDate * date = [KGDateUtil getDateByDateStr:domain.create_time format:dateFormatStr2];
    timeLabel.text = [KGNSStringUtil compareCurrentTime:date];
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:domain.create_img] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:headImageView.width / Number_Two];
    }];
}

@end
