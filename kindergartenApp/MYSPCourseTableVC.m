//
//  MYSPCourseTableVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MYSPCourseTableVC.h"
#import "MYSPCourseTableViewCell.h"
#import "MySPEndCourseView.h"
#import "MJRefresh.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "MJExtension.h"

@interface MYSPCourseTableVC () <UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) NSInteger pageNo;

@end

@implementation MYSPCourseTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRefresh];
    
    self.pageNo = 2;
    
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.frame = self.tableFrame;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSourceType == 0)
    {
        return self.studyingCourseArr.count;
    }
    else if(self.dataSourceType == 1)
    {
        return self.endingCourseArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceType == 0)
    {
        MYSPCourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mysp"];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MYSPCourseTableViewCell" owner:nil options:nil] firstObject];;
        }
        
        [cell setData:self.studyingCourseArr[indexPath.row]];
        
        return cell;
    }
    else if (self.dataSourceType == 1)
    {
        MySPEndCourseView * cell = [tableView dequeueReusableCellWithIdentifier:@"myspend"];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MySPEndCourseView" owner:nil options:nil] firstObject];
        }
        
        [cell setData:self.endingCourseArr[indexPath.row]];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate pushToDetailVC:self dataSourseType:self.dataSourceType selIndexPath:indexPath];
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
        [[KGHttpService sharedService] MySPCourseList:[NSString stringWithFormat:@"%ld",(long)self.pageNo] isdisable:@"0" success:^(SPDataListVO *msg)
        {
            NSMutableArray * marr = [NSMutableArray array];
            
            marr = [NSMutableArray arrayWithArray:[MySPCourseDomain objectArrayWithKeyValuesArray:msg.data]];
             
            if (marr.count == 0)
            {
                self.tableView.footerRefreshingText = @"没有更多了...";
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                {
                    [self.tableView footerEndRefreshing];
                });
                
            }
            else
            {
                self.pageNo++;
                
                [self.studyingCourseArr addObjectsFromArray:marr];
                
                [self.tableView footerEndRefreshing];
                
                [self.tableView reloadData];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.studyingCourseArr.count - 1 inSection:0];
                
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
         }
         faild:^(NSString *errorMsg)
         {
             [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
         }];
    }
    else if (self.dataSourceType == 1)
    {
        [[KGHttpService sharedService] MySPCourseList:[NSString stringWithFormat:@"%ld",(long)self.pageNo] isdisable:@"1" success:^(SPDataListVO *msg)
        {
            NSMutableArray * marr = [NSMutableArray array];
            
            marr = [NSMutableArray arrayWithArray:[MySPCourseDomain objectArrayWithKeyValuesArray:msg.data]];
             
            if (marr.count == 0)
            {
                self.tableView.footerRefreshingText = @"没有更多了...";
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                {
                    [self.tableView footerEndRefreshing];
                });
                
            }
            else
            {
                self.pageNo++;
                
                [self.endingCourseArr addObjectsFromArray:marr];
                
                [self.tableView footerEndRefreshing];
                
                [self.tableView reloadData];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.endingCourseArr.count - 1 inSection:0];
                
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }

        }
        faild:^(NSString *errorMsg)
        {
              [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
        }];
    }
}


@end
