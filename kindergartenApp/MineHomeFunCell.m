//
//  MineHomeFunCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/14.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MineHomeFunCell.h"

@interface MineHomeFunCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *funName;

@end

@implementation MineHomeFunCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setImageAndTitle:(UIImage *)image title:(NSString *)title
{
    self.funName.text = title;
    
    self.imgView.image = image;
}


@end
