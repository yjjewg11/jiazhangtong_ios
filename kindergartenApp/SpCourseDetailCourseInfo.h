//
//  SpCourseDetailCourseInfo.h
//  kindergartenApp
//
//  Created by Mac on 16/1/6.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCourseDetailDomain.h"


@protocol SpCourseDetailCourseInfoDelegate <NSObject>

@required
- (void)pushToMapVC;

@end

@interface SpCourseDetailCourseInfo : UITableViewCell

- (void)setData:(SPCourseDetailDomain *)domain;

@property (weak, nonatomic) id <SpCourseDetailCourseInfoDelegate> delegate;

@end
