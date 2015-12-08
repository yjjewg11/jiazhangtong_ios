//
//  DiscorveryTypeCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "DiscorveryTypeCell.h"

@interface DiscorveryTypeCell()

@property (weak, nonatomic) IBOutlet UILabel *numLblOfJingPingWenZhang;

@property (weak, nonatomic) IBOutlet UILabel *numLblOfTopic;

@property (weak, nonatomic) IBOutlet UILabel *numLblOfYouHuiHuoDong;

@end

@implementation DiscorveryTypeCell

- (void)awakeFromNib
{
    self.numLblOfJingPingWenZhang.layer.cornerRadius = 5;
    self.numLblOfJingPingWenZhang.layer.masksToBounds = YES;
    self.numLblOfTopic.layer.cornerRadius = 5;
    self.numLblOfTopic.layer.masksToBounds = YES;
    self.numLblOfYouHuiHuoDong.layer.cornerRadius = 5;
    self.numLblOfYouHuiHuoDong.layer.masksToBounds = YES;
}

- (IBAction)btnClick:(UIButton *)sender
{
    [self.delegate pushToVC:sender];
}

@end
