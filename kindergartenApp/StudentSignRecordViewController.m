//
//  StudentSignRecordViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentSignRecordViewController.h"
#import "StudentSignRecordTableViewCell.h"
#import "StudentSignRecordDomain.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "ReFreshTableViewController.h"
#import "UIColor+Extension.h"
#import "MJRefresh.h"
#import "PageInfoDomain.h"
#import "NoDataTableViewCell.h"

@interface StudentSignRecordViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UITableViewController * reFreshView;
    PageInfoDomain * pageInfo;
    NSMutableArray * dataSource;
}

@end

@implementation StudentSignRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"签到记录";

    [self initPageInfo];
    
    [self getTableData];
    
    [self initReFreshView];
}

- (void)initPageInfo
{
    if(!pageInfo)
    {
        pageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:99999];
    }
}

//初始化列表
- (void)initReFreshView
{
    reFreshView = [[UITableViewController alloc] init];
    reFreshView.tableView.delegate = self;
    reFreshView.tableView.dataSource = self;
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xEBEBF2);
    reFreshView.tableView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64);
    [self setupRefresh];
}

//获取数据加载表格
- (void)getTableData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getStudentSignRecordList:pageInfo.pageNo success:^(NSArray *recordArray)
    {
        [self hidenLoadView];
        pageInfo.pageNo++;
        dataSource = [NSMutableArray arrayWithArray:recordArray];
        [self.view addSubview:reFreshView.tableView];
    }
    faild:^(NSString *errorMsg)
    {
        [self hidenLoadView];
        [self showNoNetView];
    }];
}

- (void)tryBtnClicked
{
    [self hidenNoNetView];
    
    [self getTableData];
}

#pragma mark - 上啦下拉
- (void)setupRefresh
{
    [reFreshView.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    reFreshView.tableView.footerPullToRefreshText = @"上拉加载更多";
    reFreshView.tableView.footerReleaseToRefreshText = @"松开立即加载";
    reFreshView.tableView.footerRefreshingText = @"正在加载中...";
    
    [reFreshView.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    reFreshView.tableView.headerRefreshingText = @"正在刷新中...";
    reFreshView.tableView.headerPullToRefreshText = @"下拉刷新";
    reFreshView.tableView.headerReleaseToRefreshText = @"松开立即刷新";
}

- (void)footerRereshing
{
    [[KGHttpService sharedService] getStudentSignRecordList:pageInfo.pageNo success:^(NSArray *articlesArray)
     {
         if (articlesArray.count != 0)
         {
             pageInfo.pageNo ++;
             
             [dataSource addObjectsFromArray:articlesArray];
             
             [reFreshView.tableView footerEndRefreshing];
             
             [reFreshView.tableView reloadData];
         }
         else
         {
             reFreshView.tableView.footerRefreshingText = @"没有更多了...";
             
             [reFreshView.tableView footerEndRefreshing];
         }
         
     }
     faild:^(NSString *errorMsg)
     {
         [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
         [reFreshView.tableView footerEndRefreshing];
     }];
}

- (void)headerRereshing
{
    pageInfo.pageNo = 1;
    
    [dataSource removeAllObjects];
    dataSource = nil;
    
    [[KGHttpService sharedService] getStudentSignRecordList:pageInfo.pageNo success:^(NSArray *articlesArray)
     {
         pageInfo.pageNo ++;
         
         dataSource = [NSMutableArray arrayWithArray:articlesArray];
         
         [reFreshView.tableView headerEndRefreshing];
         
         [reFreshView.tableView reloadData];
     }
     faild:^(NSString *errorMsg)
     {
         [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
         [reFreshView.tableView headerEndRefreshing];
     }];
}

#pragma mark - num of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataSource.count != 0)
    {
        return dataSource.count;
    }
    else
    {
        return 1;
    }
}

#pragma mark - cell for row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource.count == 0)
    {
        NoDataTableViewCell * no = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTableViewCell" owner:nil options:nil] firstObject];
        
        reFreshView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return no;
    }
    else
    {
        static NSString * StudentSignRecordID = @"signid";
        
        StudentSignRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:StudentSignRecordID];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StudentSignRecordTableViewCell" owner:nil options:nil] firstObject];
        }
        
        [cell resetValue:dataSource[indexPath.row] parame:nil];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource.count != 0)
    {
        return 97;
    }
    else
    {
        return 204;
    }
}

@end
