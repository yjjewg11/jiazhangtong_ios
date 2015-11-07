//
//  SPSchoolDetailTableVC.h
//  kindergartenApp
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 funi. All rights reserved.
//

typedef enum
{
    CourseType = 0,
    TeacherType = 1
    
}DataSourseType;

#import <UIKit/UIKit.h>

@class SPSchoolDetailTableVC;
@protocol SPSchoolDetailTableVCDelegate <NSObject>

- (void)pushToDetailVC:(SPSchoolDetailTableVC *)schoolDetailVC dataSourceType:(DataSourseType)type selIndexPath:(NSIndexPath *)indexPath;

@end


@interface SPSchoolDetailTableVC : UITableViewController

@property (assign, nonatomic) CGRect tableRect;

@property (strong, nonatomic) NSMutableArray * courseList;

@property (strong, nonatomic) NSMutableArray * teacherList;

@property (assign, nonatomic) DataSourseType dataSourceType;


@property (weak, nonatomic) id<SPSchoolDetailTableVCDelegate> delegate;

@end
