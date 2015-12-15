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
#import "MLEmojiLabel.h"
#import "SPTimetableItemCell.h"

#define TopicInteractionCellIdentifier  @"TopicInteractionCellIdentifier"
#define TopicInteractionCellIdentifier1  @"TopicInteractionCellIdentifier1"

#define defContentHeight  42

@interface TimetableItemView()<SPTimetableItemCellDelegate>

@property (assign, nonatomic) NSInteger spCourseDataArrCount;

@property (strong, nonatomic) ReplyPageDomain * tempDomain;

@end


@implementation TimetableItemView
- (NSArray *)spTimetableDataSourceMMarray
{
    if (_spTimetableDataSourceMMarray == nil)
    {
        _spTimetableDataSourceMMarray = [NSArray array];
    }
    return _spTimetableDataSourceMMarray;
}

- (ReplyPageDomain *)tempDomain
{
    if (_tempDomain)
    {
        _tempDomain = [[ReplyPageDomain alloc] init];
    }
    return _tempDomain;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.spCourseDataArrCount = 0;
        [self initTableView];
        nowwWeekday = [KGDateUtil weekdayStringFromDate:[KGDateUtil presentTime]];
        if(nowwWeekday==Number_Seven || nowwWeekday==Number_Six || nowwWeekday==Number_Zero) {
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

- (NSMutableArray *)spTableDataSource
{
    if(!_spTableDataSource)
    {
        _spTableDataSource = [[NSMutableArray alloc] init];
    }
    return _spTableDataSource;
}


#pragma mark - 加载特长班课表数据
- (void)loadSPTimetableData:(NSArray *)spTimetableMDict
{
    self.spTimetableDataSourceMMarray = spTimetableMDict;
    
    [self packageSPItemViewData];

    if(_spTableDataSource && [_spTableDataSource count] > Number_Zero)
    {
        [timetableTableView reloadData];
    }
    
}

#pragma mark - 加载课程表数据
- (void)loadTimetableData:(NSMutableDictionary *)timetableMDict date:(NSString *)queryDate
{
    sourceTimetableMDict = timetableMDict;
    
    [self packageItemViewData:nowwWeekday];
    
    _queryDate = queryDate;
    
    if(_tableDataSource && [_tableDataSource count]>Number_Zero)
    {
        [timetableTableView reloadData];
    }
}


#pragma UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //有两组数据，第一组是幼儿园的，第二组是特长班的
    return Number_Two;
}


#pragma mark -  返回的是 幼儿园课程表的数据个数 加上 特长班课程表的数据个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [_tableDataSource count];
    }
    if(section == 1)
    {
        return [_spTableDataSource count];
    }
    return 0;
}


#pragma mark - 返回幼儿园课程表表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return Cell_Height2;
    }
    
    if (section == 1)
    {
        return Cell_Height2;
    }
    
    return 0;
}

#pragma mark - 课程表表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
        StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
        view.titleLabel.text = _queryDate;
        view.backgroundColor = KGColorFrom16(0xE7E7EE);
        return view;
    }
    
    if (section == 1)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
        StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
        view.titleLabel.text = @"特长班课表";
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return nil;
}


#pragma mark - 创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)   //幼儿园单元格
    {
        TimetableItemVO  * timetableItemVO = [_tableDataSource objectAtIndex:indexPath.row];
        
        if(timetableItemVO.isDZReply)
        {
            return [self loadTopicInteractView:tableView cellForRowAtIndexPath:indexPath];
        }
        
        TimetableItemTableViewCell * cell = [TimetableItemTableViewCell cellWithTableView:tableView];
        
        if(_tableDataSource && [_tableDataSource count] > Number_Zero)
        {
            [cell resetTimetable:[_tableDataSource objectAtIndex:indexPath.row]];
            
            cell.TimetableItemCellBlock = ^(TimetableItemTableViewCell * timetableItemTableViewCell)
            {
                NSIndexPath *indexPath = [timetableTableView indexPathForCell:timetableItemTableViewCell];
                [self resetPackageItemViewData:indexPath.row week:timetableItemTableViewCell.selWeekday];
            };
        }
        return cell;
    }
    
    
    if (indexPath.section == 1)  //特长班单元格
    {
        SPTimetableItemVO  * spTimetableItemVO = [_spTableDataSource objectAtIndex:indexPath.row];
        
        if(spTimetableItemVO.isDZReply)
        {
            return [self loadSPTopicInteractView:tableView cellForRowAtIndexPath:indexPath];
        }
        
        SPTimetableItemCell * spCell = [SPTimetableItemCell spCellWithTableView:tableView];
        
        spCell.delegate = self;
        
        if (_spTableDataSource && [_spTableDataSource count] > Number_Zero)
        {
            [spCell setSpTimetableDomain:spTimetableItemVO.spTimetableMArray[indexPath.row / 2]];
            
            spCell.SPTimetableItemCellBlock = ^(SPTimetableItemCell * spcell)
            {
                NSIndexPath *indexPath = [timetableTableView indexPathForCell:spcell];
                [self resetPackageSPItemViewData:indexPath.row];
            };
        }
        return spCell;
    }
    return nil;
}

