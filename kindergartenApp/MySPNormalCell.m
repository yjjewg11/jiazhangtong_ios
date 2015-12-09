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

- (void)setSchoolData:(MySPCommentDomain *)domain
{
    NSInteger intCount = (NSInteger)([domain.score integerValue] / 10);
    
    NSInteger halfCount = [domain.score integerValue] - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
}

- (void)initNoCommentData
{
    NSInteger intCount = (NSInteger)([@"50" integerValue] / 10);
    
    NSInteger halfCount = [@"50" integerValue] - intCount * 10;
    
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
- (void)awakeFromNib
{
    self.userscore = @"50";
    
    [self setUpBtns];
    
    [self initNoCommentData];
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
    
    self.userscore = [NSString stringWithFormat:@"%ld",((long)btn.tag + 1) * 10];
    
    [self.delegate saveSchoolScore:self.userscore];
    
}

@end
