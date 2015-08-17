//
//  TeacherJudgeViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TeacherJudgeViewController.h"
#import "ReFreshTableViewController.h"
#import "KGHttpService.h"
#import "TeacherVO.h"
#import "KGHUD.h"
#import "PageInfoDomain.h"
#import "UIColor+Extension.h"
#import "TeacherJudgeTableViewCell.h"

@interface TeacherJudgeViewController () <KGReFreshViewDelegate> {
    ReFreshTableViewController * reFreshView;
    PageInfoDomain * pageInfo;
}

@end

@implementation TeacherJudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评价老师";
    
    [self initPageInfo];
    [self initReFreshView];
    
    //注册点赞回复通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teacherJudgeClickedNotification:) name:Key_Notification_TeacherJudge object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initPageInfo {
    if(!pageInfo) {
        pageInfo = [[PageInfoDomain alloc] init];
    }
}

//cell点击监听通知
- (void)teacherJudgeClickedNotification:(NSNotification *)notification {
    NSDictionary * dic = [notification userInfo];
    TeacherVO * teacherObj = [dic objectForKey:@"tearchVO"];
    TeacherJudgeTableViewCell * cell = [dic objectForKey:@"tableViewCell"];
    
    [self saveTeacherJudge:teacherObj cell:cell];
}

//获取数据加载表格
- (void)getTableData{
    pageInfo.pageNo = reFreshView.page;
    pageInfo.pageSize = reFreshView.pageSize;
    
    [[KGHttpService sharedService] getTeacherList:^(NSArray *teacherArray) {
        [reFreshView.dataSource removeAllObjects];
        reFreshView.tableParam.dataSourceMArray = teacherArray;
        [reFreshView reloadRefreshTable];
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        [reFreshView endRefreshing];
    }];
}

//保存老师评价
- (void)saveTeacherJudge:(TeacherVO *)teacherVO cell:(TeacherJudgeTableViewCell *)cell{
    
    [[KGHUD sharedHud] show:self.contentView];
    [[KGHttpService sharedService] saveTeacherJudge:teacherVO success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        [cell judgedHandler];
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}


//初始化列表
- (void)initReFreshView{
    reFreshView = [[ReFreshTableViewController alloc] initRefreshView];
    reFreshView._delegate = self;
    reFreshView.tableParam.cellHeight       = 232;
    reFreshView.tableParam.cellClassNameStr = @"TeacherJudgeTableViewCell";
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
    
}


@end
