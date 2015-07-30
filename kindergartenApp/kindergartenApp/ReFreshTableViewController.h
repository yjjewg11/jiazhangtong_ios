//
//  ReFreshTableViewController.h
//  kindergartenApp
//
//  Created by You on 15/7/17.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGTableParam.h"
#import "KGReFreshViewDelegate.h"

@interface ReFreshTableViewController : UITableViewController


//
@property(strong, nonatomic) id<KGReFreshViewDelegate>    _delegate;

//是否上拉
@property(assign, nonatomic) bool                            isFooter;

//表格数据源
@property(strong, nonatomic) NSMutableArray               *  dataSource;

//当前页
@property (assign, nonatomic) NSInteger                      page;

//页大小
@property (assign, nonatomic) NSInteger                      pageSize;

//表格参数
@property (strong, nonatomic) KGTableParam                 * tableParam;

//表格的编辑状态
@property (assign, nonatomic) BOOL                             isEditing;


/**
 *  根据表格参数对象构造拉动刷新table
 *
 *  @param parantView 父View
 *
 *  @return 返回可拉动刷新的table
 */
- (id)initRefreshView;


///
- (void)appendToView:(UIView *)parantView;

/**
 *  根据新的数据源重新加载列表
 *
 */
- (void)reloadRefreshTable;


/**
 *  让刷新控件恢复默认的状态
 */
- (void)endRefreshing;


/**
 *  开始刷新表格
 */
- (void)beginRefreshing;

@end
