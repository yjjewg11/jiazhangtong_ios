//
//  FPImagePickerImageCell.m
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPImagePickerImageCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

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
    
    if (domain.isUpload == YES)
    {
        self.btn.enabled = NO;
        self.importedLbl.hidden = NO;
        self.selImg.hidden = YES;
        self.mainImg.image = domain.suoluetu;
    }
    else
    {
        self.btn.enabled = YES;
        self.importedLbl.hidden = YES;
        self.mainImg.image = domain.suoluetu;
        self.selImg.hidden = NO;
    }
    
    if (domain.isSelect == YES)
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
    if (self.myDomain.isSelect == NO)
    {
        NSNotification * noti = [[NSNotification alloc] initWithName:@"selectphoto" object:@(self.index) userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
        self.selImg.image = [UIImage imageNamed:@"icon_image_yes"];
    }
    else
    {
        NSNotification * noti = [[NSNotification alloc] initWithName:@"deselectphoto" object:@(self.index) userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
        self.selImg.image = [UIImage imageNamed:@"icon_image_no"];
    }
}

- (void)longPressToDo
{
    NSNotification * noti = [[NSNotification alloc] initWithName:@"showbigphoto" object:@(self.index) userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

@end
