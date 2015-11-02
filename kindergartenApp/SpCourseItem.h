//
//  SpCourseItem.h
//  kindergartenApp
//
//  Created by Mac on 15/10/22.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCourseTypeDomain.h"

@interface SpCourseItem : UIView

@property (weak, nonatomic) IBOutlet UIButton *courseBtn;

- (void)setDatas:(SPCourseTypeDomain * )domain;

@end
