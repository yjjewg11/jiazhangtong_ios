//
//  SPCouseInfoCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCourseDetailDomain.h"

@interface SPCouseInfoCell : UITableViewCell

@property (strong, nonatomic) SPCourseDetailDomain * domain;
@property (assign, nonatomic) CGFloat rowHeight;

@end
