//
//  MessageViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "MessageViewController.h"
#import "KGHttpService.h"
#import "MessageDomain.h"
#import "KGHUD.h"
#import "PageInfoDomain.h"
#import "UIColor+Extension.h"
#import "BrowseURLViewController.h"
#import "InteractViewController.h"
#import "IntroductionViewController.h"
#import "TimetableViewController.h"
#import "RecipesListViewController.h"
#import "GiftwareArticlesInfoViewController.h"
#import "AnnouncementInfoViewController.h"
#import "MessageTableViewCell.h"
#import "AddressBookDomain.h"
#import "ChatViewController.h"
#import "StudentSignRecordViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "NoDataTableViewCell.h"
#import "MessageTableViewCell.h"

@interface MessageViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableViewController * reFreshView;
    PageInfoDomain * pageInfo;
    NSMutableArray * dataSource;
}

@end

@implementation MessageViewController

//延迟刷新
- (void)lazyRefresh\
{
    [reFreshView.tableView headerBeginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    
    [self initPageInfo];
    
    [self getTableData];
    
    [self initReFreshView];
}

- (void)initPageInfo {
    if(!pageInfo) {
        pageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:99999];
    }
}

//获取数据加载表格
- (void)getTableData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getMessageList:pageInfo success:^(NSArray *messageArray)
    {
        pageInfo.pageNo++;
        
        [self hidenLoadView];
        
        dataSource = [NSMutableArray arrayWithArray:messageArray];
        
        [self.view addSubview:reFreshView.tableView];
    }
    faild:^(NSString *errorMsg)
    {
        [self hidenLoadView];
        [self showNoNetView];
    }];
}


//初始化列表
- (void)initReFreshView
{
    reFreshView = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    reFreshView.tableView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64);
    reFreshView.tableView.delegate = self;
    reFreshView.tableView.dataSource = self;
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xEBEBF2);
    reFreshView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [[KGHttpService sharedService] getMessageList:pageInfo success:^(NSArray *articlesArray)
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
    
    [[KGHttpService sharedService] getMessageList:pageInfo success:^(NSArray *articlesArray)
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

#pragma mark - tableview delegate
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource.count == 0)
    {
        return 204;
    }
    else
    {
        return 78;
    }
}

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
        static NSString * bbID = @"messageid";
        
        MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:bbID];
    
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:nil options:nil] firstObject];
        }
        
        [cell resetValue:dataSource[indexPath.row] parame:nil];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDomain * domain = dataSource[indexPath.row];
    
    BaseViewController * vc = nil;
    
    switch (domain.type) {
        case Topic_XYGG:
        case Topic_Announcement:
            vc = [[AnnouncementInfoViewController alloc] init];
            ((AnnouncementInfoViewController *)vc).annuuid = domain.rel_uuid;
            break;
        case Topic_Articles:
            vc = [[GiftwareArticlesInfoViewController alloc] init];
            ((GiftwareArticlesInfoViewController *)vc).annuuid = domain.rel_uuid;
            break;
        case Topic_ZSJH:
            vc = [[IntroductionViewController alloc] init];
            ((IntroductionViewController *)vc).isNoXYXG = YES;
            break;
        case Topic_Recipes:
            vc = [[RecipesListViewController alloc] init];
            break;
        case Topic_JPKC:
            vc = [[TimetableViewController alloc] init];
            break;
        case Topic_YEYJS:
            vc = [[IntroductionViewController alloc] init];
            break;
        case Topic_Interact:
            vc = [[InteractViewController alloc] init];
            break;
        case Topic_TeacherChat:
        case Topic_LeaderChat:
            [self chatMesagePush:domain];
            break;
        case Topic_SignRecord:
            vc = [[StudentSignRecordViewController alloc] init];
            break;
        case Topic_HTML:
            vc = [[BrowseURLViewController alloc] init];
            ((BrowseURLViewController *)vc).url = domain.url;
            break;
        default:
            break;
    }
    
    if(vc) {
        vc.title = domain.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    MessageTableViewCell * cell = (MessageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self readMessage:domain cell:cell];
}

- (void)chatMesagePush:(MessageDomain *)domain {
    AddressBookDomain * addressbookDomain = [[AddressBookDomain alloc] init];
    addressbookDomain.teacher_uuid = domain.rel_uuid;
    addressbookDomain.type = (domain.type == Topic_TeacherChat) ? YES : NO;
    addressbookDomain.img  = domain.url;
    ChatViewController * chatVC = [[ChatViewController alloc] init];
    chatVC.addressbookDomain = addressbookDomain;
    [self.navigationController pushViewController:chatVC animated:YES];
}

//readMsg
- (void)readMessage:(MessageDomain *)domain cell:(MessageTableViewCell *)cell {
    [[KGHttpService sharedService] readMessage:domain.uuid success:^(NSString *msgStr) {
        domain.isread = YES;
        
        cell.unReadIconImageView.hidden = YES;
        
    } faild:^(NSString *errorMsg) {
        
    }];
}


@end
