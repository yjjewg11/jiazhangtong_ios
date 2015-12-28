//
//  EnrolStudentsSchoolCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentsSchoolCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+flat.h"
#import "MyUILabel.h"
#import "KGNSStringUtil.h"

@interface EnrolStudentsSchoolCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView * starView;

@property (weak, nonatomic) IBOutlet UILabel * distance;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *studentNum;

@property (strong, nonatomic) UITextView *summary;

@property (strong, nonatomic) UIImageView *cupImgView;

@property (weak, nonatomic) IBOutlet UIView *sepView;

@end

@implementation EnrolStudentsSchoolCell

- (void)setData:(EnrolStudentsSchoolDomain *)domain
{
    [self.img sd_setImageWithURL:[NSURL URLWithString:domain.img] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.studentNum.text = [NSString stringWithFormat:@"%ld",(long)domain.ct_study_students];
    
    self.name.text = domain.brand_name;
    
    self.distance.text = domain.distance;
    
    self.address.text = domain.address;
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
    
    if (domain.summary == nil || [domain.summary isEqualToString:@""])
    {
        self.sepView.hidden = YES;
        
        self.height = 85;
        
        return;
    }
    else
    {
        self.sepView.hidden = NO;
        
        CGFloat padding = 10;
        
        self.cupImgView = [[UIImageView alloc] init];
        self.cupImgView.frame = CGRectMake(padding + (self.img.width - 25), 90, 25, 25);
        self.cupImgView.image = [UIImage imageNamed:@"newjiangbei"];
        [self addSubview:self.cupImgView];
        
        self.summary = [[UITextView alloc] init];
        
        CGFloat summaryX = CGRectGetMaxX(self.cupImgView.frame) + 10;
        CGFloat summaryW = (APPWINDOWWIDTH - CGRectGetMaxX(self.cupImgView.frame));
        
        self.summary.text = [self formatSummary:domain.summary];
        
        self.summary.textColor = [UIColor colorWithHexCode:@"#59bb3e"];
        
        self.summary.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        
        self.summary.userInteractionEnabled = NO;
        
        self.summary.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);

        CGFloat summaryViewHeight = [self heightForString:[self formatSummary:domain.summary] fontSize:14 andWidth:summaryW];
        
        self.summary.frame = CGRectMake(summaryX, 90, summaryW, summaryViewHeight - 20);
        
        self.height = 85 + summaryViewHeight - 10;
        
        [self addSubview:self.summary];
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
    
    if (self.summaryCount == 3)
    {
        for (NSInteger i=0; i<3; i++)
        {
            [mstr appendString:[NSString stringWithFormat:@"%@\r\n",arr[i]]];
        }
    }
    else
    {
        for (NSString * str in arr)
        {
            [mstr appendString:[NSString stringWithFormat:@"%@\r\n",str]];
        }
    }
    
    return mstr;
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


- (void)awakeFromNib
{
    self.layer.borderColor = [[UIColor colorWithHexCode:@"#e5e5e5"] CGColor];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
}

@end
