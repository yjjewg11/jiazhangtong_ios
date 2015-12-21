//
//  GiftwareArticlesViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/31.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "GiftwareArticlesViewController.h"
#import "MJRefresh.h"
#import "KGHttpService.h"
#import "AnnouncementDomain.h"
#import "KGHUD.h"
#import "PageInfoDomain.h"
#import "UIColor+Extension.h"
#import "GiftwareArticlesInfoViewController.h"
#import "GiftwareArticlesTableViewCell.h"

@interface GiftwareArticlesViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableViewController * reFreshView;

    PageInfoDomain * pageInfo;
    
    NSMutableArray * dataSource;
}

@end

@implementation GiftwareArticlesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"精品文章";
    
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
    [[KGHttpService sharedService] getArticlesList:pageInfo success:^(NSArray *articlesArray)
    {
        pageInfo.pageNo ++;
        
        dataSource = [NSMutableArray arrayWithArray:articlesArray];
        
        [self.view addSubview:reFreshView.tableView];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}


//初始化列表
- (void)initReFreshView
{
    reFreshView = [[UITableViewController alloc] init];
    reFreshView.tableView.delegate = self;
    reFreshView.tableView.dataSource = self;
    reFreshView.tableView.rowHeight         = 132;
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xEBEBF2);
    reFreshView.tableView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64);
    [self setupRefresh];
}

#pragma mark - num of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

#pragma mark - cell for row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * giftwareArticlesID = @"artid";
    
    GiftwareArticlesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:giftwareArticlesID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GiftwareArticlesTableViewCell" owner:nil options:nil] firstObject];
    }
    
    [cell setAnnouncementDomain:dataSource[indexPath.row]];
    
    return cell;
}

#pragma mark - 选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementDomain * annDomain = dataSource[indexPath.row];
    
    GiftwareArticlesInfoViewController * infoVC = [[GiftwareArticlesInfoViewController alloc] init];
    
    infoVC.annuuid = annDomain.uuid;
    
    [self.navigationController pushViewController:infoVC animated:YES];
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
    [[KGHttpService sharedService] getArticlesList:pageInfo success:^(NSArray *articlesArray)
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
    
    [[KGHttpService sharedService] getArticlesList:pageInfo success:^(NSArray *articlesArray)
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

@end
