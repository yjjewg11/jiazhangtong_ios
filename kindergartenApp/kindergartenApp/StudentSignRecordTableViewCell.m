//
//  StudentSignRecordTableViewCell.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentSignRecordTableViewCell.h"
#import "StudentSignRecordDomain.h"
#import "UIImageView+WebCache.h"
#import "KGHttpService.h"
#import "KGUser.h"
#import "UIColor+Extension.h"

@implementation StudentSignRecordTableViewCell

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
    StudentSignRecordDomain * domain = (StudentSignRecordDomain *)baseDomain;
    KGUser * user = [[KGHttpService sharedService] getUserByUUID:domain.studentuuid];
    nameLabel.text = user.name;
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:user.headimg] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [headImageView setBorderWithWidth:Number_One color:KGColorFrom16(0xE7E7EE) radian:headImageView.width/Number_Two];
    }];
    
    timeLabel.text = domain.sign_time;
    addressLabel.text = domain.groupname;
    signNameLabel.text = domain.sign_name;
    typeLabel.text = domain.type;
}

@end
