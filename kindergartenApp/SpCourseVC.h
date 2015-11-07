//
//  SpCourseVC.h
//  kindergartenApp
//
//  Created by Mac on 15/10/23.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPDataListVO.h"


typedef enum
{
    CourseType = 0,
    SchoolType = 1
}DataSourseType;

@class SpCourseVC;
@protocol SpCourseVCDelegate <NSObject>

- (void)pushToDetailVC:(SpCourseVC *)spCourseVC dataSourceType:(DataSourseType)type selIndexPath:(NSIndexPath *)indexPath;

@end

@interface SpCourseVC : UITableViewController

@property (assign, nonatomic) CGRect tableFrame;

@property (assign, nonatomic) BOOL showHeaderView;

@property (strong, nonatomic) NSArray * courseListArr;

@property (strong, nonatomic) NSArray * schoolListArr;

@property (assign, nonatomic) DataSourseType dataSourceType;

@property (weak, nonatomic) id<SpCourseVCDelegate> delegate;

- (void)setUpTableViewWithFrame:(CGRect)rect;

@end
