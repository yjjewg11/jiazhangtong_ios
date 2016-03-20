//
//  FPHomeTimeLineSectionHeaderTableViewCell.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeTimeLineSectionHeaderTableViewCell.h"
@interface FPHomeTimeLineSectionHeaderTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@property (weak, nonatomic) IBOutlet UILabel *total;

@end
@implementation FPHomeTimeLineSectionHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setDateAndCount:(NSString *)dateStr total:(NSInteger *)total {
    
    self.dateLbl.text = dateStr;
    self.total.text = [NSString stringWithFormat:@"共%d张",total];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
