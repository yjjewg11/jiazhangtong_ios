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

@property (weak, nonatomic) IBOutlet UIView *imageBox;

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@property (weak, nonatomic) IBOutlet UILabel *total;

@end

@implementation FPHomeTimeLineCell

- (void)setImgs:(NSArray *)imgArr
{
    CGFloat two = self.imageBox.height   / 2;
    CGFloat three = self.imageBox.height / 3;
    CGFloat four = self.imageBox.height  / 4;
    //创建imageview
    switch (imgArr.count)
    {
        case 0:
        case 1:
        {
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageBox.height, self.imageBox.height)];
            [self setBorder:imgView];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            [self.imageBox addSubview:imgView];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
        }
            break;
            
        case 2:
        {
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, four, two, two)];
            [self setBorder:imgView];
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(two, four, two, two)];
            [self setBorder:imgView1];
            imgView1.clipsToBounds = YES;
            imgView1.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView1];
            [imgView1 sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
        }
            break;
            
        case 3:
        {
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageBox.width, two)];
            [self setBorder:imgView];
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, two,two,two)];
            [self setBorder:imgView1];
            imgView1.clipsToBounds = YES;
            imgView1.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView1];
            [imgView1 sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(two,two,two,two)];
            [self setBorder:imgView2];
            imgView2.clipsToBounds = YES;
            imgView2.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView2];
            [imgView2 sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
        }
            break;
            
        case 4:
        {
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, two,two)];
            [self setBorder:imgView];
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(two,0,two,two)];
            [self setBorder:imgView1];
            imgView1.clipsToBounds = YES;
            imgView1.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView1];
            [imgView1 sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,two,two,two)];
            [self setBorder:imgView2];
            imgView2.clipsToBounds = YES;
            imgView2.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView2];
            [imgView2 sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(two,two,two,two)];
            [self setBorder:imgView3];
            imgView3.clipsToBounds = YES;
            imgView3.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView3];
            [imgView3 sd_setImageWithURL:[NSURL URLWithString:imgArr[3]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            
        }
            break;
        case 5:
        {
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, two,two)];
            [self setBorder:imgView];
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(two,0,two,two)];
            [self setBorder:imgView1];
            imgView1.clipsToBounds = YES;
            imgView1.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView1];
            [imgView1 sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,two,three,three)];
            [self setBorder:imgView2];
            imgView2.clipsToBounds = YES;
            imgView2.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView2];
            [imgView2 sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(three,two,three,three)];
            [self setBorder:imgView3];
            imgView3.clipsToBounds = YES;
            imgView3.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView3];
            [imgView3 sd_setImageWithURL:[NSURL URLWithString:imgArr[3]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView4 = [[UIImageView alloc] initWithFrame:CGRectMake(three*2,two,three,three)];
            [self setBorder:imgView4];
            imgView4.clipsToBounds = YES;
            imgView4.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView4];
            [imgView4 sd_setImageWithURL:[NSURL URLWithString:imgArr[4]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
        }
            break;
            
        case 6:
        {
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, three*2,three*2)];
            [self setBorder:imgView];
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(three*2,0,three,three)];
            [self setBorder:imgView1];
            imgView1.clipsToBounds = YES;
            imgView1.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView1];
            [imgView1 sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(three*2,three,three,three)];
            [self setBorder:imgView2];
            imgView2.clipsToBounds = YES;
            imgView2.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView2];
            [imgView2 sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0,three*2,three,three)];
            [self setBorder:imgView3];
            imgView3.clipsToBounds = YES;
            imgView3.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView3];
            [imgView3 sd_setImageWithURL:[NSURL URLWithString:imgArr[3]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView4 = [[UIImageView alloc] initWithFrame:CGRectMake(three,three*2,three,three)];
            [self setBorder:imgView4];
            imgView4.clipsToBounds = YES;
            imgView4.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView4];
            [imgView4 sd_setImageWithURL:[NSURL URLWithString:imgArr[4]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
            
            UIImageView * imgView5 = [[UIImageView alloc] initWithFrame:CGRectMake(three*2,three*2,three,three)];
            [self setBorder:imgView5];
            imgView5.clipsToBounds = YES;
            imgView5.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageBox addSubview:imgView5];
            [imgView5 sd_setImageWithURL:[NSURL URLWithString:imgArr[5]] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
        }
            break;
            
            
        default:
            break;
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
//    self.height = (APPWINDOWWIDTH - 20) + 30 + 10 + 10 + 10 + 50;
}


@end
