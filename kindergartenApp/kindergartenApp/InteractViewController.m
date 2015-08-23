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

@interface InteractViewController () <KGReFreshViewDelegate> {
    ReFreshTableViewController * reFreshView;
    IBOutlet UIWebView * myWebView;
    NSArray * interactArray;
}

@end

@implementation InteractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"互动";
    
    self.keyBoardController.isShowKeyBoard = YES;
    self.keyboardTopType = EmojiAndTextMode;
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangji"] style:UIBarButtonItemStyleDone target:self action:@selector(postNewTopic)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self initReFreshView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [reFreshView beginRefreshing];
//    [self performSelector:@selector(lazyRefresh) withObject:self afterDelay:1];
}

//延迟刷新
- (void)lazyRefresh{
    [reFreshView beginRefreshing];
}

- (void)postNewTopic {
    PostTopicViewController * postVC = [[PostTopicViewController alloc] init];
    postVC.topicType = Topic_Interact;
    
    postVC.PostTopicBlock = ^(TopicDomain * domain) {
        //发表互动成功
        [self performSelector:@selector(lazyRefresh) withObject:self afterDelay:1];
    };

    [self.navigationController pushViewController:postVC animated:YES];
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
    
    [[KGHttpService sharedService] getClassNews:[[PageInfoDomain alloc] initPageInfo:reFreshView.page size:reFreshView.pageSize] success:^(PageInfoDomain *pageInfo) {
        
        interactArray = pageInfo.data;
        
        reFreshView.tableParam.dataSourceMArray = [self topicFramesWithtopics];
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


@end
