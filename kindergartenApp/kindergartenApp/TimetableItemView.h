//
//  TimetableItemView.h
//  kindergartenApp
//
//  Created by You on 15/8/10.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimetableDomain.h"
#import "TopicInteractionView.h"

@interface TimetableItemView : UIView <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView    * timetableTableView;
    NSMutableArray * timetableDataSourceMArray;
    TopicInteractionView * topicView;
    UITableViewCell * topicViewCell;
}

@property (strong, nonatomic) NSMutableArray   * tableDataSource; //<TimetableItemVO>
@property (strong, nonatomic) NSString         * queryDate;

//加载课程表数据
- (void)loadTimetableData:(NSMutableArray *)timetableMArray date:(NSString *)queryDate;

@end
