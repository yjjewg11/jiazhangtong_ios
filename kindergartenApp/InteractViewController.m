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

#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"

@interface InteractViewController () <KGReFreshViewDelegate,AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate> {
    ReFreshTableViewController * reFreshView;
    NSArray * interactArray;
}

@property (strong, nonatomic) AdMoGoView * adView;

@end

@implementation InteractViewController

- (void)viewDidLoad {
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
    
    [self initReFreshView];
    
    //芒果横幅广告
    self.adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone
                                         adType:AdViewTypeNormalBanner                                adMoGoViewDelegate:self
                                      autoScale:YES];
    self.adView.adWebBrowswerDelegate = self;
    self.adView.frame = CGRectMake(0.0, 0.0, APPWINDOWWIDTH, 50.0);

    if ([[UIDevice currentDevice].systemVersion floatValue] >=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//延迟刷新
- (void)lazyRefresh{
    [reFreshView beginRefreshing];
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
    reFreshView.dataSource = [[NSMutableArray alloc] initWithArray:[self topicFramesWithtopics]];
    [reFreshView.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//获取数据加载表格
- (void)getTableData{
    
    if (self.dataScourseType == 0)
    {
        [[KGHttpService sharedService] getClassNews:[[PageInfoDomain alloc] initPageInfo:reFreshView.page size:reFreshView.pageSize] success:^(PageInfoDomain *pageInfo) {
            
            interactArray = pageInfo.data;
            
            reFreshView.tableParam.dataSourceMArray = [self topicFramesWithtopics];
            
            [reFreshView reloadRefreshTable];
            
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
            [reFreshView endRefreshing];
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
    
    [[KGHttpService sharedService] getClassOrSchoolNews:[[PageInfoDomain alloc] initPageInfo:reFreshView.page size:reFreshView.pageSize] groupuuid:self.groupuuid courseuuid:self.courseuuid success:^(PageInfoDomain *pageInfo)
    {
        interactArray = pageInfo.data;
        
        reFreshView.tableParam.dataSourceMArray = [self topicFramesWithtopics];
        [reFreshView reloadRefreshTable];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        [reFreshView endRefreshing];
    }];
}

//初始化列表
- (void)initReFreshView{
    reFreshView = [[ReFreshTableViewController alloc] initRefreshView];
    reFreshView._delegate = self;
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xEBEBF2);
    [reFreshView appendToView:self.contentView];
    [reFreshView beginRefreshing];
}

#pragma reFreshView Delegate 

- (UITableViewCell *)createTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
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
        
        cell.topicFrame = reFreshView.dataSource[indexPath.row - 1];
        return cell;
    }
    

}

//选中cell
- (void)didSelectRowCallBack:(id)baseDomain to:(NSString *)toClassName{
    
}


/**
 *  动态设置table cell的高
 *
 *  @param indexPath indexPath
 *
 *  @return 返回cell的高
 */
- (CGFloat)tableViewCellHeight:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
    {
        return 50;
    }
    
    TopicFrame *frame = reFreshView.dataSource[indexPath.row - 1];
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
-(BOOL)shouldAlertQAView:(UIAlertView *)alertView{
    return NO;
}

- (void)webBrowserShare:(NSString *)url{
    
}



@end
