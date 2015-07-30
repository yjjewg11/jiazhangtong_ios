//
//  AnnouncementListViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/21.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AnnouncementListViewController.h"
#import "ReFreshTableViewController.h"
#import "KGHttpService.h"
#import "AnnouncementDomain.h"
#import "KGHUD.h"
#import "PageInfoDomain.h"
#import "UIColor+Extension.h"

@interface AnnouncementListViewController () <KGReFreshViewDelegate> {
    ReFreshTableViewController * reFreshView;
    PageInfoDomain * pageInfo;
}


@end

@implementation AnnouncementListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公告";
    
    [self initPageInfo];
    [self initReFreshView];
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
    
    [[KGHttpService sharedService] getAnnouncementList:pageInfo success:^(NSArray *announcementArray) {
        reFreshView.tableParam.dataSourceMArray = announcementArray;
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
    reFreshView.tableParam.cellClassNameStr = @"AnnouncementTableViewCell";
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xEBEBF2);
    [reFreshView appendToView:self.contentView];
    [reFreshView beginRefreshing];
}

#pragma reFreshView Delegate

//- (UITableViewCell *)createTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
//    // 获得cell
//    TopicTableViewCell * cell = [TopicTableViewCell cellWithTableView:tableView];
//    cell.topicFrame = reFreshView.dataSource[indexPath.row];
//    return cell;
//}

//选中cell
- (void)didSelectRowCallBack:(id)baseDomain to:(NSString *)toClassName{
    
}


@end
