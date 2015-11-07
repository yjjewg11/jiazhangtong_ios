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

@interface SpCourseDetailTableVC : UITableViewController

@property (strong, nonatomic) NSString * uuid;

@property (strong, nonatomic) SPCourseDetailDomain * courseDetailDomain;

@property (strong, nonatomic) SPSchoolDomain * schoolDomain;

@property (assign, nonatomic) CGRect tableFrame;

@property (strong, nonatomic) NSArray * presentsComments;

@property (assign, nonatomic) CGFloat courseRowHeight;

@property (assign, nonatomic) CGFloat schollRowHeight;

@end
