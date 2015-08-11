//
//  AddressbookTableViewCell.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/5.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AddressbookTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"

#define ABTableViewCellID @"AddressbookTableViewCell"

@implementation AddressbookTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    AddressbookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ABTableViewCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressbookTableViewCell"  owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

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
    domain = (AddressBookDomain *)baseDomain;
    
    nameLabel.text = domain.name;
    if(!domain.tel || [domain.tel isEqualToString:String_DefValue_Empty]) {
        telBtn.hidden = YES;
        
        [nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(55);
        }];
    }
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:domain.img] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:headImageView.width / Number_Two];
    }];

}

- (IBAction)addressbookFunBtnClicked:(UIButton *)sender {
    NSDictionary * dic = @{@"addressBookDomain" : domain,
                           @"type" : [NSNumber numberWithInteger:sender.tag]};
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_AddressbookCellFun object:self userInfo:dic];
}

@end
