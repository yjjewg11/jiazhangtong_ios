//
//  上拉加载更多 下拉刷新的delegate
//
//  Created by rockyang on 14/11/16.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol KGReFreshViewDelegate <NSObject>


@optional
/**
 *  获取数据加载表格
 */
- (void)getTableData;

@optional
/**
 *  对table数据进行排序
 *
 *  @param dataSource table中所有数据
 */
- (void)refreshDataSourceSort:(NSMutableArray *)dataSource;

@optional
/**
 *  上下刷新table
 *
 *  @param isFooter YES上拉  NO下拉
 */
- (void)refreshTableCallBack:(bool)isFooter;


@optional
///
- (UITableViewCell *)createTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@optional
/**
 *  选中cell
 *
 *  @param baseDomain  选中cell绑定的数据对象
 *  @param tableView   tableView
 *  @param indexPath   indexPath
 */
- (void)didSelectRowCallBack:(id)baseDomain tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@optional
/**
 *  动态设置table cell的高
 *
 *  @param indexPath indexPath
 *
 *  @return 返回cell的高
 */
- (CGFloat)tableViewCellHeight:(NSIndexPath *)indexPath;


@optional
/**
 *  cell已经移出表视图回调
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 */
- (void)didLoadTableViewCellBack:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath*)indexPath;


@optional
/**
 *  scrollView开始滚动
 *
 *  @param scrollView
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;


@optional
/**
 *  scrollView滚动中
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;


@optional
/**
 *  scrollView滚动结束
 *
 *  @param scrollView
 *  @param index
 */
- (void)scrollViewRollEnd:(UIScrollView *)scrollView index:(NSInteger)index;


@optional
/**
 *  滚动后时离开屏幕
 *
 *  @param scrollView scrollView对象
 *  @param decelerate
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;


@optional
/**
 *  删除cell
 *
 *  @param baseDomain 删除行的数据对象
 *  @param cellCount  cell数量
 */
- (void) commitDeleteCallBack:(id)baseDomain cellCount:(NSInteger)cellCount;

@end
