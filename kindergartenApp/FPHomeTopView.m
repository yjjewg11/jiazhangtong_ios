//
//  FPHomeTopView.m
//  kindergartenApp
//
//  Created by Mac on 16/1/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeTopView.h"
#import "UIImageView+WebCache.h"

@interface FPHomeTopView()
{
    __weak IBOutlet UIImageView *placeholderImg;
    __weak IBOutlet UILabel *titleLbl;
    __weak IBOutlet UILabel *woguanzhuNum;
    __weak IBOutlet UILabel *guanzhuwoNum;
    
    __weak IBOutlet UILabel *totalPhotoNumLbl;
    
    __weak IBOutlet UIImageView *topBackImage;
    
    
    
    __weak IBOutlet UILabel *timeLineLbl;
    __weak IBOutlet UIView *timeLineRedLine;
    
    __weak IBOutlet UILabel *giftwareLbl;
    __weak IBOutlet UIView *giftwareRedLine;
    
}

@end

@implementation FPHomeTopView
- (IBAction)timeLineBtn:(id)sender
{
    
    //时光轴。下划线
    giftwareRedLine.backgroundColor = [UIColor whiteColor];
    
    timeLineRedLine.backgroundColor = [UIColor redColor];
    
    timeLineLbl.textColor = [UIColor redColor];
    giftwareLbl.textColor = [UIColor blackColor];
}

- (IBAction)giftwarePhotos:(id)sender
{
    giftwareRedLine.backgroundColor = [UIColor redColor];
    timeLineRedLine.backgroundColor = [UIColor whiteColor];
    timeLineLbl.textColor = [UIColor blackColor];
    giftwareLbl.textColor = [UIColor redColor];
    
    [self.delegate clickGiftwareBtn];
    
 
    
}

- (void)awakeFromNib
{
    UIBezierPath * shadowPath = [UIBezierPath bezierPathWithRect:totalPhotoNumLbl.bounds];
    totalPhotoNumLbl.layer.masksToBounds = YES;
    totalPhotoNumLbl.layer.shadowColor = [UIColor blackColor].CGColor;
    totalPhotoNumLbl.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    totalPhotoNumLbl.layer.shadowOpacity = 0.5f;
    totalPhotoNumLbl.layer.shadowPath = shadowPath.CGPath;
    totalPhotoNumLbl.layer.cornerRadius = 5;
//    [self addTopBackImageBlurred];
}
//设置背景图片的高斯模糊
//-(void)addTopBackImageBlurred{
//
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"fpshouye"]];
//    // create gaussian blur filter
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:inputImage forKey:kCIInputImageKey];
//    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
//    // blur image
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    CGImageRelease(cgImage);
//    topBackImage.image = image;
//}
- (void)setData:(FPMyFamilyPhotoCollectionDomain *)domain
{
    if ([domain.title isEqualToString:@""] || domain.title == nil)
    {
        titleLbl.text = @"我的家庭相册";
    }
    else
    {
        titleLbl.text = domain.title;
    }
    
    [placeholderImg sd_setImageWithURL:[NSURL URLWithString:domain.herald]];
//    //给placeimg添加点击手势
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
//    
//    [placeholderImg addGestureRecognizer:tap];
//    
    
    if (domain.photo_count == nil || [domain.photo_count isEqualToString:@""])
    {
        totalPhotoNumLbl.text = @"0";
    }
    else
    {
        totalPhotoNumLbl.text = domain.photo_count;
    }
}
//手势的响应
-(void)onTap:(UIGestureRecognizer *)sender{
    
    
    self.pushToMyAlbum();
}
- (IBAction)onClick_myFamily:(id)sender {
     self.pushToMyAlbum();
}

@end


