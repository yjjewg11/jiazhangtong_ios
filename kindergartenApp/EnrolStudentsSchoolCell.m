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

@interface EnrolStudentsSchoolCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *summary;

@property (weak, nonatomic) IBOutlet UILabel *studentNum;

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

    self.summary.text = [self formatSummary:domain.summary];
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
