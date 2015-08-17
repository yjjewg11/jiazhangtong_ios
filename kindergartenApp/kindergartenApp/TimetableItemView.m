//
//  TimetableItemView.m
//  kindergartenApp
//
//  Created by You on 15/8/10.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TimetableItemView.h"
#import "StudentInfoHeaderView.h"
#import "UIColor+Extension.h"
#import "TimetableItemTableViewCell.h"

#define TopicInteractionCellIdentifier  @"TopicInteractionCellIdentifier"

@implementation TimetableItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initTableView];
    }
    
    return self;
}

- (void)initTableView {
    timetableTableView = [[UITableView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, self.width, self.height)];
    timetableTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    timetableTableView.separatorColor = [UIColor clearColor];
    timetableTableView.delegate   = self;
    timetableTableView.dataSource = self;
    [self addSubview:timetableTableView];
}


- (NSMutableArray *)tableDataSource {
    if(!_tableDataSource) {
        _tableDataSource = [[NSMutableArray alloc] init];
    }
    return _tableDataSource;
}


//加载课程表数据
- (void)loadTimetableData:(NSMutableArray *)timetableMArray date:(NSString *)queryDate {
    _tableDataSource = timetableMArray;
    _queryDate = queryDate;
    
    if(_tableDataSource && [_tableDataSource count]>Number_Zero) {
        [timetableTableView reloadData];
    }
}


#pragma UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return Number_One;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableDataSource count] + Number_One;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Cell_Height2;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
    StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
    view.titleLabel.text = _queryDate;
    view.backgroundColor = KGColorFrom16(0xE7E7EE);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_tableDataSource count]>Number_Zero && indexPath.row == [_tableDataSource count]) {
        return [self loadTopicInteractView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    TimetableItemTableViewCell * cell = [TimetableItemTableViewCell cellWithTableView:tableView];
    
    if(_tableDataSource && [_tableDataSource count]>Number_Zero) {
        [cell resetTimetable:[_tableDataSource objectAtIndex:indexPath.row]];
        cell.TimetableItemCellBlock = ^(TimetableDomain * domain){
            [self loadDZReply:domain];
        };
    }
    return cell;
}

//加载点赞回复
- (UITableViewCell *)loadTopicInteractView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TopicInteractionCellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopicInteractionCellIdentifier];
        cell.selectionStyle = UITableViewRowActionStyleNormal;
    }
    
    if(_tableDataSource && [_tableDataSource count]>Number_Zero) {
        TimetableItemVO   * timetableItemVO = [_tableDataSource objectAtIndex:Number_Zero];
        
        if(timetableItemVO.timetableMArray && [timetableItemVO.timetableMArray count]>Number_Zero) {
            TimetableDomain * domain = [timetableItemVO.timetableMArray objectAtIndex:Number_Zero];
            topicViewCell = cell;
            
            [self loadDZReply:domain];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([_tableDataSource count]>Number_Zero && indexPath.row == [_tableDataSource count]) {
        return 160;
    }
    return 148;
}

//设置点赞回复数据
- (void)loadDZReply:(TimetableDomain *)domain {
    if(topicView) {
        [topicView removeFromSuperview];
    }
    
    if(domain) {
        TopicInteractionDomain * topicInteractionDomain = [TopicInteractionDomain new];
        topicInteractionDomain.dianzan   = domain.dianzan;
        topicInteractionDomain.replyPage = domain.replyPage;
        topicInteractionDomain.topicType = Topic_JPKC;
        topicInteractionDomain.topicUUID = domain.uuid;
        
        TopicInteractionFrame * topicFrame = [TopicInteractionFrame new];
        topicFrame.topicInteractionDomain  = topicInteractionDomain;
        
        CGRect frame = CGRectMake(Number_Zero, Number_Fifteen, KGSCREEN.size.width, topicFrame.topicInteractHeight);
        topicView = [[TopicInteractionView alloc] initWithFrame:frame];
        [topicViewCell addSubview:topicView];
        topicView.topicInteractionFrame = topicFrame;
        
        //续约刷新cell的height
    }
}


@end
