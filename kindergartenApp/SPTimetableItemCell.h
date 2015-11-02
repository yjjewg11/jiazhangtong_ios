//
//  SPTimetableItemCell.h
//  kindergartenApp
//
//  Created by Mac on 15/10/19.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPTimetableDomain.h"
#import "SPTimetableItemVO.h"

@interface SPTimetableItemCell : UITableViewCell
{
    __weak IBOutlet UIImageView *headIcon;
    __weak IBOutlet UILabel *schoolName;
    __weak IBOutlet UILabel *courseName;
    __weak IBOutlet UILabel *nextCourseDate;
    
    
    __weak IBOutlet UITextField *courseNameText;
    __weak IBOutlet UITextField *courseDateText;
    __weak IBOutlet UITextField *courseLocationText;
    __weak IBOutlet UITextField *preparedItemsText;
    
    __weak IBOutlet UIImageView *todayImage;
    
    __weak IBOutlet UIButton *moreCourseBtn;
    
    SPTimetableItemVO * spTimetableItemVO;
}

@property (strong, nonatomic) SPTimetableDomain * spTimetableDomain;         //培训班课程表数据
@property (nonatomic, copy) void (^SPTimetableItemCellBlock)(SPTimetableItemCell * spTimetableItemTableViewCell);



@property (weak, nonatomic) IBOutlet UIButton *moreCourseBtnClick;

+ (instancetype)spCellWithTableView:(UITableView *)tableView;

@end
