//
//  ReplyListViewController.m
//  kindergartenApp
//
//  Created by You on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "ReplyListViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "PageInfoDomain.h"
#import "UIColor+Extension.h"
#import "UIButton+Extension.h"
#import "KGNSStringUtil.h"
#import "MJRefresh.h"
#import "NoDataTableViewCell.h"
#import "ReplyTableViewCell.h"

@interface ReplyListViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableViewController * reFreshView;
    
    PageInfoDomain * pageInfo;
    
    IBOutlet UIButton *sendBtn;
    
    NSMutableArray * dataSource;
}

@end

@implementation ReplyListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"评论";
    
    self.keyBoardController.isShowKeyBoard = YES;
    
    self.keyboardTopType = EmojiAndTextMode;
    
    [self initViewParam];
    
    [self getTableData];
    
    [self initReFreshView];
}

- (void)initViewParam
{
    if(!pageInfo)
    {
        pageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:99999];
    }
    
    [_replyBtn setText:@"写下您的评论..."];
    _replyBtn.titleLabel.font = [UIFont systemFontOfSize:APPUILABELFONTNO12];
    [_replyBtn setTextColor:[UIColor grayColor] sel:[UIColor grayColor]];
    _replyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _replyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _replyBtn.layer.borderWidth = 1;
    _replyBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.topicInteractionDomain = [TopicInteractionDomain new];
    self.topicInteractionDomain.topicType = _topicType;
    self.topicInteractionDomain.topicUUID = _topicUUID;
}

//获取数据加载表格
- (void)getTableData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getReplyList:pageInfo topicUUID:_topicUUID success:^(PageInfoDomain *pageInfoResp)
    {
        pageInfo.pageNo ++;
        
        dataSource = [NSMutableArray arrayWithArray:pageInfoResp.data];
        
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
    [self initReFreshView];
}


//初始化列表
- (void)initReFreshView
{
    reFreshView = [[UITableViewController alloc] init];
    reFreshView.tableView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 40 - 64);
    reFreshView.tableView.delegate = self;
    reFreshView.tableView.dataSource = self;
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xE7E7EE);
    [self setupRefresh];
}

#pragma reFreshView Delegate
- (IBAction)writeReplyBtnClicked:(UIButton *)sender
{
    NSDictionary *dic = @{Key_TopicInteractionDomain : self.topicInteractionDomain};
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_BeginReplyTopic object:self userInfo:dic];
}

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain
{
    [reFreshView.tableView headerBeginRefreshing];
//    NSMutableArray * dataMArray = reFreshView.dataSource;
//    if(!dataMArray){
//        dataMArray = [NSMutableArray new];
//        reFreshView.dataSource = dataMArray;
//    }
//    [dataMArray insertObject:domain atIndex:Number_Zero];
//    [reFreshView.tableView reloadData];
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

- (void)footerRereshing
{
    [[KGHttpService sharedService] getReplyList:pageInfo topicUUID:_topicUUID success:^(PageInfoDomain *articlesArray)
     {
         if (articlesArray.data.count != 0)
         {
             pageInfo.pageNo ++;
             
             [dataSource addObjectsFromArray:articlesArray.data];
             
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
    
    [[KGHttpService sharedService] getReplyList:pageInfo topicUUID:_topicUUID success:^(PageInfoDomain *pageInfoResp)
    {
         pageInfo.pageNo ++;
         
         dataSource = [NSMutableArray arrayWithArray:pageInfoResp.data];
         
         [reFreshView.tableView headerEndRefreshing];
         
         [reFreshView.tableView reloadData];
     }
     faild:^(NSString *errorMsg)
     {
         [reFreshView.tableView headerEndRefreshing];
         [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
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
        static NSString * aaid = @"replyid";
        
        ReplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:aaid];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyTableViewCell" owner:nil options:nil] firstObject];
        }
        
        [cell resetValue:dataSource[indexPath.row] parame:nil];
        
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
@end
