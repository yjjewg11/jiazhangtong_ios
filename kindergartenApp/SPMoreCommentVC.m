//
//  SPMoreCommitVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/1.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPMoreCommentVC.h"
#import "KGHUD.h"
#import "KGHttpService.h"
#import "SpCourseCommentCell.h"
#import "KGNSStringUtil.h"
#import "MJRefresh.h"

@interface SPMoreCommentVC ()

@property (strong, nonatomic) NSMutableArray * commitDomains;
@property (assign, nonatomic) NSInteger page;

@end

@implementation SPMoreCommentVC

- (NSMutableArray *)commitDomains
{
    if (_commitDomains == nil)
    {
        _commitDomains = [NSMutableArray array];
    }
    return _commitDomains;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDatas];
    
}

#pragma mark - 根据页数请求数据
- (void)loadDatas
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseComment:self.ext_uuid pageNo:[NSString stringWithFormat:@"%ld",self.page] success:^(SPCommentDomain *spComment)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        [self.commitDomains addObject:spComment];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 表格数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commitDomains.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * resID = @"comment_cell";
    SpCourseCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:resID];
    
    [cell setDomain:self.commitDomains[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPCommentDomain * domain = self.commitDomains[indexPath.row];
    
    float textSize = [KGNSStringUtil heightForString:domain.content andWidth:APPWINDOWWIDTH - 20];
    
    return textSize + Number_Ten;
}

#pragma mark - 上拉刷新，下拉加载数据
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //自动刷新(一进入程序就下拉刷新)
    //    [self.tableVC.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开立即刷新";
    self.tableView.headerRefreshingText = @"正在刷新中...";
    
    self.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableView.footerReleaseToRefreshText = @"松开立即加载更多";
    self.tableView.footerRefreshingText = @"正在加载中...";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    for (int i = 0; i < 5; i++)
    {
        
    }
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
       // 刷新表格
       [self.tableView reloadData];
       
       // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
       [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加数据
    for (int i = 0; i < 5; i++)
    {
        
    }
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
       // 刷新表格
       [self.tableView reloadData];
       
       // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
       [self.tableView footerEndRefreshing];
    });
}




@end
