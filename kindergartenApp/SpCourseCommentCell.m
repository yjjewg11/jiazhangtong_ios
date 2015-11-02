//
//  SpCourseCommentCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/1.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseCommentCell.h"

@interface SpCourseCommentCell()

@property (weak, nonatomic) IBOutlet UILabel *create_user;

@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@end

@implementation SpCourseCommentCell

- (void)setDomain:(SPCommentDomain *)domain
{
    _domain = domain;
    
    self.create_user.text = domain.create_user;
    
    self.contentLbl.text = domain.content;
    
    self.dateLbl.text = domain.create_time;
    
    NSInteger intCount = (NSInteger)([domain.score integerValue] * 10 / 10);
    
    NSInteger halfCount = [domain.score integerValue] - intCount;
    
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
