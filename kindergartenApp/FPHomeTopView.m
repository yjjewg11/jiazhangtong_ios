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
    
}

@end

@implementation FPHomeTopView

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
    if ([titleLbl.text isEqualToString:@""] || titleLbl.text == nil)
    {
        titleLbl.text = @"我的家庭相册";
    }
    else
    {
        titleLbl.text = domain.title;
    }
    
    [placeholderImg sd_setImageWithURL:[NSURL URLWithString:domain.herald]];
    
    if (domain.photo_count == nil || [domain.photo_count isEqualToString:@""])
    {
        totalPhotoNumLbl.text = @"0";
    }
    else
    {
        totalPhotoNumLbl.text = domain.photo_count;
    }
}

@end
