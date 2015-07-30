//
//  TestViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/14.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initReFreshView];
}


//获取数据加载表格
- (void)getTableData{
    NSMutableArray * dataMArray = [[NSMutableArray alloc] initWithObjects:@"111", @"222", @"333", nil];
    reFreshView.tableParam.dataSourceMArray   = dataMArray;
    [reFreshView reloadRefreshTable];
//    [reFreshView initReFreshTable];
}


//初始化列表
- (void)initReFreshView{
//    reFreshView = [[FuniReFreshView alloc] initRefresh:self.view];
    reFreshView = [[ReFreshTableViewController alloc] initRefreshView];
    reFreshView._delegate = self;
    reFreshView.tableParam.cellHeight       = Number_Fifty;
    reFreshView.tableParam.cellClassNameStr = @"TestTableViewCell";
//    reFreshView.tableParam.isPullReFresh    = NO;
//    reFreshView.backgroundColor = [UIColor whiteColor];
//    reFreshView.alpha = Number_ViewAlpha_Zero;
//    [reFreshView initReFreshTable];
    [reFreshView appendToView:self.contentView];
    
    [reFreshView beginRefreshing];
//    [self getTableData];
}

//选中cell
- (void)didSelectRowCallBack:(id)baseDomain to:(NSString *)toClassName{
    
}

//tabelviewcell height
- (CGFloat)tableViewCellHeight:(NSIndexPath *)indexPath{
    return Number_Fifty;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
