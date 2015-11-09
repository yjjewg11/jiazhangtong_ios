//
//  SPCouseInfoCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPCouseInfoCell.h"

@interface SPCouseInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *courseTotalTime;
@property (weak, nonatomic) IBOutlet UILabel *fees;
@property (weak, nonatomic) IBOutlet UILabel *discountfees;
@property (weak, nonatomic) IBOutlet UIView *starView;


@property (weak, nonatomic) IBOutlet UILabel *feeLbl;
@property (weak, nonatomic) IBOutlet UILabel *discountfeesLbl;

@end


@implementation SPCouseInfoCell

- (void)setDomain:(SPCourseDetailDomain *)domain
{
    _domain = domain;
    
    self.rowHeight = 169;
    
    self.titleLbl.text = domain.title;
    
    self.location.text = domain.address;
    
    self.courseTotalTime.text = domain.schedule;
    
    if (domain.fees == 0)
    {
        [self.feeLbl setHidden:YES];
        [self.fees setHidden:YES];
        self.rowHeight -= 25;
    }
    else
    {
        self.fees.text = [NSString stringWithFormat:@"%.2f",domain.fees];
    }
    
    if (domain.discountfees == 0)
    {
        [self.discountfeesLbl setHidden:YES];
        [self.discountfees setHidden:YES];
        self.rowHeight -= 25;
    }
    else
    {
        self.discountfees.text = [NSString stringWithFormat:@"%.2f",domain.discountfees];
    }
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
    
}

- (void)setUpStarts:(NSInteger)intCount halfCount:(NSInteger)halfCount
{
    for (NSInteger i = 0; i < 5; i++)
    {
        for (UIButton * btn in self.starView.subviews)
        {
            if (btn.tag == i)
            {
                if (btn.tag < intCount)
                {
                    [btn setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
                }
                
                if (btn.tag == intCount)
                {
                    if (halfCount >= 5)
                    {
                        [btn setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btn setImage:[UIImage imageNamed:@"banekexing"] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}


@end
