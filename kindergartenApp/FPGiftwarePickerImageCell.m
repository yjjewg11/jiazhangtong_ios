//
//  FPGiftwarePickerImageCell.m
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPGiftwarePickerImageCell.h"

@interface FPGiftwarePickerImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation FPGiftwarePickerImageCell

- (void)setImage:(UIImage *)img
{
    self.img.image = img;
}

- (void)awakeFromNib
{
    
}

- (IBAction)btnClick:(id)sender
{
    [self.delegate getSelImage:self.img.image];
}

@end
