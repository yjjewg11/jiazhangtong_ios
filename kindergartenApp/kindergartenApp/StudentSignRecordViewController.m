//
//  StudentSignRecordViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentSignRecordViewController.h"
#import "StudentSignRecordTableViewCell.h"
#import "StudentSignRecordDomain.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "ReFreshTableViewController.h"
#import "UIColor+Extension.h"

@interface StudentSignRecordViewController () <KGReFreshViewDelegate> {
    ReFreshTableViewController * reFreshView;
}

@end

@implementation StudentSignRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签到记录";

    [self initReFreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//初始化列表
- (void)initReFreshView{
    reFreshView = [[ReFreshTableViewController alloc] initRefreshView];
    reFreshView._delegate = self;
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xEBEBF2);
    reFreshView.tableParam.cellClassNameStr = @"StudentSignRecordTableViewCell";
    reFreshView.tableParam.cellHeight = 97;
    [reFreshView appendToView:self.contentView];
    [reFreshView beginRefreshing];
}

//获取数据加载表格
- (void)getTableData{
    
    [[KGHttpService sharedService] getStudentSignRecordList:reFreshView.page success:^(NSArray *recordArray) {
        
        reFreshView.tableParam.dataSourceMArray = recordArray;
        [reFreshView reloadRefreshTable];
        
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}

@end
