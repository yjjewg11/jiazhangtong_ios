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
#import "MJRefresh.h"
#import "ShareDomain.h"
#import "UMSocial.h"
#import "BrowseURLViewController.h"
#import "NoDataTableViewCell.h"

#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"

#import "HLActionSheet.h"

@interface InteractViewController () <UITableViewDataSource,UITableViewDelegate,AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate,TopicTableViewCellDelegate,UMSocialUIDelegate,UIScrollViewDelegate>
{
    UITableViewController * reFreshView;
    
    NSMutableArray * interactArray;
    
    NSMutableArray * dataSource;
    
    PageInfoDomain * mainTypePageInfo; //主页互动使用
    PageInfoDomain * otherTypePageInfo; //其他页面的
    
    BOOL rdyToRefesh;
    
    AdMoGoView * _adView;
}

@end

@implementation InteractViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"互动";
    
    rdyToRefesh = NO;
    
    self.keyBoardController.isShowKeyBoard = YES;
    self.keyboardTopType = EmojiAndTextMode;
    
    NSArray * classArray = [KGHttpService sharedService].loginRespDomain.class_list;
    if(classArray && [classArray count] >Number_Zero)
    {
        UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangji"] style:UIBarButtonItemStyleDone target:self action:@selector(postNewTopic)];
        [rightBarItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    
    //芒果横幅广告
    _adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone
                                         adType:AdViewTypeNormalBanner                                adMoGoViewDelegate:self
                                      autoScale:YES];
    _adView.adWebBrowswerDelegate = self;
    _adView.frame = CGRectMake((APPWINDOWWIDTH - 320)/2, 0.0, APPWINDOWWIDTH, 50.0);
    [self.view addSubview:_adView];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    mainTypePageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:99999];
    otherTypePageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:99999];
    
    //第一次请求数据
    [self getTableData];
    
    [self initReFreshView];
}

- (void)dealloc
{
    NSLog(@"delloc --- ");
    _adView.adWebBrowswerDelegate = nil;
    _adView.delegate = nil;
    _adView = nil;//清除掉
    reFreshView = nil;
    interactArray = nil;
    dataSource = nil;
    mainTypePageInfo = nil;
    otherTypePageInfo = nil;
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
        if([topic.uuid isEqualToString:self.topicInteractionDomain.topicUUID])
        {
            if(!topic.replyPage)
            {
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

//获取数据加载表格
- (void)getTableData
{
    [self showLoadView];
    
    if (self.dataScourseType == 0)
    {
        [[KGHttpService sharedService] getClassNews:mainTypePageInfo success:^(PageInfoDomain *pageInfo)
        {
            [self hidenLoadView];
            
            interactArray = [NSMutableArray arrayWithArray:pageInfo.data];
            
            dataSource = [NSMutableArray arrayWithArray:[self topicFramesWithtopics]];
            
            mainTypePageInfo.pageNo++;
            
            [self.view addSubview:reFreshView.tableView];
        }
        faild:^(NSString *errorMsg)
        {
            [self hidenLoadView];
            [self showNoNetView];
        }];
    }
    else
    {
        [self getTableDataOfSchoolOrClass];
    }
}

- (void)tryBtnClicked
{
    [self hidenNoNetView];
    [self getTableData];
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
        [self hidenLoadView];
        
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
    rdyToRefesh = NO;
    
    [dataSource removeAllObjects];
    dataSource = nil;
    
    mainTypePageInfo.pageNo = 1;
    otherTypePageInfo.pageNo = 1;
    
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
    reFreshView.tableView.frame = CGRectMake(0, 50, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 50);
    [self setupRefresh];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource.count == 0)
    {
        NoDataTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTableViewCell" owner:nil options:nil]firstObject];
        
        reFreshView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return cell;
    }
    else
    {
        static NSString * topiccellid = @"tpcid";
        
        TopicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:topiccellid];
        
        if (cell == nil)
        {
            cell = [[TopicTableViewCell alloc] init];
        }
        
        cell.delegate = self;
        
        cell.topicFrame = dataSource[indexPath.row];
        
        return cell;
    }
}

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
        TopicFrame *frame = dataSource[indexPath.row];
        return frame.cellHeight;
    }
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

