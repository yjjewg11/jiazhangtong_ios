//
//  SpCourseDetailCourseInfo.m
//  kindergartenApp
//
//  Created by Mac on 16/1/6.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "SpCourseDetailCourseInfo.h"

@interface SpCourseDetailCourseInfo()
{
    __weak IBOutlet UILabel *courseNameLbl;
    
    __weak IBOutlet UILabel *locationLbl;
    
    __weak IBOutlet UILabel *studyStuNum;
    
    __weak IBOutlet UILabel *courseDuringTime;
    
    __weak IBOutlet UILabel *courseAge;
    
    __weak IBOutlet UIView *starView;
    
    __weak IBOutlet UILabel *scoreLbl;
    
    __weak IBOutlet UILabel *commentNum;
}

@end

@implementation SpCourseDetailCourseInfo

- (void)awakeFromNib
{
    
}

- (void)setData:(SPCourseDetailDomain *)domain
{
    courseNameLbl.text = domain.title;
    locationLbl.text = domain.address;
    studyStuNum.text = [NSString stringWithFormat:@"已报名%ld",(long)domain.ct_study_students];
    courseDuringTime.text = [NSString stringWithFormat:@"课程学时:%@",domain.schedule];
    courseAge.text = [NSString stringWithFormat:@"适合年龄:%@",domain.age_min_max];
    scoreLbl.text = [NSString stringWithFormat:@"%.1f",(domain.ct_stars / 10.00)];
    commentNum.text = [NSString stringWithFormat:@"%@人评价",domain.commentNum];
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
}

- (IBAction)mapClicked:(id)sender
{
    NSLog(@"aa");
}

- (void)setUpStarts:(NSInteger)intCount halfCount:(NSInteger)halfCount
{
    for (NSInteger i = 0; i < 5; i++)
    {
        for (UIImageView * btn in starView.subviews)
        {
            if (btn.tag == i)
            {
                if (btn.tag < intCount)
                {
                    btn.image = [UIImage imageNamed:@"xing"];
                }
                if (btn.tag == intCount)
                {
                    if (halfCount > 5)
                    {
                        btn.image = [UIImage imageNamed:@"xing"];
                    }
                    else if(halfCount > 0 && halfCount <=5)
                    {
                        btn.image = [UIImage imageNamed:@"bankexing"];
                    }
                    else
                    {
                        btn.image = [UIImage imageNamed:@"xing1"];
                    }
                }
                if (btn.tag > intCount)
                {
                    btn.image = [UIImage imageNamed:@"xing1"];
                }
            }
        }
    }
}
@end
