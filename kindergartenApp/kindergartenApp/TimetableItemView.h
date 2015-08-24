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
    NSMutableDictionary * sourceTimetableMDict;
    NSMutableArray * timetableDataSourceMArray;
    TopicInteractionView * topicView;
    UITableViewCell * topicViewCell;
    
    UIScrollView * timetableItemScrollView;
    UIView       * scrollectContentView;
    NSInteger nowwWeekday; //今天是周几  如果是6 7则设置1
}

@property (strong, nonatomic) NSMutableArray   * tableDataSource; //<TimetableItemVO>
@property (strong, nonatomic) NSString         * queryDate;

//加载课程表数据
- (void)loadTimetableData:(NSMutableDictionary *)timetableMDict date:(NSString *)queryDate;

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain topicInteraction:(TopicInteractionDomain *)topicInteractionDomain;

@end
