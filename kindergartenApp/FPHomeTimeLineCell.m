//
//  FPHomeTimeLineCell.m
//  kindergartenApp
//
//  Created by Mac on 16/1/27.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeTimeLineCell.h"
#import "UIImageView+WebCache.h"

@interface FPHomeTimeLineCell()

@property (weak, nonatomic) IBOutlet UIImageView *img1;

@property (weak, nonatomic) IBOutlet UIImageView *img2;

@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property (weak, nonatomic) IBOutlet UIImageView *img4;

@property (weak, nonatomic) IBOutlet UIImageView *img5;

@property (weak, nonatomic) IBOutlet UIImageView *img6;

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@property (weak, nonatomic) IBOutlet UILabel *total;

@end

@implementation FPHomeTimeLineCell

- (void)setImgs:(NSArray *)imgArr
{
    for (NSInteger i=0; i<imgArr.count; i++)
    {
        if (i==0)
        {
            [self setBorder:self.img1];
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
        }
        else if (i==1)
        {
            [self setBorder:self.img2];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
        }
        else if (i==2)
        {
            [self setBorder:self.img3];
            [self.img3 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
        }
        else if (i==3)
        {
            [self setBorder:self.img4];
            [self.img4 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
        }
        else if (i==4)
        {
            [self setBorder:self.img5];
            [self.img5 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
        }
        else if (i==5)
        {
            [self setBorder:self.img6];
            [self.img6 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
        }
        else
        {
            
        }
    }
}

- (void)setBorder:(UIImageView *)imgview
{
    [imgview.layer setShouldRasterize:NO];
    // 设置边框颜色
    [imgview.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    // 设置边框宽度
    [imgview.layer setBorderWidth:2.0];
}

- (void)setDateAndCount:(NSString *)dateAndCount
{
    NSArray * strArr = [dateAndCount componentsSeparatedByString:@","];
    self.dateLbl.text = strArr[0];
    self.total.text = [NSString stringWithFormat:@"共%@张",strArr[1]];
}

- (void)awakeFromNib
{
    self.height = (APPWINDOWWIDTH - 20) + 30 + 10 + 10;
}

@end
