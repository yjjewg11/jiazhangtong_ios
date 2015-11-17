//
//  MySPNormalCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/16.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPNormalCell.h"

@interface MySPNormalCell()

@end

@implementation MySPNormalCell

- (void)setData:(MySPCourseTeacherList *)domain
{
    if (domain.name == nil || [domain.name isEqualToString:@""])
    {
        self.teacherNameLbl.text = @"学校评价";
    }
    else
    {
        self.teacherNameLbl.text = domain.name;
    }
    
    NSInteger intCount = (NSInteger)([domain.score integerValue] / 10);
    
    NSInteger halfCount = [domain.score integerValue] - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
}

- (void)setSchoolData:(MySPCommentDomain *)domain
{
    NSInteger intCount = (NSInteger)([domain.score integerValue] / 10);
    
    NSInteger halfCount = [domain.score integerValue] - intCount * 10;
    
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
                    [btn setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateNormal];
                }
                if (btn.tag == intCount)
                {
                    if (halfCount > 5)
                    {
                        [btn setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateNormal];
                    }
                    else if(halfCount > 0 && halfCount <=5)
                    {
                        [btn setImage:[UIImage imageNamed:@"bankexing30"] forState:UIControlStateNormal];
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
                
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

- (void)btnClick:(UIButton *)btn
{
    NSLog(@"%d",btn.tag);
}

@end