#pragma mark - 芒果ad
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark AdMoGoDelegate delegate
/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingModalView
{
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
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView
{
    _adView.hidden = YES;
    reFreshView.tableView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64);
}


- (void)openWebWithUrl:(NSString *)url
{
    if (url == nil || [url isEqualToString:@""])
    {
        url = @"http://www.wenjienet.com/";
    }
    
    BrowseURLViewController * vc = [[BrowseURLViewController alloc] init];
    vc.title = @"详情";
    vc.useCookie = NO;
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    NSArray *titles = @[@"微博",@"微信",@"朋友圈",@"QQ好友",@"复制链接"];
    NSArray *imageNames = @[@"xinlang",@"weixin",@"pyquan",@"QQ",@"fuzhilianjie"];
    HLActionSheet *sheet = [[HLActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    
    [sheet showActionSheetWithClickBlock:^(NSInteger btnIndex)
     {
         switch (btnIndex)
         {
             case 0:
             {
                 [self handelShareWithShareType:UMShareToSina domain:domain];
             }
                 break;
                 
             case 1:
             {
                 [self handelShareWithShareType:UMShareToWechatSession domain:domain];
             }
                 break;
                 
             case 2:
             {
                 [self handelShareWithShareType:UMShareToWechatTimeline domain:domain];
             }
                 break;
                 
             case 3:
             {
                 [self handelShareWithShareType:UMShareToQQ domain:domain];
             }
                 break;
                 
             case 4:
             {
                 UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
                 pasteboard.string = domain.httpurl;
                 //提示复制成功
                 UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已复制分享链接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 [av show];
             }
                 break;
                 
             default:
                 break;
         }
     }
     cancelBlock:^
     {
         NSLog(@"取消");
     }];
}

#pragma mark - 处理分享操作
- (void)handelShareWithShareType:(NSString *)shareType domain:(ShareDomain *)domain
{
    NSString * contentString = domain.title;
    
    NSString * shareurl = domain.httpurl;
    
    if(!shareurl || [shareurl length] == 0)
    {
        shareurl = @"http://wenjie.net";
    }
    
    //微信title设置方法：
    [UMSocialData defaultData].extConfig.wechatSessionData.title = domain.title;
    
    //朋友圈title设置方法：
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = domain.title;
    [UMSocialWechatHandler setWXAppId:@"wx6699cf8b21e12618" appSecret:@"639c78a45d012434370f4c1afc57acd1" url:domain.httpurl];
    [UMSocialData defaultData].extConfig.qqData.title = domain.title;
    [UMSocialData defaultData].extConfig.qqData.url = domain.httpurl;
    
    if (shareType == UMShareToSina)
    {
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",contentString,shareurl];
        [UMSocialData defaultData].extConfig.sinaData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:shareurl];
    }
    
    //设置分享内容，和回调对象
    [[UMSocialControllerService defaultControllerService] setShareText:contentString shareImage:[UIImage imageNamed:@"jiazhang_180"] socialUIDelegate:self];
    
    UMSocialSnsPlatform * snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareType];
    
    snsPlatform.snsClickHandler(self, [UMSocialControllerService defaultControllerService],YES);
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    UIAlertView * alertView;
    NSString * string;
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        string = @"分享成功";
    }
    else if (response.responseCode == UMSResponseCodeCancel)
    {
    }
    else
    {
        string = @"分享失败";
    }
    if (string && string.length)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark AdMoGoWebBrowserControllerUserDelegate delegate
/*
 浏览器将要展示
 */
- (void)webBrowserWillAppear
{
    NSLog(@"浏览器将要展示");
}

/*
 浏览器已经展示
 */
- (void)webBrowserDidAppear
{
    NSLog(@"浏览器已经展示");
}

/*
 浏览器将要关闭
 */
- (void)webBrowserWillClosed
{
    NSLog(@"浏览器将要关闭");
}

/*
 浏览器已经关闭
 */
- (void)webBrowserDidClosed
{
    NSLog(@"浏览器已经关闭");
}
/**
 *直接下载类广告 是否弹出Alert确认
 */
- (BOOL)shouldAlertQAView:(UIAlertView *)alertView
{
    return YES;
}

- (void)webBrowserShare:(NSString *)url
{
    
}


@end
