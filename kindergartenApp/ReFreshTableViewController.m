//
//  ReFreshTableViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/17.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "ReFreshTableViewController.h"
#import "ReFreshBaseCell.h"
#import "MJRefresh.h"
#import "UIView+Extension.h"
#import "Masonry.h"

#define CellIdentifier @"CellIdentifier"

@interface ReFreshTableViewController () {
    NSIndexPath         * lastSelIndexPath;
    NSInteger             dataCount;
}

@end

@implementation ReFreshTableViewController


/**
 *  初始化表格所需参数
 */
- (void)initParamer
{
    _page     = Number_One;
    _pageSize = Number_Ten;
    _tableParam = [[KGTableParam alloc] init];
    _tableParam.cellHeight        = CELL_DEFHEIGHT;
    _tableParam.isPullReFresh     = YES;
}


/**
 *  根据表格参数对象构造拉动刷新table
 *
 *  @param parantView 父View
 *
 *  @return 返回可拉动刷新的table
 */
- (id)initRefreshView {
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        [self initParamer];
    }
    return self;
}


- (void)appendToView:(UIView *)parantView {
    [parantView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parantView.mas_top);
        make.left.equalTo(parantView.mas_left);
        make.right.equalTo(parantView.mas_right);
        make.bottom.equalTo(parantView.mas_bottom);
    }];
    
    [self loadPullReFresh];
}


/**
 *  根据新的数据源重新加载列表
 *
 *  @param newData 新数据源
 *  @param page    当前页码
 */
- (void)reloadRefreshTable {
    [self endRefreshing];
    
    if(_page == Number_One){
        [_dataSource removeAllObjects];
        _dataSource = (NSMutableArray *)_tableParam.dataSourceMArray;
    }else{
        [_dataSource addObjectsFromArray:_tableParam.dataSourceMArray];
    }
    
    [self refreshDataSourceSort];
    
    if([_dataSource count] > dataCount && [_dataSource count] > _pageSize) {
        [NSTimer scheduledTimerWithTimeInterval:Number_ViewAlpha_Five target:self selector:@selector(dispatchAsyncReloadData:) userInfo:nil repeats:NO];
    }else {
        [self.tableView reloadData];
    }
    dataCount = [_dataSource count];
}


/**
 *  对table数据进行排序
 *
 */
- (void)refreshDataSourceSort {
    if(__delegate && [__delegate respondsToSelector:@selector(refreshDataSourceSort:)]) {
        [__delegate refreshDataSourceSort:_dataSource];
    }
}


//在子线程里面刷新tableview数据源 防止在界面正在滚动的时候刷新导致崩溃
//当tableView正在滚动的时候，如果reloadData，偶尔会发生App crash的情况。
//在tableView的_dataSource被改变 和 tableView的reloadData被调用之间有个时间差，而正是在这个期间，
//tableView的delegate方法被调用，如果新的_dataSource的count小于原来的_dataSource count，crash就很有可能发生了。
- (void)dispatchAsyncReloadData:(NSTimer *)timer{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        //上拉加载更多成功之后设置tableview的显示y+50 可以看到新的数据
//        if(_isFooter){
//            CGPoint point = self.tableView.contentOffset;
//            point.y = point.y + _tableParam.cellHeight / 2;
//            //            self.tableView.contentOffset = point;
//            [self.tableView setContentOffset:point animated:YES];
//        }
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataSource = (NSMutableArray *)_tableParam.dataSourceMArray;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        // ios7下 tableview的分割线默认会缩进15px   这里取消默认不缩进
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    self.view = self.tableView;
}


/**
 *  为表格加载刷新支持
 */
- (void)loadPullReFresh{
    if(_tableParam.isPullReFresh){
        __weak id s = self;
        // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
        [self.tableView addHeaderWithCallback:^{
            [s reFreshTable:NO];
        }];
        
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        [self.tableView addFooterWithCallback:^{
            [s reFreshTable:YES];
        }];
    }
}


#pragma mark 开始进入刷新状态

- (void)reFreshTable:(BOOL)__isFooter{
    _isFooter = __isFooter;
    if(!__isFooter) {
        _page = Number_One;
    } else {
        _page = ([_dataSource count] + _pageSize - Number_One) / _pageSize;
        _page += Number_One;
    }
    
    [self getTableData];
}


/**
 *  获取数据加载表格
 */
- (void)getTableData{
    if(__delegate && [__delegate respondsToSelector:@selector(getTableData)])
        [__delegate getTableData];
}


/**
 *  让刷新控件恢复默认的状态
 */
- (void)endRefreshing{
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView headerEndRefreshing];
}


/**
 *  开始刷新表格
 */
- (void)beginRefreshing{
    [self.tableView headerBeginRefreshing];
}

#pragma tableViewDelegate 数据源-代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return Number_One;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(__delegate && [__delegate respondsToSelector:@selector(createTableViewCell:indexPath:)]) {
        return [__delegate createTableViewCell:tableView indexPath:indexPath];
    } else {
        ReFreshBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:_tableParam.cellClassNameStr owner:nil options:nil];
            cell = [nib objectAtIndex:Number_Zero];
        }
        
        if(_tableParam.isSelectedStatus) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        cell.tag = indexPath.row;
        
        [self dynamicCellHeight:cell indexPath:indexPath];
        
        if(indexPath.row < [_dataSource count]) {
            if(![_dataSource isEqual:[NSNull null]] && [_dataSource count]>0){
                [cell resetValue:[_dataSource objectAtIndex:indexPath.row] parame:_tableParam.paramMDict ? _tableParam.paramMDict : nil];
            }
        }
        
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(__delegate && [__delegate respondsToSelector:@selector(tableViewCellHeight:)]){
        return [__delegate tableViewCellHeight:indexPath];
    }else{
        return _tableParam.cellHeight;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_tableParam.isSelectedStatus) {
        
        UITableViewCell * lastCell = [self tableView:tableView cellForRowAtIndexPath:lastSelIndexPath];
        lastCell.contentView.backgroundColor = _tableParam.cellDefBgColor;
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = _tableParam.cellSelBgColor;
        lastSelIndexPath = indexPath;
    }
    
    if([__delegate respondsToSelector:@selector(didSelectRowCallBack:tableView:indexPath:)]) {
        [__delegate didSelectRowCallBack:[_dataSource objectAtIndex:indexPath.row] tableView:tableView indexPath:indexPath];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.editing)
        return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [_dataSource removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (__delegate && [__delegate respondsToSelector:@selector(commitDeleteCallBack:cellCount:)]){
            NSInteger count = [self tableView:tableView numberOfRowsInSection:0];
            [__delegate commitDeleteCallBack:[_dataSource objectAtIndex:row] cellCount:count];
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_DELTEXT;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


//cell已经移出表视图回调
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if([__delegate respondsToSelector:@selector(didLoadTableViewCellBack:forRowAtIndexPath:)])
        [__delegate didLoadTableViewCellBack:tableView forRowAtIndexPath:indexPath];
}


//动态设置cell的height
- (void)dynamicCellHeight:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if(__delegate && [__delegate respondsToSelector:@selector(tableViewCellHeight:)]){
        CGFloat height = [__delegate tableViewCellHeight:indexPath];
        [cell setHeight:height];
    }
}


//已经结束拖拽，手指刚离开view的那一刻
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([__delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [__delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if([__delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [__delegate scrollViewWillBeginDragging:scrollView];
}


#pragma UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([__delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [__delegate scrollViewDidScroll:scrollView];
}


@end
