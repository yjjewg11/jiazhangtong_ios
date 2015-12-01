//
//  SpTeacherInfoCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpTeacherInfoCell.h"
#import "UIImageView+WebCache.h"

@interface SpTeacherInfoCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *starVIew;

@property (weak, nonatomic) IBOutlet UILabel *teacherCourse;

@end

@implementation SpTeacherInfoCell

- (void)awakeFromNib
{
    
}

- (void)setData:(SPTeacherDetailDomain *)domain
{
    [self.img sd_setImageWithURL:[NSURL URLWithString:domain.img] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 50;
    self.img.layer.borderWidth = 1;
    self.img.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    
    self.name.text = domain.name;
    
    self.teacherCourse.text = domain.course_title;
    
//    self.teacherInfo.text = domain.summary;
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
}

- (void)setUpStarts:(NSInteger)intCount halfCount:(NSInteger)halfCount
{
    for (NSInteger i = 0; i < 5; i++)
    {
        for (UIButton * btn in self.starVIew.subviews)
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
