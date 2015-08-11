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
#import "KGTextView.h"

@interface ReplyListViewController () <KGReFreshViewDelegate> {
    ReFreshTableViewController * reFreshView;
    PageInfoDomain * pageInfo;
    
    
    IBOutlet UIButton *sendBtn;
    IBOutlet KGTextView *replyTextView;
}


@end

@implementation ReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    
    [self initPageInfo];
    [self initReFreshView];
    replyTextView.placeholder = @"写下您的评论...";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initPageInfo {
    if(!pageInfo) {
        pageInfo = [[PageInfoDomain alloc] init];
    }
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


- (IBAction)sendBtnClicked:(UIButton *)sender {
    
}
@end
