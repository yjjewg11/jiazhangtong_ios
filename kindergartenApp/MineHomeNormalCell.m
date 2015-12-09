//
//  MineHomeNormalCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/9.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MineHomeNormalCell.h"

@interface MineHomeNormalCell()

@property (weak, nonatomic) IBOutlet UILabel *lbl;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation MineHomeNormalCell

- (void)awakeFromNib
{
    
}

- (void)setImageAndTitle:(UIImage *)image title:(NSString *)title
{
    self.lbl.text = title;
    
    self.img.image = image;
}

@end
