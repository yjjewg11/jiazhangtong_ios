//
//  SpCourseHomeCourseCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/26.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseHomeCourseCell.h"
#import "UIImageView+WebCache.h"

@interface SpCourseHomeCourseCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIButton *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *groupNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *locationLbl;

@property (weak, nonatomic) IBOutlet UILabel *studyPersonNum;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;

@property (weak, nonatomic) IBOutlet UIView *containerView;



@end

@implementation SpCourseHomeCourseCell

- (void)awakeFromNib
{
    
}

- (void)setCourseCellData:(SPCourseDomain *)domain
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:domain.logo] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.titleLbl.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.titleLbl setTitle:domain.title forState:UIControlStateNormal];
    
    self.groupNameLbl.text = domain.group_name;
    
    self.locationLbl.text = domain.address;
    
    self.studyPersonNum.text = [NSString stringWithFormat:@"%ld",(long)domain.ct_study_students];
    
    self.distanceLbl.text = domain.distance;
    
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
