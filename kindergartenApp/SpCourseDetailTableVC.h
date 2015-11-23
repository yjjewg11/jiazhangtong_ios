//
//  SpCourseDetailTableVC.h
//  kindergartenApp
//
//  Created by Mac on 15/11/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCourseDetailDomain.h"
#import "SPSchoolDomain.h"

@class SpCourseDetailTableVC;
@protocol  SpCourseDetailTableVCDelegate <NSObject>

- (void)pushWebViewModelWindow:(SpCourseDetailTableVC *)tableVC;

@end


@interface SpCourseDetailTableVC : UITableViewController

@property (strong, nonatomic) NSString * uuid;

@property (assign, nonatomic) CGRect tableFrame;

@property (strong, nonatomic) NSMutableArray * presentsComments;

@property (weak, nonatomic) id<SpCourseDetailTableVCDelegate> delegate;

@end
