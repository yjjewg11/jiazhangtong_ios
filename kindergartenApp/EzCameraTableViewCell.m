//
//  EzCameraTableViewCell.m
//  kindergartenApp
//
//  Created by liumingquan on 16/6/1.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "EzCameraTableViewCell.h"

@implementation EzCameraTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDomainToView:(EZCamrea * )domain{
    if(domain.picUrl){
        self.domain=domain;
        NSURL *imageUrl = [NSURL URLWithString:domain.picUrl];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        
        self.imageView.clipsToBounds = YES;
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.image = image;
    }
    self.titleLabel.text=domain.cameraName;

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
