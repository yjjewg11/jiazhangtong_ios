//
//  SPHotCourseVC.h
//  kindergartenApp
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentInfoHeaderView.h"

typedef enum
{
    HotCourseType = 0,
    HotTeacherType = 1
    
}HotDataSourseType;


@class SPHotCourseVC;
@protocol SPHotCourseVCDelegate <NSObject>

- (void)spHotCourseVCSearchAllCourse:(SPHotCourseVC *)hotCourse;
- (void)pushToDetailVC:(SPHotCourseVC *)hotCourseVC dataSourceType:(HotDataSourseType)type selIndexPath:(NSIndexPath *)indexPath;

@end

@interface SPHotCourseVC : UITableViewController

@property (assign, nonatomic) CGRect tableFrame;

@property (strong, nonatomic) NSMutableArray * hotSpCourses;  //热门课程数据

@property (weak, nonatomic) id<SPHotCourseVCDelegate> delegate;

@property (strong, nonatomic) NSString * mappoint;

@end
