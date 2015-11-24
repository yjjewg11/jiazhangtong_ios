//
//  SPSchoolDetailTableVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPSchoolDetailTableVC.h"
#import "SpCourseCell.h"
#import "SPTeacherCell.h"
#import "SPCourseDetailVC.h"
#import "KGHttpService.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "KGHUD.h"

@interface SPSchoolDetailTableVC ()

@property (assign, nonatomic) NSInteger pageNo;

@end

@implementation SPSchoolDetailTableVC

- (NSMutableArray *)courseList
{
    if (_courseList == nil)
    {
        _courseList = [NSMutableArray array];
    }
    return _courseList;
}

- (NSMutableArray *)teacherList
{
    if (_teacherList == nil)
    {
        _teacherList = [NSMutableArray array];
    }
    return _teacherList;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRefresh];
    self.pageNo = 2;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = Row_Height;
    self.tableView.frame = self.tableRect;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSourceType == 0)
    {
        return self.courseList.count;
    }
    else if (self.dataSourceType == 1)
    {
        return self.teacherList.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceType == 0)  //课程列表
    {
        SpCourseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"spcourse"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseCell" owner:nil options:nil] firstObject];
        }
        
        [cell setCourseCellData:self.courseList[indexPath.row]];
        
        return cell;
    }
    else if (self.dataSourceType == 1)
    {
        SPTeacherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"teachercell"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SPTeacherCell" owner:nil options:nil] firstObject];
        }
        
        [cell setTeacherCellData:self.teacherList[indexPath.row]];
        
        return cell;
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceType == 0)  //课程列表
    {
        [self.delegate pushToDetailVC:self dataSourceType:0 selIndexPath:indexPath];
    }
    else if (self.dataSourceType == 1) //老师列表
    {
        [self.delegate pushToDetailVC:self dataSourceType:1 selIndexPath:indexPath];
    }
}

#pragma mark - 上拉刷新，下拉加载数据
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableView.footerReleaseToRefreshText = @"松开立即加载";
    self.tableView.footerRefreshingText = @"正在加载中...";
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    if (self.dataSourceType == 0)
    {
        if (self.mappoint == nil)
        {
            self.mappoint = @"";
        }
        
        [[KGHttpService sharedService] getSPCourseList:self.groupuuid map_point:self.mappoint type:@"" sort:@"" teacheruuid:@"" pageNo:[NSString stringWithFormat:@"%ld",(long)self.pageNo] success:^(SPDataListVO *spCourseList)
         {
             NSMutableArray * marr = [NSMutableArray array];
             
             for (NSDictionary *dict in spCourseList.data)
             {
                 SPCourseDomain * domain = [SPCourseDomain objectWithKeyValues:dict];
                 
                 [marr addObject:domain];
             }
             
             if (marr.count != 0)
             {
                 self.pageNo++;
                 
                 for (SPCourseDomain * d in marr)
                 {
                     [self.courseList addObject:d];
                 }
                 
                 [self.tableView footerEndRefreshing];
                 
                 [self.tableView reloadData];
                 
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.courseList.count - 1 inSection:0];
                 
                 [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             }
             else if (marr.count == 0)
             {
                 self.tableView.footerRefreshingText = @"没有更多了.";
                 
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                 {
                     [self.tableView footerEndRefreshing];
                 });
             }
             
             
         }
         faild:^(NSString *errorMsg)
         {
             [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
         }];
    }
    else if (self.dataSourceType == 1)
    {
        [[KGHttpService sharedService] getSPTeacherList:self.groupuuid pageNo:[NSString stringWithFormat:@"%ld",(long)self.pageNo] success:^(SPDataListVO *dataListVo)
         {
             NSMutableArray * marr = [NSMutableArray array];
             
             for (NSDictionary *dict in dataListVo.data)
             {
                 SPTeacherDomain * domain = [SPTeacherDomain objectWithKeyValues:dict];
                 
                 [marr addObject:domain];
             }
             
             if (marr.count != 0)
             {
                 self.pageNo++;
                 
                 for (SPTeacherDomain * d in marr)
                 {
                     [self.teacherList addObject:d];
                 }
                 
                 [self.tableView footerEndRefreshing];
                 
                 [self.tableView reloadData];
                 
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.teacherList.count - 1 inSection:0];
                 
                 [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             }
             else if (marr.count == 0)
             {
                 self.tableView.footerRefreshingText = @"没有更多了.";
                 
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                 {
                    [self.tableView footerEndRefreshing];
                 });
             }
         }
         faild:^(NSString *errorMsg)
         {
             [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
         }];

    }
}

@end
