//
//  AnnouncementListViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/21.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AnnouncementListViewController.h"
#import "KGHttpService.h"
#import "AnnouncementDomain.h"
#import "KGHUD.h"
#import "PageInfoDomain.h"
#import "UIColor+Extension.h"
#import "AnnouncementInfoViewController.h"
#import "MJRefresh.h"
#import "AnnouncementTableViewCell.h"
#import "NoDataTableViewCell.h"

@interface AnnouncementListViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableViewController * reFreshView;
    PageInfoDomain * pageInfo;
    NSMutableArray * dataSource;
}

@end

@implementation AnnouncementListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"公告";
    
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

//获取数据加载表格
- (void)getTableData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getAnnouncementList:pageInfo success:^(NSArray *announcementArray)
    {
        pageInfo.pageNo ++;
        
        dataSource = [NSMutableArray arrayWithArray:announcementArray];
        
        [self hidenLoadView];
        
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

#pragma mark - num of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataSource.count == 0)
    {
        return 1;
    }
    else
    {
        return dataSource.count;
    }
}

#pragma mark - cell for row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource.count == 0)
    {
        NoDataTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTableViewCell" owner:nil options:nil] firstObject];
        
        reFreshView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        reFreshView.tableView.scrollEnabled = NO;
        
        return cell;
    }
    else
    {
        static NSString * AnnouncementID = @"anounid";
        
        AnnouncementTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AnnouncementID];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AnnouncementTableViewCell" owner:nil options:nil] firstObject];
        }
        
        [cell setData:dataSource[indexPath.row]];
        
        return cell;
    }
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
    [[KGHttpService sharedService] getAnnouncementList:pageInfo success:^(NSArray *articlesArray)
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
    
    [[KGHttpService sharedService] getAnnouncementList:pageInfo success:^(NSArray *articlesArray)
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

#pragma reFreshView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementDomain * domain = dataSource[indexPath.row];
    AnnouncementInfoViewController * infoVC = [[AnnouncementInfoViewController alloc] init];
    infoVC.annuuid = domain.uuid;
    [self.navigationController pushViewController:infoVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource.count == 0)
    {
        return 204;
    }
    else
    {
        return 132;
    }
}
@end
