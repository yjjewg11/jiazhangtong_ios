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
#import "ReFreshTableViewController.h"
#import "UIColor+Extension.h"
#import "UIButton+Extension.h"
#import "KGNSStringUtil.h"

@interface ReplyListViewController () <KGReFreshViewDelegate> {
    ReFreshTableViewController * reFreshView;
    PageInfoDomain * pageInfo;
    
    IBOutlet UIButton *sendBtn;
}


@end

@implementation ReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    
    self.keyBoardController.isShowKeyBoard = YES;
    self.keyboardTopType = EmojiAndTextMode;
    
    [self initViewParam];
    [self initReFreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViewParam {
    if(!pageInfo) {
        pageInfo = [[PageInfoDomain alloc] init];
    }
    
    [_replyBtn setText:@"写下您的评论..."];
    _replyBtn.titleLabel.font = [UIFont systemFontOfSize:APPUILABELFONTNO12];
    [_replyBtn setTextColor:[UIColor grayColor] sel:[UIColor grayColor]];
    _replyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _replyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.topicInteractionDomain = [TopicInteractionDomain new];
    self.topicInteractionDomain.topicType = _topicType;
    self.topicInteractionDomain.topicUUID = _topicUUID;
}




//获取数据加载表格
- (void)getTableData{
    pageInfo.pageNo = reFreshView.page;
    pageInfo.pageSize = reFreshView.pageSize;
    
    [[KGHttpService sharedService] getReplyList:pageInfo topicUUID:_topicUUID success:^(PageInfoDomain *pageInfoResp) {
        reFreshView.tableParam.dataSourceMArray = pageInfoResp.data;
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
    reFreshView.tableParam.cellHeight       = 78;
    reFreshView.tableParam.cellClassNameStr = @"ReplyTableViewCell";
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xE7E7EE);
    [reFreshView appendToView:self.contentView];
    [reFreshView beginRefreshing];
}

#pragma reFreshView Delegate

/**
 *  选中cell
 *
 *  @param baseDomain  选中cell绑定的数据对象
 *  @param tableView   tableView
 *  @param indexPath   indexPath
 */
- (void)didSelectRowCallBack:(id)baseDomain tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
}


- (IBAction)writeReplyBtnClicked:(UIButton *)sender {
    NSDictionary *dic = @{Key_TopicInteractionDomain : self.topicInteractionDomain};
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_BeginReplyTopic object:self userInfo:dic];
}

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain {
    NSMutableArray * dataMArray = reFreshView.dataSource;
    if(!dataMArray){
        dataMArray = [NSMutableArray new];
        reFreshView.dataSource = dataMArray;
    }
    [dataMArray insertObject:domain atIndex:Number_Zero];
    [reFreshView.tableView reloadData];
}


@end
