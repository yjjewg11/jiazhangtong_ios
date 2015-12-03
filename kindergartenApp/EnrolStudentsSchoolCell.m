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

@interface EnrolStudentsSchoolCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UIButton *distance;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *summary;

@property (weak, nonatomic) IBOutlet UILabel *studentNum;
@end

@implementation EnrolStudentsSchoolCell

- (void)setData:(EnrolStudentsSchoolDomain *)domain
{
    [self.img sd_setImageWithURL:[NSURL URLWithString:domain.img] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
//    self.img.layer.borderColor = [[UIColor colorWithHexCode:@"#F0F0F0"] CGColor];
//    
//    self.img.layer.borderWidth = 1;
//    
//    self.img.layer.cornerRadius = 5;
    
    self.studentNum.text = [NSString stringWithFormat:@"%ld",(long)domain.ct_study_students];
    
    self.name.text = domain.brand_name;
    
    [self.distance setTitle:domain.distance forState:UIControlStateNormal];
    
    self.address.text = domain.address;
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
    
    NSArray * strArr = [domain.summary componentsSeparatedByString:@","];
    
    NSLog(@"奖杯有: %@",strArr);
    
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
