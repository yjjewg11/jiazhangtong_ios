//
//  MyCollectionViewController.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/15.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "SpCourseDetailVC.h"
#import "YouHuiDetailVC.h"
#import "NoDataTableViewCell.h"
#import "BrowseURLViewController.h"

@interface MyCollectionViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableViewController * reFreshView;
    PageInfoDomain * pageInfo;
    NSMutableArray * dataSource;
}

@end

@implementation MyCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    
    pageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:99999];
    
    [self getTableData];
    
    [self createTableView];
}

- (void)getTableData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getFavoritesList:1 success:^(NSArray *favoritesArray)
    {
        [self hidenLoadView];
        
        pageInfo.pageNo = 2;
        
        dataSource = [NSMutableArray arrayWithArray:favoritesArray];
        
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
    [self createTableView];
}

//创建 tableview
- (void)createTableView
{
    reFreshView = [[UITableViewController alloc] init];;
    reFreshView.tableView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64);
    reFreshView.tableView.delegate = self;
    reFreshView.tableView.dataSource = self;
    reFreshView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xE7E7EE);
    
    [self setupRefresh];
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
    [[KGHttpService sharedService] getFavoritesList:pageInfo.pageNo success:^(NSArray *articlesArray)
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
    
    [[KGHttpService sharedService] getFavoritesList:pageInfo.pageNo success:^(NSArray *articlesArray)
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


#pragma mark - UITableViewDataSource,UITableViewDelegate
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource.count == 0)
    {
        NoDataTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTableViewCell" owner:nil options:nil] firstObject];
        
        return cell;
    }
    else
    {
        static NSString * ccid = @"mycollid";
        
        CollectNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ccid];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CollectNoticeTableViewCell" owner:nil options:nil] firstObject];
        }
        
        [cell setData:dataSource[indexPath.row]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource.count == 0)
    {
        return 204;
    }
    else
    {
        return 65;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FavoritesDomain * data = dataSource[indexPath.row];
    switch (data.type) {
        case Topic_Articles:{
        GiftwareArticlesInfoViewController * vc = [[GiftwareArticlesInfoViewController alloc] init];
            vc.annuuid = data.reluuid;
            vc.type=Topic_Articles;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Topic_XYGG:{
            
            GiftwareArticlesInfoViewController * vc = [[GiftwareArticlesInfoViewController alloc] init];
            vc.annuuid = data.reluuid;
            vc.type=Topic_XYGG;
            [self.navigationController pushViewController:vc animated:YES];
//            AnnouncementInfoViewController * vc = [[AnnouncementInfoViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Topic_ZSJH:{
            IntroductionViewController * vc = [[IntroductionViewController alloc] init];
            vc.isNoXYXG = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Topic_HTML:{
            if (data.url) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data.url]];
            }
        }
        case Topic_PXJG:{
            SPSchoolDetailVC * vc = [[SPSchoolDetailVC alloc] init];
            vc.groupuuid = data.reluuid;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Topic_PXKC:{
            SpCourseDetailVC * vc = [[SpCourseDetailVC alloc] init];
            vc.uuid = data.reluuid;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Topic_YHHD:{
            YouHuiDetailVC * vc = [[YouHuiDetailVC alloc] init];
            vc.uuid = data.reluuid;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Topic_FPGiftware:
        {
            FPGiftwareDetialVC * vc = [[FPGiftwareDetialVC alloc] init];
            vc.uuid=data.reluuid;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
          
            break;
            

        case Topic_FX:{
            BrowseURLViewController * vc = [[BrowseURLViewController alloc] init];
            vc.url = data.url;
            vc.useCookie = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
