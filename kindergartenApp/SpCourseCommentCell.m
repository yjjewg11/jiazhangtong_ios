//
//  SpCourseCommentCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/1.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseCommentCell.h"
#import "KGNSStringUtil.h"
#import "NSDate+Utils.h"

@interface SpCourseCommentCell()

@property (weak, nonatomic) IBOutlet UILabel *create_user;

@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHeight;

@end

@implementation SpCourseCommentCell

- (void)setDomain:(SPCommentDomain *)domain
{
    _domain = domain;
    
    self.create_user.text = domain.create_user;
    
    self.contentLbl.text = domain.content;
    
    self.dateLbl.text =  domain.create_time;
    
    NSInteger intCount = (NSInteger)([domain.score integerValue] * 10 / 10);
    
    NSInteger halfCount = [domain.score integerValue] - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
    
    [self calCellHeight];
    
}

- (void)calCellHeight
{
    NSString * text = self.contentLbl.text;
    
    CGFloat textHeight = [KGNSStringUtil heightForString:text andWidth:self.contentLbl.frame.size.width];
    
    self.rowHeight = 139 + ABS(self.textHeight.constant - textHeight);
    
    self.textHeight.constant = textHeight;
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
