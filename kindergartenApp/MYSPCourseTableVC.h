//
//  MYSPCourseTableVC.h
//  kindergartenApp
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSPCourseTableVC : UITableViewController

@property (assign, nonatomic) NSInteger dataSourceType;

@property (assign, nonatomic) CGRect tableFrame;

@property (strong, nonatomic) NSMutableArray * studyingCourseArr;

@property (strong, nonatomic) NSMutableArray * endingCourseArr;

@end
