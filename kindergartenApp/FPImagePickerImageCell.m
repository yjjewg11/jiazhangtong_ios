//
//  FPImagePickerImageCell.m
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPImagePickerImageCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
@interface FPImagePickerImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *mainImg;

@property (weak, nonatomic) IBOutlet UILabel *importedLbl;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIImageView *selImg;

@property (strong, nonatomic) FPImagePickerImageDomain * myDomain;

@end

@implementation FPImagePickerImageCell

- (void)awakeFromNib
{
    //给mainImg 添加长按手势，用于查看大图
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo)];
    [self addGestureRecognizer:longPressGr];
}

- (void)setData:(FPImagePickerImageDomain *)domain
{
    self.myDomain = domain;
    
    if(domain.isOlnyShowImg==YES){
        self.mainImg.image = domain.suoluetu;
        [self.btn setHidden:YES];
        [self.selImg setHidden:YES];
         [self.importedLbl setHidden:YES];
        return;
    }
    
    [self.btn setHidden:NO];
    [self.selImg setHidden:NO];
      [self.importedLbl setHidden:NO];
    
    
    if(domain.suoluetu==nil){
        [ self.mainImg sd_setImageWithURL:domain.localUrl placeholderImage:[UIImage imageNamed:@"waitImageDown"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {}];

    }else{
        self.mainImg.image = domain.suoluetu;

    }
    if (domain.isUpload == YES)
    {
        self.btn.enabled = NO;
        self.importedLbl.hidden = NO;
        self.selImg.hidden = YES;
          }
    else
    {
        self.btn.enabled = YES;
        self.importedLbl.hidden = YES;
      
        self.selImg.hidden = NO;
    }
    
    [self updateSelImgStatus:self.myDomain.isSelect];
    
}

- (void) updateSelImgStatus:(BOOL) checked{
    if (checked == YES)
    {
        self.selImg.image = [UIImage imageNamed:@"icon_image_yes"];
    }
    else
    {
        self.selImg.image = [UIImage imageNamed:@"icon_image_no"];
    }
}

- (IBAction)btnClicked:(id)sender
{
    
    self.myDomain.isSelect=!self.myDomain.isSelect;
       [self updateSelImgStatus:self.myDomain.isSelect];
    
    [self.delegate updateSelectedStatus:self.myDomain];
//    
//    
//    if (self.myDomain.isSelect == NO)
//    {
//        NSNotification * noti = [[NSNotification alloc] initWithName:@"selectphoto" object:@(self.index) userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:noti];
//        
//        self.selImg.image = [UIImage imageNamed:@"icon_image_yes"];
//    }
//    else
//    {
//        NSNotification * noti = [[NSNotification alloc] initWithName:@"deselectphoto" object:@(self.index) userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:noti];
//        
//        self.selImg.image = [UIImage imageNamed:@"icon_image_no"];
//    }
}

- (void)longPressToDo
{
    
    NSString *localUrl = [self.myDomain.localUrl absoluteString];   //url>string

    NSNotification * noti = [[NSNotification alloc] initWithName:@"showbigphoto" object:self userInfo:@{@"localUrl":localUrl}];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

@end
