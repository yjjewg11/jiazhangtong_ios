//
//  SpCourseHomeAdCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/25.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseHomeAdCell.h"
#import "FeHourGlass.h"

@interface SpCourseHomeAdCell()
{
    FeHourGlass * _hourGlass;
}



@end

@implementation SpCourseHomeAdCell

- (void)awakeFromNib
{
    _hourGlass = [[FeHourGlass alloc] initWithView:self];
    
    [self.adView addSubview:_hourGlass];
    
    [_hourGlass showWhileExecutingBlock:^
    {
        [self myTask];
    }
    completion:^
    {
        
    }];
}

- (void)myTask
{
    
}

@end
