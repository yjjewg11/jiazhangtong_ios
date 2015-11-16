//
//  MySPCourseCommentCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/16.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseCommentCell.h"

@interface MySPCourseCommentCell() <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *starView;



@end


@implementation MySPCourseCommentCell

- (void)setData:(MySPCommentDomain *)commentDomain
{
    self.textView.text = commentDomain.content;
    
    NSInteger intCount = (NSInteger)([commentDomain.score integerValue] / 10);
    
    NSInteger halfCount = [commentDomain.score integerValue] - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
}

- (void)awakeFromNib
{
    self.textView.delegate = self;
}

#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
            }
        }
    }
}

@end
