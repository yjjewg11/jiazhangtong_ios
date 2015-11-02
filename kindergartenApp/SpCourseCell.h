//
//  SpCourseCell.h
//  kindergartenApp
//
//  Created by Mac on 15/10/23.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCourseDomain.h"
#import "SPSchoolDomain.h"

@interface SpCourseCell : UITableViewCell

- (void)setCourseCellData:(SPCourseDomain *)domain;

- (void)setSchoolCellData:(SPSchoolDomain *)domain;

@end
