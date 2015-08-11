//
//  TimetableItemView.h
//  kindergartenApp
//
//  Created by You on 15/8/10.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimetableDomain.h"

@interface TimetableItemView : UIView <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView    * timetableTableView;
    NSMutableArray * timetableDataSourceMArray;
}

@property (strong, nonatomic) NSMutableArray   * tableDataSource;
@property (strong, nonatomic) TimetableDomain  * timetableDomain;

//加载课程表数据
- (void)loadTimetableData:(TimetableDomain *)timetable;

@end
