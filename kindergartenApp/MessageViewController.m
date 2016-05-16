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
#import "FPGiftwareDetialVC.h"

@interface MessageViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableViewController * reFreshView;
    PageInfoDomain * pageInfo;
    NSMutableArray * dataSource;
}

@end

@implementation MessageViewController

//延迟刷新
- (void)lazyRefresh
{
    [reFreshView.tableView headerBeginRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息";
    
    [self initPageInfo];
    
    [self getTableData];
    
    [self initReFreshView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [reFreshView.tableView headerBeginRefreshing];
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

- (void)tryBtnClicked
{
    [self hidenNoNetView];
    [self getTableData];
    [self initReFreshView];
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
            vc = [[GiftwareArticlesInfoViewController alloc] init];
            ((GiftwareArticlesInfoViewController *)vc).annuuid = domain.rel_uuid;
            ((GiftwareArticlesInfoViewController *)vc).type = Topic_XYGG;
            break;

        case Topic_Announcement:
            vc = [[GiftwareArticlesInfoViewController alloc] init];
            ((GiftwareArticlesInfoViewController *)vc).annuuid = domain.rel_uuid;
            ((GiftwareArticlesInfoViewController *)vc).type = Topic_Announcement;
            break;
            
            
        case Topic_Articles:
            vc = [[GiftwareArticlesInfoViewController alloc] init];
            ((GiftwareArticlesInfoViewController *)vc).annuuid = domain.rel_uuid;
             ((GiftwareArticlesInfoViewController *)vc).type = Topic_Articles;
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
            
        case Topic_FPFamilyPhotoCollection:
        {
              UIWindow* window = [UIApplication sharedApplication].keyWindow;
            
            if([window.rootViewController isKindOfClass:[KGTabBarViewController class]]){
                __weak KGTabBarViewController * kgvc=window.rootViewController;
                [kgvc goFPFamilyPhotoMainViewController];
            }

        }
            
            

           //           vc= [[FPHomeVC alloc] init];
//            if(domain.rel_uuid!=nil&&domain.rel_uuid.length>0){
//             [FPHomeVC setFamily_uuid:domain.rel_uuid];
//            }
            break;

        case Topic_FPGiftware:
            
            vc = [[FPGiftwareDetialVC alloc] init];
            ((FPGiftwareDetialVC *)vc).uuid=domain.rel_uuid;
            
            break;
            
        case Topic_FPTimeLine:
            if(domain.rel_uuid!=nil&&domain.rel_uuid.length>0){
                [self loadFPFamilyPhotoNormalDomainByUuid:domain.rel_uuid];
            }
            
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

- (void)chatMesagePush:(MessageDomain *)domain
{
    AddressBookDomain * addressbookDomain = [[AddressBookDomain alloc] init];
    addressbookDomain.teacher_uuid = domain.rel_uuid;
    addressbookDomain.type = (domain.type == Topic_TeacherChat) ? YES : NO;
    addressbookDomain.img  = domain.url;
    ChatViewController * chatVC = [[ChatViewController alloc] init];
    chatVC.addressbookDomain = addressbookDomain;
    [self.navigationController pushViewController:chatVC animated:YES];
}

//readMsg
- (void)readMessage:(MessageDomain *)domain cell:(MessageTableViewCell *)cell
{
    [[KGHttpService sharedService] readMessage:domain.uuid success:^(NSString *msgStr)
    {
        domain.isread = YES;
        
        cell.unReadIconImageView.hidden = YES;
        
    }
    faild:^(NSString *errorMsg)
    {
        
    }];
}


-(void)loadFPFamilyPhotoNormalDomainByUuid:(NSString *)uuid{
        MBProgressHUD * hub=[MBProgressHUD showMessage:@"更新数据，请稍后"];
        hub.removeFromSuperViewOnHide=YES;
        
        //请求最新domain
        [[KGHttpService sharedService] getFPTimeLineItem:uuid success:^(FPFamilyPhotoNormalDomain *item)
         {
             
             [hub hide:YES];
             [[DBNetDaoService defaulService] updatePhotoItemInfo:item];
             
             //更新数据库
             
             item.status=0;
             
             NSMutableArray *arr=[NSMutableArray array];
             [arr addObject:item];
             FPTimeLineDetailVC * vc = [[FPTimeLineDetailVC alloc] init];
             vc.fpPhotoNormalDomainArr=arr;
             vc.selectIndex=0;
             vc.title=[[item.create_time componentsSeparatedByString:@" "] firstObject];
             ;
             [self.navigationController pushViewController:vc animated:YES];

             
             
             
         }
                                                   faild:^(NSString *errorMsg)
         {
             [hub hide:YES];
             [MBProgressHUD showError:@"获取最新相片信息失败!"];
         }];
}


@end
