//
//  YouHuiCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "YouHuiCell.h"
#import "UIImageView+WebCache.h"

@interface YouHuiCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *groupNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *zanCount;

@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

@implementation YouHuiCell

- (void)setData:(YouHuiDomain *)domain
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:domain.group_img] placeholderImage:[UIImage imageNamed:@""]];
    
    self.titleLbl.text = domain.title;
    
    self.groupNameLbl.text = domain.group_name;
    
    self.zanCount.text = domain.count;
    
    self.distance.text = domain.distance;
}

- (void)awakeFromNib
{
    
}


@end
