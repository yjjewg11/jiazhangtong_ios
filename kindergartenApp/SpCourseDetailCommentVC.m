//
//  SpCourseDetailCommentVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/7.
//  Copyright © 2016年 funi. All rights reserved.
//
#import "SpCourseDetailCommentVC.h"
#import "MJRefresh.h"
#import "SpCourseCommentCell.h"
#import "KGHttpService.h"
#import "KGNSStringUtil.h"
#import "MJExtension.h"
#import "NoDataTableViewCell.h"

@interface SpCourseDetailCommentVC () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _rowHeight;
    
    NSInteger pageNo;
}

@end

@implementation SpCourseDetailCommentVC

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRefresh];
    
    pageNo = 2;
    
    self.tableView.frame = self.tableFrame;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count == 0)
    {
        return 1;
    }
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count == 0)
    {
        NoDataTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTableViewCell" owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    else
    {
        static NSString * commentID = @"commentID";
        
        SpCourseCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:commentID];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseCommentCell" owner:nil options:nil] firstObject];
        }
        
        [cell setDomain:self.dataSource[indexPath.row]];
        cell.rowHeight = [_rowHeight[indexPath.row] floatValue];
        
        return cell;
    }

}

- (void)getCommentData
{
    [[KGHttpService sharedService] getSPCourseComment:self.uuid pageNo:@"1" success:^(SPCommentVO *commentVO)
    {
         self.dataSource = [NSMutableArray arrayWithArray:[SPCommentDomain objectArrayWithKeyValuesArray:commentVO.data]];
         
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
         {
             [self calCommentCellHeight];
         });
     }
     faild:^(NSString *errorMsg)
     {
         
     }];
}

#pragma mark - 计算所有评论单元格的高度
- (void)calCommentCellHeight
{
    if (self.dataSource.count != 0)
    {
        //计算行高
        _rowHeight = [NSMutableArray array];
        
        for (SPCommentDomain * domain in self.dataSource)
        {
            NSString * text = domain.content;
            
            if ([text isEqualToString:@""] || text == nil)
            {
                [_rowHeight addObject:@(139)];
            }
            else
            {
                CGFloat textHeight = [KGNSStringUtil heightForString:text andWidth:KGSCREEN.size.width - 20];
                
                CGFloat height = 139 + ABS(67 - textHeight);
                
                [_rowHeight addObject:@(height)];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.tableView reloadData];
        });
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count == 0)
    {
        return 215;
    }
    else
        return [_rowHeight[indexPath.row] floatValue];
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
    [[KGHttpService sharedService] getSPCourseComment:self.uuid pageNo:[NSString stringWithFormat:@"%ld",(long)pageNo] success:^(SPCommentVO *commentVO)
    {
        NSMutableArray * marr = [NSMutableArray arrayWithArray:[SPCommentDomain objectArrayWithKeyValuesArray:commentVO.data]];
        
        if (marr.count == 0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                self.tableView.footerRefreshingText = @"没有更多了";
                [self.tableView footerEndRefreshing];
            });
        }
        else
        {
            pageNo++;
            [self.dataSource addObjectsFromArray:marr];
            [self.tableView footerEndRefreshing];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
            {
                [self calCommentCellHeight];
            });
        }
    }
    faild:^(NSString *errorMsg)
    {
        
    }];
}

@end
