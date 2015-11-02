//
//  FuniBaseView.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/5/30.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseView.h"

@implementation KGBaseView


+ (UIView *)instanceView:(NSString *)className {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    return [nib objectAtIndex:0];
}

@end
