//
//  FPHomeSelectView.m
//  kindergartenApp
//
//  Created by Mac on 16/1/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeSelectView.h"


@interface FPHomeSelectView()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation FPHomeSelectView

- (void)awakeFromNib
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds];
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.contentView.layer.shadowOpacity = 0.5f;
    self.contentView.layer.shadowPath = shadowPath.CGPath;
}

- (IBAction)cancelBtn:(id)sender
{
    [self.delegate hidenSelf];
}

- (IBAction)selectImage:(id)sender
{
    [self.delegate pushToImagePickerVC];
}

- (IBAction)createGiftwareShop:(id)sender
{
    [self.delegate pushToCreateGiftwareShopVC];
}
@end
