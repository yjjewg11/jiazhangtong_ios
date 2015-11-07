//
//  SPSchoolCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPSchoolCell.h"
#import "UIImageView+WebCache.h"

@interface SPSchoolCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *schoolNameLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *likePersonCount;

@end


@implementation SPSchoolCell

- (void)setData:(SPSchoolDomain *)domain
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:domain.img] placeholderImage:[UIImage imageNamed:@""]];
    
    self.schoolNameLbl.text = domain.brand_name;
    
    self.address.text = domain.address;
    
    self.likePersonCount.text = [NSString stringWithFormat:@"%ld",(long)domain.ct_study_students];
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount;
    
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