//加载幼儿园点赞回复
- (UITableViewCell *)loadTopicInteractView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopicInteractionCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(_tableDataSource && [_tableDataSource count]>Number_Zero) {
        TimetableItemVO   * timetableItemVO = [_tableDataSource objectAtIndex:indexPath.row];
        [cell addSubview:timetableItemVO.dzReplyView];
    }
    
    return cell;
}

//加载特长班点赞回复
- (UITableViewCell *)loadSPTopicInteractView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopicInteractionCellIdentifier1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(_spTableDataSource && [_spTableDataSource count] > Number_Zero)
    {
        SPTimetableItemVO * spVO = [_spTableDataSource objectAtIndex:indexPath.row];
        [cell addSubview:spVO.dzReplyView];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        TimetableItemVO * itemvO = [_tableDataSource objectAtIndex:indexPath.row];
        return itemvO.cellHeight;
    }
    
    if(indexPath.section == 1)
    {
        //这里根据模型里面取出行高
        SPTimetableItemVO * itemVO = [_spTableDataSource objectAtIndex:indexPath.row];
        return itemVO.cellHeight;
    }
    return 0;
}


#pragma mark - 数据封装 - 幼儿园课程表
- (void)packageItemViewData:(NSInteger)week
{
    NSArray * users = [KGHttpService sharedService].loginRespDomain.list;  //获取孩子列表
    NSInteger index = Number_Zero;
    for(KGUser * user in users){
        //遍历用户信息
        TimetableItemVO * itemVO = [[TimetableItemVO alloc] init];
        itemVO.cellHeight = 330;
        itemVO.classuuid = user.classuuid;
        itemVO.headUrl   = user.headimg;
        itemVO.weekday = week;
        itemVO.timetableMArray = [sourceTimetableMDict objectForKey:user.classuuid];                    //根据幼儿园班级uuid取出该班所有课程表
        [self.tableDataSource addObject:itemVO];
        
        index++;
        TimetableDomain * domain = [self getTimetableDomainByWeek:itemVO.timetableMArray week:week];
//        itemVO.cellHeight = [self calculateTimetableHeight:domain];
        
        UIView * view = [self loadDZReply:domain index:index - Number_One week:week];                   //取点赞数据
        
        TimetableItemVO * itemVO2 = [[TimetableItemVO alloc] init];
        itemVO2.isDZReply = YES;
        itemVO2.cellHeight = CGRectGetMaxY(view.frame);
        itemVO2.dzReplyView = view;
        [self.tableDataSource addObject:itemVO2];
        index++;
    }
}

#pragma mark - 数据封装 - 特长班课程表
- (void)packageSPItemViewData
{
    NSInteger index = Number_Zero;
    NSInteger cellIndex = Number_Zero;
    for(SPTimetableDomain * spTimetable in self.spTimetableDataSourceMMarray)
    {
        SPTimetableItemVO * itemVO = [[SPTimetableItemVO alloc] init];
        itemVO.cellHeight = 245;
        itemVO.headUrl   = spTimetable.student_headimg;
        itemVO.spTimetableMArray = (NSMutableArray *)self.spTimetableDataSourceMMarray;
        [self.spTableDataSource addObject:itemVO];
        
        index++;
        SPTimetableDomain * domain = self.spTimetableDataSourceMMarray[cellIndex];
        //itemVO.cellHeight = [self calculateTimetableHeight:domain];
        
        UIView * view = [self loadDZReply:domain index:index - Number_One];
        
        SPTimetableItemVO * itemVO2 = [[SPTimetableItemVO alloc] init];
        itemVO2.isDZReply = YES;
        itemVO2.cellHeight = CGRectGetMaxY(view.frame);
        itemVO2.dzReplyView = view;
        [self.spTableDataSource addObject:itemVO2];
        index++;
        cellIndex++;
        
    }
}

