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

@interface InteractViewController () <KGReFreshViewDelegate, UIWebViewDelegate> {
    ReFreshTableViewController * reFreshView;
    IBOutlet UIWebView * myWebView;
    
    
}

@end

@implementation InteractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"互动";
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangji"] style:UIBarButtonItemStyleDone target:self action:@selector(postTopic:)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    myWebView.delegate = self;
    
    NSString * url = [NSString stringWithFormat:@"%@&JSESSIONID=%@", [KGHttpUrl getClassNewsHTMLURL], [KGHttpService sharedService].loginRespDomain.JSESSIONID];
    [myWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]];
    
//    [self initReFreshView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellFunClickedNotification:) name:Key_Notification_TopicFunClicked object:nil];
}

//cell点击监听通知
- (void)cellFunClickedNotification:(NSNotification *)notification {
    NSDictionary * dic = [notification userInfo];
    NSInteger type = [[dic objectForKey:Key_TopicCellFunType] integerValue];
    NSString * uuid = [dic objectForKey:Key_TopicUUID];
    BOOL isSelected = [[dic objectForKey:Key_TopicFunRequestType] boolValue];
    
    if(type == Number_Ten) {
        //点赞
        [self dzOperationHandler:isSelected uuid:uuid];
    } else {
        //回复
        [self postTopic:uuid];
    }
}


- (void)dzOperationHandler:(BOOL)isSelected uuid:(NSString *)uuid {
    
    if(isSelected) {
        //点赞
        [[KGHttpService sharedService] saveDZ:uuid type:Topic_Interact success:^(NSString *msgStr) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    } else {
        //取消点赞
        [[KGHttpService sharedService] delDZ:uuid success:^(NSString *msgStr) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)postTopic:(NSString *)topicUUID {
    PostTopicViewController * ptVC = [[PostTopicViewController alloc] init];
    ptVC.topicType = Topic_Interact;
    ptVC.topicUUID = topicUUID;
    [self.navigationController pushViewController:ptVC animated:YES];
}


//获取数据加载表格
- (void)getTableData{
    
    [[KGHttpService sharedService] getClassNews:[[PageInfoDomain alloc] initPageInfo:reFreshView.page size:reFreshView.pageSize] success:^(PageInfoDomain *pageInfo) {
        
        reFreshView.tableParam.dataSourceMArray = [self topicFramesWithtopics:pageInfo.data];;
        [reFreshView reloadRefreshTable];
        
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        [reFreshView endRefreshing];
    }];
}


//初始化列表
- (void)initReFreshView{
    reFreshView = [[ReFreshTableViewController alloc] initRefreshView];
    reFreshView._delegate = self;
    reFreshView.tableParam.cellHeight       = Number_Fifty;
    reFreshView.tableParam.cellClassNameStr = @"TestTableViewCell";
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xEBEBF2);
    [reFreshView appendToView:self.contentView];
    [reFreshView beginRefreshing];
}

#pragma reFreshView Delegate 

- (UITableViewCell *)createTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    // 获得cell
    TopicTableViewCell * cell = [TopicTableViewCell cellWithTableView:tableView];
    cell.topicFrame = reFreshView.dataSource[indexPath.row];
    return cell;
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
    TopicFrame *frame = reFreshView.dataSource[indexPath.row];
    return frame.cellHeight;
}


//转换对象
- (NSArray *)topicFramesWithtopics:(NSArray *)topics
{
    NSMutableArray *frames = [NSMutableArray array];
    for (TopicDomain * topic in topics) {
        TopicFrame * f = [[TopicFrame alloc] init];
        f.topic = topic;
        [frames addObject:f];
    }
    return frames;
}


@end
