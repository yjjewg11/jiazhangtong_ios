//
//  MySPTeacherCommentCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/18.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySPCourseTeacherList.h"

@protocol MySPTeacherCommentCellDelegate <NSObject>

- (void)reloadTeacherListData:(NSMutableArray *)teacherListArr;

@end

@interface MySPTeacherCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teacherNameLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (assign, nonatomic) NSInteger row;

@property (strong, nonatomic) NSMutableArray * teacherList;


- (void)setData:(MySPCourseTeacherList *)domain teacherList:(NSMutableArray *)teacherList indexRow:(NSInteger)rowNum;

@property (weak, nonatomic) id<MySPTeacherCommentCellDelegate> delegate;

@end
