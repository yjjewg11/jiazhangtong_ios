//
//  GiftwareArticlesTableViewCell.m
//  kindergartenApp
//
//  Created by You on 15/7/31.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "GiftwareArticlesTableViewCell.h"

#import "KGNSStringUtil.h"
#import "KGDateUtil.h"

@implementation GiftwareArticlesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    GiftwareArticlesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftwareArticlesTableViewCell"];
    if (!cell) {
        cell = [[GiftwareArticlesTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GiftwareArticlesTableViewCell"];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setAnnouncementDomain:(AnnouncementDomain *)announcementDomain{
    _announcementDomain = announcementDomain;
    [self settingModel:announcementDomain];
}

/**
 *  重置cell内容
 *
 *  @param baseDomain   cell需要的数据对象
 *  @param parameterDic 扩展字典
 */
- (void)resetValue:(id)baseDomain parame:(NSMutableDictionary *)parameterDic {
    [self settingModel:baseDomain];
}

- (void)settingModel:(id)baseDomain{
    AnnouncementDomain * domain = (AnnouncementDomain *)baseDomain;
    
    teacherLabel.text = domain.create_user;
    titleLabel.text = domain.title;
    contentLabel.text = domain.message;
    
    if(domain.create_time) {
        NSDate * date = [KGDateUtil getDateByDateStr:domain.create_time format:dateFormatStr2];
        timeLabel.text = [KGNSStringUtil compareCurrentTime:date];
    }
    
    if(domain.dianzan) {
        dzCountLabel.text = [NSString stringWithFormat:@"%ld", (long)domain.dianzan.count];
    }
}

@end
