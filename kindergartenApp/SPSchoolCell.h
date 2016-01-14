//
//  SPSchoolCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPSchoolDomain.h"

@class SPSchoolDomain;
@protocol SPSchoolCellDelegate <NSObject>

- (void)pushToMapVC:(SPSchoolDomain *)domain;

@end

@interface SPSchoolCell : UIView

- (void)setData:(SPSchoolDomain *)domain;

@property (assign, nonatomic) id<SPSchoolCellDelegate> delegate;

@end
