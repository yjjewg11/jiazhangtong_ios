//
//  SpCourseAndSchoolListSchoolCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/30.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseAndSchoolListSchoolCell.h"
#import "UIImageView+WebCache.h"

@interface SpCourseAndSchoolListSchoolCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UIButton *schoolName;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *studyStuNum;

@property (weak, nonatomic) IBOutlet UILabel *schoolTitle;

@property (weak, nonatomic) IBOutlet UILabel *location;

@end

@implementation SpCourseAndSchoolListSchoolCell

- (void)awakeFromNib
{
    
}

- (void)setData:(SPSchoolDomain *)domain
{
    [self.img sd_setImageWithURL:[NSURL URLWithString:domain.img] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    [self.schoolName setTitle:domain.brand_name forState:UIControlStateNormal];
    
    self.studyStuNum.text = [NSString stringWithFormat:@"%ld",(long)domain.ct_study_students];
    
    self.schoolTitle.text = domain.summary;
    
    self.location.text = domain.address;
    
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
                    if (halfCount > 5)
                    {
                        [btn setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
                    }
                    else if(halfCount > 0 && halfCount <=5)
                    {
                        [btn setImage:[UIImage imageNamed:@"bankexing"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
                    }
                }
                if (btn.tag > intCount)
                {
                    [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
                }
            }
        }
    }
}

@end
