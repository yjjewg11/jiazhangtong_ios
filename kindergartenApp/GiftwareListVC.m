//
//  GiftwareListVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/27.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "GiftwareListVC.h"
#import "MJRefresh.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "PageInfoDomain.h"
#import "UIColor+Extension.h"
#import "NoDataTableViewCell.h"
#import "GiftwareListTableViewCell.h"
#import "MJExtension.h"
#import "FPGiftwareDetialVC.h"
@interface GiftwareListVC () <UITableViewDataSource,UITableViewDelegate>
{
    UITableViewController * reFreshView;
    
    PageInfoDomain * pageInfo;
    
    NSMutableArray * dataSource;
}@end

@implementation GiftwareListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"精品相册";
    
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
    
    [[KGHttpService sharedService] fPMovie_queryMy:pageInfo success:^(NSArray *articlesArray)
     {
         pageInfo.pageNo ++;
         
         dataSource = [NSMutableArray arrayWithArray:articlesArray];
         
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
        NoDataTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTableViewCell" owner:nil options:nil] firstObject];
        
        reFreshView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return cell;
    }
    else
    {
        static NSString * giftwareArticlesID = @"GiftwareListTableViewCell";
        
        GiftwareListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:giftwareArticlesID];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GiftwareListTableViewCell" owner:nil options:nil] firstObject];
            
        }
              
        [cell setDomain:dataSource[indexPath.row]];
        
        return cell;
    }
}

#pragma mark - 选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPMoive4QDomain * annDomain = dataSource[indexPath.row];
    
    [[KGHUD sharedHud] show:self.view];
    [[KGHttpService sharedService] getByUuid:@"/rest/fPMovie/get.json" uuid:annDomain.uuid success:^(id responseObject)
     {
         [[KGHUD sharedHud] hide:self.view];
           FPMoive4QDomain * domain=[FPMoive4QDomain objectWithKeyValues:[responseObject objectForKey:@"data"]];
         
         NSDictionary *responseObjectDic=responseObject;
         domain.share_url=[responseObjectDic objectForKey:@"share_url"];
         domain.reply_count=[responseObjectDic objectForKey:@"reply_count"];
         
         FPGiftwareDetialVC * infoVC = [[FPGiftwareDetialVC alloc] init];
         
         [self.navigationController pushViewController:infoVC animated:YES];
         
     }
          faild:^(NSString *errorMsg)
     {
          [[KGHUD sharedHud] hide:self.view];
         
             [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
     }];

    
//
//    GiftwareArticlesInfoViewController * infoVC = [[GiftwareArticlesInfoViewController alloc] init];
//    
//    infoVC.annuuid = annDomain.uuid;
//    
//    infoVC.title = annDomain.title;
//    
//    [self.navigationController pushViewController:infoVC animated:YES];
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
    [[KGHttpService sharedService] fPMovie_queryMy:pageInfo success:^(NSArray *articlesArray)
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
    
    [[KGHttpService sharedService] fPMovie_queryMy:pageInfo success:^(NSArray *articlesArray)
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource.count == 0)
    {
        return 204;
    }
    else
    {
        return 260;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
