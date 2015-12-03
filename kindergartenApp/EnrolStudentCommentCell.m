//
//  EnrolStudentCommentCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentCommentCell.h"

@interface EnrolStudentCommentCell()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation EnrolStudentCommentCell

- (void)awakeFromNib
{
    
}

- (void)setData:(EnrolStudentSchoolCommentDomain *)domain
{
    self.name.text = domain.create_user;
    
    self.date.text = domain.create_time;
    
    self.content.text = domain.content;
    
    NSInteger intCount = (NSInteger)([domain.score intValue] / 10);
    
    NSInteger halfCount = [domain.score intValue] - intCount * 10;
    
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
