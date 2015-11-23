//
//  MySPTeacherCommentCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/18.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPTeacherCommentCell.h"

@implementation MySPTeacherCommentCell

- (NSMutableArray *)teacherList
{
    if (_teacherList == nil)
    {
        _teacherList = [NSMutableArray array];
    }
    return _teacherList;
}

- (void)awakeFromNib
{
    [self setUpBtns];
    
    for (NSInteger i=0; i<self.teacherList.count; i++)
    {
        if (self.row == i)
        {
            ((MySPCourseTeacherList *)self.teacherList[i]).score = [NSString stringWithFormat:@"50"];
        }
    }
}

- (void)btnClick:(UIButton *)btn
{
    for (UIButton *btn in self.starView.subviews)
    {
        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateDisabled];
    }
    
    for (NSInteger i=0; i<btn.tag+1; i++)
    {
        [self.starView.subviews[i] setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateNormal];
        
        [self.starView.subviews[i] setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateDisabled];
    }
    
    for (NSInteger i=0; i<self.teacherList.count; i++)
    {
        if (self.row == i)
        {
            ((MySPCourseTeacherList *)self.teacherList[i]).score = [NSString stringWithFormat:@"%ld",((long)btn.tag + 1) * 10];
        }
    }
    [self.delegate reloadTeacherListData:self.teacherList];
}

- (void)setUpBtns
{
    for (NSInteger i=0; i<5; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(i * 30 + (i * 5), 0, 30, 30);
        
        btn.tag = i;
        
        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.starView addSubview:btn];
    }
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
                    [btn setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateDisabled];
                }
                if (btn.tag == intCount)
                {
                    if (halfCount > 5)
                    {
                        [btn setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateDisabled];
                    }
                    else if(halfCount > 0 && halfCount <=5)
                    {
                        [btn setImage:[UIImage imageNamed:@"bankexing30"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"bankexing30"] forState:UIControlStateDisabled];
                    }
                    else
                    {
                        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateDisabled];
                    }
                }
                if (btn.tag > intCount)
                {
                    [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateDisabled];
                }
            }
        }
    }
}

- (void)setData:(MySPCourseTeacherList *)domain teacherList:(NSMutableArray *)teacherList indexRow:(NSInteger)rowNum
{
    self.teacherList = teacherList;
    
    self.row = rowNum - 1;
    
    self.teacherNameLbl.text = [NSString stringWithFormat:@"%@老师",domain.name];
    
    NSInteger intCount = (NSInteger)([domain.score integerValue] / 10);
    
    NSInteger halfCount = [domain.score integerValue] - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
}

@end
