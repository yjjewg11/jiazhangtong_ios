//
//  SpCourseDetailTableVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseDetailTableVC.h"
#import "SPCommentDomain.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "StudentInfoHeaderView.h"
#import "MJRefresh.h"
#import "SpCourseCommentCell.h"
#import "MJExtension.h"
#import "NoDataTableViewCell.h"

@interface SpCourseDetailTableVC () <UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) NSInteger pageNO;

@end

@implementation SpCourseDetailTableVC

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        
    }
    return self;
}

- (NSMutableArray *)rowHeights
{
    if (_rowHeights == nil)
    {
        _rowHeights = [NSMutableArray array];
    }
    return _rowHeights;
}

- (NSMutableArray *)presentsComments
{
    if (_presentsComments == nil)
    {
        _presentsComments = [NSMutableArray array];
    }
    return _presentsComments;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRefresh];
    
    self.pageNO = 2;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.frame = self.tableFrame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.presentsComments.count == 0)
    {
        return 1;
    }
    else
    {
        return self.presentsComments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.presentsComments.count == 0)
    {
        NoDataTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTableViewCell" owner:nil options:nil] firstObject];
        
        return cell;
    }
    
    static NSString * commentCellID = @"comment_cell_id";
    
    SpCourseCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseCommentCell" owner:nil options:nil] firstObject];
    }
    
    //设置数据
    [cell setDomain:self.presentsComments[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.presentsComments.count != 0)
    {
        return [self.rowHeights[indexPath.row] floatValue];
    }
    else if (self.presentsComments.count == 0)
    {
        return 204;
    }
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 上拉刷新，下拉加载数据
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableView.footerReleaseToRefreshText = @"松开立即加载";
    self.tableView.footerRefreshingText = @"正在加载中...";
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    [[KGHttpService sharedService] getSPCourseComment:self.uuid pageNo:[NSString stringWithFormat:@"%ld",(long)self.pageNO] success:^(SPCommentVO *commentVO)
    {
        NSArray * tempArr = [NSArray arrayWithArray:[SPCommentDomain objectArrayWithKeyValuesArray:commentVO.data]];
        
        if (tempArr.count == 0 || tempArr == nil)
        {
            self.tableView.footerRefreshingText = @"没有更多了.";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [self.tableView footerEndRefreshing];
            });
        }
        else
        {
            self.pageNO++;
            
            [self.presentsComments addObjectsFromArray:tempArr];
            
            [self.tableView footerEndRefreshing];
            
            [self.tableView reloadData];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.presentsComments.count - 1 inSection:0];
            
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    faild:^(NSString *errorMsg)
    {
         [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

@end
