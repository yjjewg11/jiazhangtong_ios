//
//  KGHomeItemButton.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/21.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGHomeItemButton.h"
#import "UIView+Extension.h"

@implementation KGHomeItemButton


-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor redColor];
//        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    frame.size.width += HWMargin;
    CGPoint center = self.imageView.center;
    center.x = self.width/2;
    center.y = self.imageView.height/2;
    self.imageView.center = center;
    
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x =0;
    newFrame.origin.y = self.imageView.height + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
}


-(void)setHighlighted:(BOOL)highlighted{}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    CGPoint center = self.imageView.center;
//    center.x = self.width/2;
//    center.y = self.imageView.height/2;
//    self.imageView.center = center;
//    
//    CGRect newFrame = [self titleLabel].frame;
//    newFrame.origin.x =0;
//    newFrame.origin.y = self.imageView.height + 5;
//    newFrame.size.width = self.frame.size.width;
//    
//    self.titleLabel.x = newFrame.origin.x;
//    self.titleLabel.y = newFrame.origin.y;
//    self.titleLabel.width = newFrame.size.width;
//    self.titleLabel.height = newFrame.size.height;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGPoint center = self.imageView.center;
        center.x = self.width/2;
        center.y = self.imageView.height/2;
        self.imageView.center = center;
        
        CGRect newFrame = [self titleLabel].frame;
        newFrame.origin.x =0;
        newFrame.origin.y = self.imageView.height + 5;
        newFrame.size.width = self.frame.size.width;
        
        self.titleLabel.frame = newFrame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    });
    
}

@end
