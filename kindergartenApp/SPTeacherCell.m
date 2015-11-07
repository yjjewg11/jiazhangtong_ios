//
//  SPTeacherCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPTeacherCell.h"
#import "UIImageView+WebCache.h"

@interface SPTeacherCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIButton *teacherNameLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *courseNames;

@property (weak, nonatomic) IBOutlet UILabel *teacherInfo;

@end


@implementation SPTeacherCell

- (void)setTeacherCellData:(SPTeacherDomain * )domain
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:domain.img] placeholderImage:[UIImage imageNamed:@""]];
    
    [self.teacherNameLbl setTitle:domain.name forState:UIControlStateNormal];
    [self.teacherNameLbl setTitle:domain.name forState:UIControlStateHighlighted];
    
    self.courseNames.text = domain.course_title;
    
    self.teacherInfo.text = domain.summary;
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount;
    
    [self setUpStarts:intCount halfCount:halfCount];
}

- (void)setUpStarts:(NSInteger)intCount halfCount:(NSInteger)halfCount
{
    for (NSInteger i = 0; i<intCount; i++)
    {
        if(i == intCount)
        {
            if (halfCount >= 5)
            {
                UIButton *starBtn = self.starView.subviews[i];
                starBtn.imageView.image = [UIImage imageNamed:@"bankexing"];
                break;
            }
            
            else
            {
                break;
            }
        }
        UIButton *starBtn = self.starView.subviews[i];
        starBtn.imageView.image = [UIImage imageNamed:@"xing"];
    }
}

@end
