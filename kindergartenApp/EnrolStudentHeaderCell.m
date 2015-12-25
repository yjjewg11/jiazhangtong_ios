//
//  EnrolStudentHeaderCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/25.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentHeaderCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+flat.h"

@interface EnrolStudentHeaderCell()

@property (weak, nonatomic) IBOutlet UIView *summaryView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *summaryViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *locationLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *studyNum;

@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;

@property (strong, nonatomic) UITextView * summary;

@end

@implementation EnrolStudentHeaderCell

- (void)setData:(EnrolStudentsSchoolDomain *)domain
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:domain.img] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.studyNum.text = [NSString stringWithFormat:@"%ld",(long)domain.ct_study_students];
    
    self.titleLbl.text = domain.brand_name;
    
    self.distanceLbl.text = domain.distance;
    
    self.locationLbl.text = domain.address;
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
    
    if (domain.summary == nil || [domain.summary isEqualToString:@""])
    {
        self.summaryViewHeight.constant = 0;
        
        return;
    }
    else
    {
        self.summary = [[UITextView alloc] init];
        
        CGFloat summaryW = (APPWINDOWWIDTH - 90);
        
        self.summary.text = [self formatSummary:domain.summary];
        
        self.summary.textColor = [UIColor colorWithHexCode:@"#59bb3e"];
        
        self.summary.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        
        self.summary.userInteractionEnabled = NO;
        
        self.summary.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        CGFloat summaryViewHeight = [self heightForString:[self formatSummary:domain.summary] fontSize:14 andWidth:summaryW];
        
        self.summary.frame = CGRectMake(90, 9, summaryW, summaryViewHeight - 20);
        
        self.summaryViewHeight.constant = summaryViewHeight - 20;
        
        [self.summaryView addSubview:self.summary];
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

- (CGFloat) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

- (NSString *)formatSummary:(NSString *)summary
{
    NSArray * arr = [summary componentsSeparatedByString:@","];
    
    NSMutableString * mstr = [NSMutableString string];
    
    for (NSString * str in arr)
    {
        [mstr appendString:[NSString stringWithFormat:@"%@\r\n",str]];
    }
    
    return mstr;
}

@end
