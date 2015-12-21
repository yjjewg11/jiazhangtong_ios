//
//  InteractViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "InteractViewController.h"
#import "ReFreshTableViewController.h"
#import "KGHttpService.h"
#import "PageInfoDomain.h"
#import "KGHUD.h"
#import "TopicDomain.h"
#import "TopicFrame.h"
#import "TopicTableViewCell.h"
#import "UIColor+Extension.h"
#import "PostTopicViewController.h"
#import "KGHttpUrl.h"
#import "DiscorveryWebVC.h"
#import "MJRefresh.h"
#import "ShareDomain.h"
#import "UMSocial.h"
#import "BrowseURLViewController.h"

#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"

@interface InteractViewController () <UITableViewDataSource,UITableViewDelegate,AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate,TopicTableViewCellDelegate,UMSocialUIDelegate>
{
    UITableViewController * reFreshView;
    NSMutableArray * interactArray;
    
    NSMutableArray * dataSource;
    
    PageInfoDomain * mainTypePageInfo; //主页互动使用
    PageInfoDomain * otherTypePageInfo; //其他页面的
}

@property (strong, nonatomic) AdMoGoView * adView;

@end

@implementation InteractViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"互动";
    
    self.keyBoardController.isShowKeyBoard = YES;
    self.keyboardTopType = EmojiAndTextMode;
    
    NSArray * classArray = [KGHttpService sharedService].loginRespDomain.class_list;
    if(classArray && [classArray count] >Number_Zero) {
        UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangji"] style:UIBarButtonItemStyleDone target:self action:@selector(postNewTopic)];
        [rightBarItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    
    //芒果横幅广告
    self.adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone
                                         adType:AdViewTypeNormalBanner                                adMoGoViewDelegate:self
                                      autoScale:YES];
    self.adView.adWebBrowswerDelegate = self;
    self.adView.frame = CGRectMake(0.0, 0.0, APPWINDOWWIDTH, 50.0);

    if ([[UIDevice currentDevice].systemVersion floatValue] >=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    mainTypePageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:99999];
    otherTypePageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:99999];
    
    //第一次请求数据
    [self getTableData];
    
    [self initReFreshView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//延迟刷新
- (void)lazyRefresh
{
    [reFreshView.tableView headerBeginRefreshing];
}

- (void)postNewTopic
{
    if (self.dataScourseType == 0)
    {
        PostTopicViewController * postVC = [[PostTopicViewController alloc] init];
        postVC.topicType = Topic_Interact;
        
        postVC.PostTopicBlock = ^(TopicDomain * domain) {
            //发表互动成功
            [self performSelector:@selector(lazyRefresh) withObject:self afterDelay:1];
        };
        
        [self.navigationController pushViewController:postVC animated:YES];
    }
}

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain {
    
    for (TopicDomain * topic in interactArray) {
        if([topic.uuid isEqualToString:self.topicInteractionDomain.topicUUID]) {
            if(!topic.replyPage) {
                topic.replyPage = [[ReplyPageDomain alloc] init];
            }
            [topic.replyPage.data insertObject:domain atIndex:Number_Zero];
            break;
        }
    }
//    reFreshView.tableParam.dataSourceMArray = [self topicFramesWithtopics];
    dataSource = [[NSMutableArray alloc] initWithArray:[self topicFramesWithtopics]];
    [reFreshView.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//获取数据加载表格
- (void)getTableData
{
    if (self.dataScourseType == 0)
    {
        [[KGHttpService sharedService] getClassNews:mainTypePageInfo success:^(PageInfoDomain *pageInfo) {
            
            interactArray = [NSMutableArray arrayWithArray:pageInfo.data];
            
            dataSource = [NSMutableArray arrayWithArray:[self topicFramesWithtopics]];
            
            mainTypePageInfo.pageNo++;
            
            [self.view addSubview:reFreshView.tableView];
        }
        faild:^(NSString *errorMsg)
        {
             [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
    else
    {
        [self getTableDataOfSchoolOrClass];
    }

}

- (void)getTableDataOfSchoolOrClass
{
    if (self.groupuuid == nil)
    {
        self.groupuuid = @"";
    }
    
    if (self.courseuuid == nil)
    {
        self.courseuuid = @"";
    }
    
    [[KGHttpService sharedService] getClassOrSchoolNews:otherTypePageInfo groupuuid:self.groupuuid courseuuid:self.courseuuid success:^(PageInfoDomain *pageInfo)
    {
        interactArray = [NSMutableArray arrayWithArray:pageInfo.data];
        
        dataSource = [NSMutableArray arrayWithArray:[self topicFramesWithtopics]];
        
        otherTypePageInfo.pageNo++;
        
        [self.view addSubview:reFreshView.tableView];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}

#pragma mark - 上拉刷新，下拉加载数据
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

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    if (self.dataScourseType == 0)
    {
        [[KGHttpService sharedService] getClassNews:mainTypePageInfo success:^(PageInfoDomain *pageInfo)
        {
            if (pageInfo.data.count != 0)
            {
                mainTypePageInfo.pageNo++;
                
                interactArray = [NSMutableArray arrayWithArray:pageInfo.data];
                
                [dataSource addObjectsFromArray:[NSMutableArray arrayWithArray:[self topicFramesWithtopics]]];
                
                [reFreshView.tableView footerEndRefreshing];
                
                [reFreshView.tableView reloadData];
            }
            else
            {
                reFreshView.tableView.headerRefreshingText = @"没有更多了...";
                [reFreshView.tableView footerEndRefreshing];
            }
        }
        faild:^(NSString *errorMsg)
        {
             [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
    else
    {
        if (self.groupuuid == nil)
        {
            self.groupuuid = @"";
        }
        
        if (self.courseuuid == nil)
        {
            self.courseuuid = @"";
        }
        
        [[KGHttpService sharedService] getClassOrSchoolNews:otherTypePageInfo groupuuid:self.groupuuid courseuuid:self.courseuuid success:^(PageInfoDomain *pageInfo)
         {
             if (pageInfo.data.count != 0)
             {
                 otherTypePageInfo.pageNo++;
                 
                 interactArray = [NSMutableArray arrayWithArray:pageInfo.data];
                 
                 [dataSource addObjectsFromArray:[NSMutableArray arrayWithArray:[self topicFramesWithtopics]]];
                 
                 [reFreshView.tableView footerEndRefreshing];
                 
                 [reFreshView.tableView reloadData];
             }
             else
             {
                 reFreshView.tableView.headerRefreshingText = @"没有更多了...";
                 [reFreshView.tableView footerEndRefreshing];
             }
         }
         faild:^(NSString *errorMsg)
         {
             [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
         }];
    }
}

- (void)headerRereshing
{
    [dataSource removeAllObjects];
    [interactArray removeAllObjects];
    
    mainTypePageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:99999];
    otherTypePageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:99999];
    
    [self refreshData];
}

- (void)refreshData
{
    if (self.dataScourseType == 0)
    {
        [[KGHttpService sharedService] getClassNews:mainTypePageInfo success:^(PageInfoDomain *pageInfo) {
            
            interactArray = [NSMutableArray arrayWithArray:pageInfo.data];
            
            dataSource = [NSMutableArray arrayWithArray:[self topicFramesWithtopics]];
            
            mainTypePageInfo.pageNo++;
            
            [reFreshView.tableView headerEndRefreshing];
            
            [reFreshView.tableView reloadData];
         }
         faild:^(NSString *errorMsg)
         {
             [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
         }];
    }
    else
    {
        if (self.groupuuid == nil)
        {
            self.groupuuid = @"";
        }
        
        if (self.courseuuid == nil)
        {
            self.courseuuid = @"";
        }
        
        [[KGHttpService sharedService] getClassOrSchoolNews:otherTypePageInfo groupuuid:self.groupuuid courseuuid:self.courseuuid success:^(PageInfoDomain *pageInfo)
         {
             interactArray = [NSMutableArray arrayWithArray:pageInfo.data];
             
             dataSource = [NSMutableArray arrayWithArray:[self topicFramesWithtopics]];
             
             otherTypePageInfo.pageNo++;
            
             [reFreshView.tableView headerEndRefreshing];
             
             [reFreshView.tableView reloadData];
         }
         faild:^(NSString *errorMsg)
         {
             [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
         }];
    }
}

#pragma mark - 创建tableview
- (void)initReFreshView
{
    reFreshView = [[UITableViewController alloc] init];
    reFreshView.tableView.delegate = self;
    reFreshView.tableView.dataSource = self;
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xEBEBF2);
    reFreshView.tableView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64);
    [self setupRefresh];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获得cell
    if(indexPath.row == 0)
    {
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [cell addSubview:self.adView];
        
        return cell;
    }
    
    else
    {
        TopicTableViewCell * cell = [TopicTableViewCell cellWithTableView:tableView];
        
        cell.delegate = self;
        
        cell.topicFrame = dataSource[indexPath.row - 1];
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 50;
    }
    
    TopicFrame *frame = dataSource[indexPath.row - 1];
    return frame.cellHeight;
}

//转换对象
- (NSArray *)topicFramesWithtopics
{
    NSMutableArray *frames = [NSMutableArray array];
    for (TopicDomain * topic in interactArray) {
        TopicFrame * f = [[TopicFrame alloc] init];
        f.topic = topic;
        [frames addObject:f];
    }
    return frames;
}

#pragma mark - 芒果
#pragma mark - 芒果ad
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark AdMoGoDelegate delegate
/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingModalView{
    return self;
}

/**
 * 广告开始请求回调
 */
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告开始请求回调");
}
/**
 * 广告接收成功回调
 */
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告接收成功回调");
}
/**
 * 广告接收失败回调
 */
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error{
    NSLog(@"广告接收失败回调");
}
/**
 * 点击广告回调
 */
- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView{
    NSLog(@"点击广告回调");
}
/**
 *You can get notified when the user delete the ad
 广告关闭回调
 */
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告关闭回调");
}

#pragma mark -
#pragma mark AdMoGoWebBrowserControllerUserDelegate delegate

/*
 浏览器将要展示
 */
- (void)webBrowserWillAppear{
    NSLog(@"浏览器将要展示");
}

/*
 浏览器已经展示
 */
- (void)webBrowserDidAppear{
    NSLog(@"浏览器已经展示");
}

/*
 浏览器将要关闭
 */
- (void)webBrowserWillClosed{
    NSLog(@"浏览器将要关闭");
}

/*
 浏览器已经关闭
 */
- (void)webBrowserDidClosed{
    NSLog(@"浏览器已经关闭");
}
/**
 *直接下载类广告 是否弹出Alert确认
 */
-(BOOL)shouldAlertQAView:(UIAlertView *)alertView
{
    return YES;
}

- (void)webBrowserShare:(NSString *)url
{
    
}

- (void)openWebWithUrl:(NSString *)url
{
    if (url != nil && ![url isEqualToString:@""])
    {
        BrowseURLViewController * vc = [[BrowseURLViewController alloc] init];
        vc.title = @"详情";
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)openShareWindow:(NSString *)url title:(NSString *)title
{
    if (url == nil)
    {
        url = @"";
    }
    if (title == nil)
    {
        title = @"";
    }
    
    ShareDomain * domain = [[ShareDomain alloc] init];
    
    domain.title = title;
    
    domain.pathurl = url;
    
    domain.httpurl = url;
    
    domain.content = title;
    
    //微博
    [UMSocialData defaultData].extConfig.sinaData.urlResource.resourceType = UMSocialUrlResourceTypeImage;
    [UMSocialData defaultData].extConfig.sinaData.shareText = domain.httpurl;
    //微信
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = domain.httpurl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = domain.httpurl;
    //qq
    [UMSocialData defaultData].extConfig.qqData.urlResource.resourceType = UMSocialUrlResourceTypeImage;
    [UMSocialData defaultData].extConfig.qqData.url = domain.httpurl;
    
    [UMSocialSnsService presentSnsController:self appKey:@"55be15a4e0f55a624c007b24" shareText:domain.content shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:domain.pathurl]]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil] delegate:self];
}


@end
