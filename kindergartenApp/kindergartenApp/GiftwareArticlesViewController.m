//
//  GiftwareArticlesViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/31.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "GiftwareArticlesViewController.h"
#import "ReFreshTableViewController.h"
#import "KGHttpService.h"
#import "AnnouncementDomain.h"
#import "KGHUD.h"
#import "PageInfoDomain.h"
#import "UIColor+Extension.h"
#import "GiftwareArticlesInfoViewController.h"

@interface GiftwareArticlesViewController () <KGReFreshViewDelegate> {
    ReFreshTableViewController * reFreshView;
    PageInfoDomain * pageInfo;
}


@end

@implementation GiftwareArticlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"精品文章";
    
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
    
    [[KGHttpService sharedService] getArticlesList:pageInfo success:^(NSArray *articlesArray) {
        reFreshView.tableParam.dataSourceMArray = articlesArray;
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
    reFreshView.tableParam.cellHeight       = 132;
    reFreshView.tableParam.cellClassNameStr = @"GiftwareArticlesTableViewCell";
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xEBEBF2);
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
    GiftwareArticlesInfoViewController * infoVC = [[GiftwareArticlesInfoViewController alloc] init];
    infoVC.announcementDomain = baseDomain;
    [self.navigationController pushViewController:infoVC animated:YES];
}



@end
