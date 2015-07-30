//
//  ImageCollectionViewCell.m
//  funiiPhoneApp
//
//  Created by ios2 on 14-9-28.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imgView = [[UIImageView alloc]init];
        self.imgView = imgView;
        [self.contentView addSubview:self.imgView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end
