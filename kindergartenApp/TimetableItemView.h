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
#import "MySPCourseDomain.h"

@protocol TimetableItemViewDelegate <NSObject>

- (void)pushVCWithClassuuid:(MySPCourseDomain *)domain;

@end


@interface TimetableItemView : UIView <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView    * timetableTableView;
    
    //幼儿园课程表数据
    NSMutableDictionary * sourceTimetableMDict;
    NSMutableArray * timetableDataSourceMArray;
    
    //特长班课程表数据
    NSMutableDictionary * spSourceTimetableMDict;
//    NSArray * spTimetableDataSourceMMarray;     //查到对应特长班班级的uuid返回的所有课程表数据
    
    //评论
    TopicInteractionView * topicView;
    UITableViewCell * topicViewCell;
    
    UIScrollView * timetableItemScrollView;
    UIView       * scrollectContentView;
    NSInteger nowwWeekday; //今天是周几  如果是6 7则设置1
}

@property (strong, nonatomic) NSArray * spTimetableDataSourceMMarray;

@property (weak, nonatomic) id<TimetableItemViewDelegate> delegate;

//幼儿园相关
@property (strong, nonatomic) NSMutableArray   * tableDataSource;       //<TimetableItemVO>
@property (strong, nonatomic) NSString         * queryDate;

//特长班相关
@property (strong, nonatomic) NSMutableArray   * spTableDataSource;     //<SPTimetableItemVO>





//加载课程表数据
- (void)loadTimetableData:(NSMutableDictionary *)timetableMDict date:(NSString *)queryDate;

/**
 *  加载特长班课程表的数据
 *
 *  @param timetableMDict 特长班课表字典
 *
 */
- (void)loadSPTimetableData:(NSArray *)spTimetableMDict;

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain topicInteraction:(TopicInteractionDomain *)topicInteractionDomain;

@end