#pragma mark - 重置特长班课程班table数据源指定数据 再刷新table
- (void)resetPackageSPItemViewData:(NSInteger)cellIndex
{
    SPTimetableDomain * spDomain = [self.spTimetableDataSourceMMarray objectAtIndex:cellIndex / Number_Two];    //这里是从存放domain的数组里面取出来，对应要/2
    
    UIView * view = [self loadDZReply:spDomain index:cellIndex];
    SPTimetableItemVO * itemVO2 = [self.spTableDataSource objectAtIndex:cellIndex + Number_One];

    itemVO2.cellHeight  = view.height;
    itemVO2.dzReplyView = view;
    
    [timetableTableView reloadData];
}

#pragma mark - 重置幼儿园课程表table数据源指定数据 再刷新table
- (void)resetPackageItemViewData:(NSInteger)cellIndex week:(NSInteger)weekday {
    
    TimetableItemVO * itemVO = [self.tableDataSource objectAtIndex:cellIndex];
    
    itemVO.weekday = weekday;
    
    TimetableDomain * domain = [self getTimetableDomainByWeek:itemVO.timetableMArray week:weekday];

    UIView * view = [self loadDZReply:domain index:cellIndex week:weekday];
    TimetableItemVO * itemVO2 = [self.tableDataSource objectAtIndex:cellIndex + Number_One];
    
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



//设置幼儿园点赞回复View
- (UIView *)loadDZReply:(TimetableDomain *)timetableDomain index:(NSInteger)cellIndex week:(NSInteger)weekday {
    
    if(timetableDomain) {
        return [self loadDZReplyView:timetableDomain index:cellIndex week:weekday];
    } else {
        return [self loadNoDZReply];
    }
    
}

//设置特长班点赞回复view
- (UIView *)loadDZReply:(SPTimetableDomain *)spTimetableDomain index:(NSInteger)cellIndex
{
    if(spTimetableDomain) {
        return [self loadDZReplyView:spTimetableDomain index:cellIndex];
    } else {
//        return [self loadNoDZReply];
        return nil;
    }
}

//加载幼儿园点赞回复view
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

#pragma mark - 加载特长班点赞回复view
- (UIView *)loadDZReplyView:(SPTimetableDomain *)spTimetableDomain index:(NSInteger)cellIndex
{
    TopicInteractionDomain * topicInteractionDomain = [TopicInteractionDomain new];
    topicInteractionDomain.dianzan   = spTimetableDomain.dianzan;

    topicInteractionDomain.replyPage = spTimetableDomain.replyPage;
    
    topicInteractionDomain.topicType = Topic_PXJXJH;
    topicInteractionDomain.topicUUID = spTimetableDomain.uuid;
    topicInteractionDomain.cellIndex = cellIndex;
    
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

//计算课程cell高度
- (CGFloat)calculateTimetableHeight:(TimetableDomain *)domain {
    CGFloat width = KGSCREEN.size.width - 93 - 16;
    CGFloat height = 150;
    CGSize size = [MLEmojiLabel boundingRectWithSize:domain.morning w:width font:APPUILABELFONTNO12];
    
    if(size.height > defContentHeight) {
        height += size.height - defContentHeight;
    }
    
    CGSize size2 = [MLEmojiLabel boundingRectWithSize:domain.afternoon w:width font:APPUILABELFONTNO12];
    
    if(size2.height > defContentHeight) {
        height += size2.height - defContentHeight;
    }
    return height;
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
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    SPTimetableItemVO * spVO = [self.spTableDataSource objectAtIndex:topicInteractionDomain.cellIndex];
    ReplyPageDomain * spPageDomain = nil;
    for (SPTimetableDomain * spDomain in spVO.spTimetableMArray) {
        if([spDomain.uuid isEqualToString:domain.newsuuid]){
            spPageDomain = spDomain.replyPage;
            break;
        }
    }
    
    if (!spPageDomain) {
        spPageDomain = [[ReplyPageDomain alloc] init];
    }
    [spPageDomain.data insertObject:domain atIndex:Number_Zero];
    spPageDomain.totalCount++;
    [self resetPackageSPItemViewData:topicInteractionDomain.cellIndex];
}

- (void)pushVCWithClassuuid:(MySPCourseDomain *)domain
{
    [self.delegate pushVCWithClassuuid:domain];
}

@end
