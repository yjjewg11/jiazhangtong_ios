//
//  SpCourseDetailCommentVC.h
//  kindergartenApp
//
//  Created by Mac on 16/1/7.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpCourseDetailCommentVC : UITableViewController

@property (strong, nonatomic) NSString * uuid;

@property (strong, nonatomic) NSMutableArray * dataSource;

@property (assign, nonatomic) CGRect tableFrame;

- (void)calCommentCellHeight;

@end
