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
#import "FFMoiveSubmitView.h"
@interface GiftwareListVC () <UITableViewDataSource,UITableViewDelegate>
{
    UITableViewController * reFreshView;
   
    PageInfoDomain * pageInfo;
    FFMoiveSubmitView * _bottomView;
    NSMutableArray * dataSource;
     NSMutableArray * segmentUrlArray;
    NSInteger segmentIndex;
}

@end

@implementation GiftwareListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"精品相册";
//
    [self initSegmentedControl];
    [self initPageInfo];
    
    [self getTableData];
    
    [self initReFreshView];
}

- (void)initSegmentedControl
{
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"我的",@"所有",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake(0, 0,APPWINDOWWIDTH, 30.0);
    
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;//设置样式
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    segmentIndex=segmentedControl.selectedSegmentIndex;
     NSString * url0=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/fPMovie/queryMy.json"];
    NSString * url1=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/fPMovie/query.json"];
    segmentUrlArray= [[NSArray alloc]initWithObjects:url0,url1,nil];

   
    
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor redColor], NSForegroundColorAttributeName, nil ,nil];
    
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
}
-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    
    segmentIndex= Seg.selectedSegmentIndex;
    [self headerRereshing];
//    
//    switch (Index)
//    {
//        case 0:
//          
//            break;
//        case 1:
//            
//            break;
//            
//               default:
//            break;
//    }
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
          NSString * url=segmentUrlArray[segmentIndex];
    
    
    [[KGHttpService sharedService] fPMovie_queryByURL:url pageInfo:pageInfo success:^(NSArray *articlesArray)
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
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xF0F0F0);
    reFreshView.tableView.frame = CGRectMake(0, 30, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64-30);
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
         domain.reply_count=[[responseObjectDic objectForKey:@"reply_count"] integerValue];
         
         FPGiftwareDetialVC * infoVC = [[FPGiftwareDetialVC alloc] init];
         infoVC.domain=domain;
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
    NSString * url=segmentUrlArray[segmentIndex];
    
    
    [[KGHttpService sharedService] fPMovie_queryByURL:url pageInfo:pageInfo success:^(NSArray *articlesArray)
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
    
    NSString * url=segmentUrlArray[segmentIndex];
    
    
    [[KGHttpService sharedService] fPMovie_queryByURL:url pageInfo:pageInfo success:^(NSArray *articlesArray)
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
        return 351;
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
