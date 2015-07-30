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

@implementation AnnouncementTableViewCell

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
    AnnouncementDomain * domain = (AnnouncementDomain *)baseDomain;
    
    titleLabel.text = domain.title;
//    subTitleLabel.text = domain.
    groupLabel.text = [[KGHttpService sharedService] getGroupNameByUUID:domain.groupuuid];
    if(domain.create_time) {
        NSDate * date = [KGDateUtil getDateByDateStr:domain.create_time format:dateFormatStr2];
        timeLabel.text = [KGNSStringUtil compareCurrentTime:date];
    }
    
}

@end
