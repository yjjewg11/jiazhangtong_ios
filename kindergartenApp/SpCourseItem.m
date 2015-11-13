//
//  SpCourseItem.m
//  kindergartenApp
//
//  Created by Mac on 15/10/22.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseItem.h"

#import "UIButton+WebCache.h"



@interface SpCourseItem()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@end

@implementation SpCourseItem

- (void)setDatas:(SPCourseTypeDomain * )domain
{
    [self.courseBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:domain.img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.nameLbl.text = domain.datavalue;
}

@end
