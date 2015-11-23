//
//  MySPAllListHeaderView.m
//  kindergartenApp
//
//  Created by Mac on 15/11/18.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPAllListHeaderView.h"

@interface MySPAllListHeaderView()

@property (assign, nonatomic) BOOL isOpen;

@end

@implementation MySPAllListHeaderView

- (void)setData:(MySPAllCouseListDomain *)domain row:(NSInteger)row
{
    self.courseCountLbl.text = [NSString stringWithFormat:@"第 %ld 课",(long)(row + 1)];
    
    self.courseNameLbl.text = domain.name;
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * inputDate = [inputFormatter dateFromString:domain.plandate];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.timeLbl.text = [inputFormatter stringFromDate:inputDate];
}

- (void)jiantouxuanzhuan
{
    
}
- (IBAction)btnClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^
    {
        if (self.isOpen)
        {
            self.youjiantouLbl.transform = CGAffineTransformMakeRotation(0);
            self.isOpen = NO;
        }
        else
        {
            self.youjiantouLbl.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.isOpen = YES;
        }
    }];
    
    [self.delegate viewBtnClick:self];
}

@end
