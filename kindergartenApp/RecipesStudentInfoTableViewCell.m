//
//  RecipesStudentInfoTableViewCell.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/2.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "RecipesStudentInfoTableViewCell.h"
#import "KGHttpService.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "KGDateUtil.h"

@implementation RecipesStudentInfoTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"RecipesStudentInfoTableViewCell";
    RecipesStudentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecipesStudentInfoTableViewCell"  owner:self options:nil] lastObject];
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


- (void)resetCellParam:(RecipesItemVO *)recipes {
    timeLabel.text = recipes.headStr;
    weekLabel.text = [KGDateUtil weekdayFromDate:recipes.headStr];
    
    NSString * groupimg = [[KGHttpService sharedService] getGroupImgByUUID:recipes.recipesDomain.groupuuid];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:groupimg] placeholderImage:[UIImage imageNamed:@"group_head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:headImageView.width / Number_Two];
    }];
}

@end
