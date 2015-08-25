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
#import "KGHttpService.h"
#import "Masonry.h"
#import "KGDateUtil.h"

#define TopicInteractionCellIdentifier  @"TopicInteractionCellIdentifier"

@implementation TimetableItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initTableView];
        nowwWeekday = [KGDateUtil weekdayStringFromDate:[KGDateUtil presentTime]];
        if(nowwWeekday==Number_Seven || nowwWeekday==Number_Six) {
            nowwWeekday = Number_One;
        }
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
- (void)loadTimetableData:(NSMutableDictionary *)timetableMDict date:(NSString *)queryDate {
    sourceTimetableMDict = timetableMDict;
    
    [self packageItemViewData];
  
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
    return [_tableDataSource count];
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
    TimetableItemVO   * timetableItemVO = [_tableDataSource objectAtIndex:indexPath.row];
    
    if(timetableItemVO.isDZReply) {
        return [self loadTopicInteractView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    TimetableItemTableViewCell * cell = [TimetableItemTableViewCell cellWithTableView:tableView];
    
    if(_tableDataSource && [_tableDataSource count]>Number_Zero) {
        [cell resetTimetable:[_tableDataSource objectAtIndex:indexPath.row]];
        
        cell.TimetableItemCellBlock = ^(TimetableItemTableViewCell * timetableItemTableViewCell){
            
            NSIndexPath *indexPath = [timetableTableView indexPathForCell:timetableItemTableViewCell];
            [self resetPackageItemViewData:indexPath.row week:timetableItemTableViewCell.selWeekday];
        };
    }
    return cell;
}

//加载点赞回复
- (UITableViewCell *)loadTopicInteractView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopicInteractionCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(_tableDataSource && [_tableDataSource count]>Number_Zero) {
        TimetableItemVO   * timetableItemVO = [_tableDataSource objectAtIndex:indexPath.row];
        [cell addSubview:timetableItemVO.dzReplyView];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimetableItemVO * itemvO = [_tableDataSource objectAtIndex:indexPath.row];
    return itemvO.cellHeight;
}


//数据封装
- (void)packageItemViewData{
    NSArray * users = [KGHttpService sharedService].loginRespDomain.list;
    NSInteger index = Number_Zero;
    for(KGUser * user in users) {
        TimetableItemVO * itemVO = [[TimetableItemVO alloc] init];
        itemVO.cellHeight = 150;
        itemVO.classuuid = user.classuuid;
        itemVO.headUrl   = user.headimg;
        itemVO.weekday = nowwWeekday;
        itemVO.timetableMArray = [sourceTimetableMDict objectForKey:user.classuuid];
        [self.tableDataSource addObject:itemVO];
        index++;
        TimetableDomain * domain = [self getTimetableDomainByWeek:itemVO.timetableMArray week:nowwWeekday];
        UIView * view = [self loadDZReply:domain index:index - Number_One week:nowwWeekday];
        
        TimetableItemVO * itemVO2 = [[TimetableItemVO alloc] init];
        itemVO2.isDZReply = YES;
        itemVO2.cellHeight = CGRectGetMaxY(view.frame);
        itemVO2.dzReplyView = view;
        [self.tableDataSource addObject:itemVO2];
        index++;
    }
}

//重置table数据源指定数据 再刷新table
- (void)resetPackageItemViewData:(NSInteger)cellIndex week:(NSInteger)weekday {
    TimetableItemVO * itemVO = [self.tableDataSource objectAtIndex:cellIndex];
    itemVO.weekday = weekday;
    TimetableDomain * domain = [self getTimetableDomainByWeek:itemVO.timetableMArray week:weekday];
    UIView * view = [self loadDZReply:domain index:cellIndex week:weekday];
    
    TimetableItemVO * itemVO2 = [self.tableDataSource objectAtIndex:cellIndex+Number_One];
    itemVO2.cellHeight  = view.height;
    itemVO2.dzReplyView = view;
    itemVO2.weekday     = weekday; //默认选中这个按钮
    [timetableTableView reloadData];
}


//根据课程表 和选中的 星期几 返回 对应的课程
- (TimetableDomain *)getTimetableDomainByWeek:(NSMutableArray *)timetableMArray week:(NSInteger)week {
    TimetableDomain * domain = nil;
    for(TimetableDomain * tempDomain in timetableMArray) {
        NSInteger weekday = [KGDateUtil weekdayStringFromDate:tempDomain.plandate];
        if(week == weekday) {
            domain = tempDomain;
            break;
        }
    }
    
    return domain;
}


//设置点赞回复View
- (UIView *)loadDZReply:(TimetableDomain *)timetableDomain index:(NSInteger)cellIndex week:(NSInteger)weekday {
    if(timetableDomain) {
        return [self loadDZReplyView:timetableDomain index:cellIndex week:weekday];
    } else {
        return [self loadNoDZReply];
    }
}

//加载点赞回复view
- (UIView *)loadDZReplyView:(TimetableDomain *)timetableDomain index:(NSInteger)cellIndex week:(NSInteger)weekday{
    TopicInteractionDomain * topicInteractionDomain = [TopicInteractionDomain new];
    topicInteractionDomain.dianzan   = timetableDomain.dianzan;
    topicInteractionDomain.replyPage = timetableDomain.replyPage;
    topicInteractionDomain.topicType = Topic_JPKC;
    topicInteractionDomain.topicUUID = timetableDomain.uuid;
    topicInteractionDomain.cellIndex = cellIndex;
    topicInteractionDomain.weekday   = weekday;
    
    TopicInteractionFrame * topicFrame = [TopicInteractionFrame new];
    topicFrame.topicInteractionDomain  = topicInteractionDomain;
    topicFrame.topicInteractHeight += 20;
    CGRect frame = CGRectMake(Number_Zero, Number_Ten, KGSCREEN.size.width, topicFrame.topicInteractHeight);
    TopicInteractionView * topicInteractionView = [[TopicInteractionView alloc] initWithFrame:frame];
    topicInteractionView.topicInteractionFrame = topicFrame;
    return topicInteractionView;
}

//加载无点赞回复view
- (UIView *)loadNoDZReply {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Ten, KGSCREEN.size.width, 45)];
    view.backgroundColor = [UIColor clearColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(Number_Zero, Number_Ten, KGSCREEN.size.width, Number_Fifteen)];
    label.textColor = KGColorFrom16(0x666666);
    label.text = @"暂无课程发布";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:APPUILABELFONTNO15];
    [view addSubview:label];
    return view;
}


//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain topicInteraction:(TopicInteractionDomain *)topicInteractionDomain {
    
    //1.对应课程增加回复
    TimetableItemVO * itemVO = [self.tableDataSource objectAtIndex:topicInteractionDomain.cellIndex];
    ReplyPageDomain * replyPageDomain = nil;
    for(TimetableDomain * timetableDomain in itemVO.timetableMArray) {
        if([timetableDomain.uuid isEqualToString:domain.newsuuid]) {
            replyPageDomain = timetableDomain.replyPage;
            break;
        }
    }
    
    if(!replyPageDomain) {
        replyPageDomain = [[ReplyPageDomain alloc] init];
    }
    [replyPageDomain.data insertObject:domain atIndex:Number_Zero];
    replyPageDomain.totalCount++;
    
    //2.重置对应数据源刷新table
    [self resetPackageItemViewData:topicInteractionDomain.cellIndex week:topicInteractionDomain.weekday];
}

@end
