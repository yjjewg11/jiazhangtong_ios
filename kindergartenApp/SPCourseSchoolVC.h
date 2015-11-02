//
//  SPCourseSchoolVC.h
//  kindergartenApp
//
//  Created by Mac on 15/10/23.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SPDataListVO.h"

@interface SPCourseSchoolVC : BaseViewController

@property (strong, nonatomic) NSMutableArray * courseNameList;

@property (strong, nonatomic) NSString * firstJoinSelType;

@property (assign, nonatomic) NSInteger firstJoinSelDatakey;

@property (strong, nonatomic) NSMutableArray * courseDatakeys;

@property (strong, nonatomic) SPDataListVO * courseList;

@property (strong, nonatomic) SPDataListVO * schoolList;

@end
