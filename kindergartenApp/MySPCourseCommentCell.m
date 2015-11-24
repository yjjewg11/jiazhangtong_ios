//
//  MySPCourseCommentCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/16.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseCommentCell.h"

@interface MySPCourseCommentCell() <UITextViewDelegate>

@end


@implementation MySPCourseCommentCell

- (void)setData:(MySPCommentDomain *)commentDomain
{
    if (commentDomain.content == nil || [commentDomain.content isEqualToString:@""])
    {
        self.textView.text = @"您没有填写评价哦";
    }
    else
    {
        self.textView.text = commentDomain.content;
    }
    
    self.extuuid = commentDomain.ext_uuid;
    
    NSInteger intCount = (NSInteger)([commentDomain.score integerValue] / 10);
    
    NSInteger halfCount = [commentDomain.score integerValue] - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
}

- (void)awakeFromNib
{
    self.textView.delegate = self;
    
    self.userscore = @"50";
    
    [self setUpBtns];
}

- (void)initNoCommentData
{
    NSInteger intCount = (NSInteger)([@"50" integerValue] / 10);
    
    NSInteger halfCount = [@"50" integerValue] - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
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

#pragma mark - UITextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.content = self.textView.text;
    
    if (self.content != nil || ![self.content isEqualToString:@""])
    {
        NSLog(@"课程评价是:%@",self.content);
        [self.delegate saveCommentText:self.content];
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
    
    [self.delegate saveCourseScore:self.userscore];
}

@end
