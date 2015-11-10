//
//  SpCourseCell.m
//  kindergartenApp
//
//  Created by Mac on 15/10/23.
//  Copyright © 2015年 ;. All rights reserved.
//

#import "SpCourseCell.h"
#import "UIImageView+WebCache.h"


@interface SpCourseCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIButton *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *groupNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *locationLbl;

@property (weak, nonatomic) IBOutlet UILabel *studyPersonNum;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;

@end

@implementation SpCourseCell

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
                    else if(halfCount > 0 && halfCount <5)
                    {
                        [btn setImage:[UIImage imageNamed:@"banekexing"] forState:UIControlStateNormal];
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

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCourseCellData:(SPCourseDomain *)domain
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:domain.logo] placeholderImage:[UIImage imageNamed:@""]];
    
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

- (void)setSchoolCellData:(SPSchoolDomain *)domain
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:domain.img] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    [self.titleLbl setTitle:domain.brand_name forState:UIControlStateNormal];
    
    self.groupNameLbl.text = domain.summary;
    
    self.locationLbl.text = domain.address;
    
    self.studyPersonNum.text = [NSString stringWithFormat:@"%ld",(long)domain.ct_study_students];
    
    self.distanceLbl.text = domain.distance;
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
}


@end
