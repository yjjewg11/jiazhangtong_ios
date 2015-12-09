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

- (void)setData:(DiscorveryNewNumberDomain *)domain
{
    if (domain.today_goodArticle <= 0)
    {
        self.numLblOfJingPingWenZhang.hidden = YES;
    }
    else if (domain.today_goodArticle > 99)
    {
        self.numLblOfJingPingWenZhang.text = @"99+";
    }
    else
    {
        self.numLblOfJingPingWenZhang.text = [NSString stringWithFormat:@"%ld",(long)domain.today_goodArticle];
    }
    
    if (domain.today_snsTopic <= 0)
    {
        self.numLblOfTopic.hidden = YES;
    }
    else if (domain.today_snsTopic > 99)
    {
        self.numLblOfTopic.text = @"99+";
    }
    else
    {
        self.numLblOfTopic.text = [NSString stringWithFormat:@"%ld",(long)domain.today_goodArticle];
    }
    
    if (domain.today_pxbenefit <= 0)
    {
        self.numLblOfYouHuiHuoDong.hidden = YES;
    }
    else if (domain.today_pxbenefit > 99)
    {
        self.numLblOfYouHuiHuoDong.text = @"99+";
    }
    else
    {
        self.numLblOfYouHuiHuoDong.text = [NSString stringWithFormat:@"%ld",(long)domain.today_goodArticle];
    }
}

@end
