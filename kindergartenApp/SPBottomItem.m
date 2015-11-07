//
//  SPBottomItem.m
//  kindergartenApp
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPBottomItem.h"

@interface SPBottomItem()





@end


@implementation SPBottomItem

- (void)setPic:(NSString *)name Title:(NSString *)title
{
    self.imgView.image = [UIImage imageNamed:name];
    
    self.titleLbl.text = title;
}

@end
