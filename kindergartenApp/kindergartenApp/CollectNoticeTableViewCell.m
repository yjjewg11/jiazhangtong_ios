//
//  CollectNoticeTableViewCell.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/16.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "CollectNoticeTableViewCell.h"

@implementation CollectNoticeTableViewCell

- (void)awakeFromNib {
    _flagImageView.layer.cornerRadius = _flagImageView.height/2.0;
}

//设置数据更新界面
- (void)setData:(FavoritesDomain *)data{
    _data = data;
    
    _myTitleLabel.text = data.title;
    _fromLabel.text = data.show_name;
    
    if(data.createtime) {
        NSDate * date = [KGDateUtil getDateByDateStr:data.createtime format:dateFormatStr2];
        _timeLabel.text = [KGNSStringUtil compareCurrentTime:date];
    }
    UIImage * defaultImage;
    if (data.type == Topic_Articles) {
        NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自%@",_fromLabel.text]];
        [attString addAttribute:NSForegroundColorAttributeName value:KGColorFrom16(0xff4966) range:NSMakeRange(2, attString.length-2)];
        _fromLabel.attributedText = attString;
        defaultImage = [UIImage imageNamed:@"group_head_def"];
    }else if (data.type == Topic_XYGG){
        defaultImage = [UIImage imageNamed:@"wenzhang"];
    }
    
    [_flagImageView sd_setImageWithURL:[NSURL URLWithString:data.show_img] placeholderImage:defaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_flagImageView setBorderWithWidth:Number_Zero color:[UIColor clearColor] radian:_flagImageView.width / Number_Two];
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
