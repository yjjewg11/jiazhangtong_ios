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

@interface SpCourseDetailTableVC () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * commentsCells;

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

- (NSMutableArray *)commentsCells
{
    if (_commentsCells == nil)
    {
        _commentsCells = [NSMutableArray array];
    }
    return _commentsCells;
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
    return self.presentsComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * commentCellID = @"comment_cell_id";
    
    SpCourseCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseCommentCell" owner:nil options:nil] firstObject];
    }
    
    [self.commentsCells addObject:cell];
    
    //设置数据
    [cell setDomain:self.presentsComments[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.commentsCells.count !=0 && self.commentsCells != nil)
    {
        SpCourseCommentCell * cell = self.commentsCells[indexPath.row];
        
        return cell.rowHeight;
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
