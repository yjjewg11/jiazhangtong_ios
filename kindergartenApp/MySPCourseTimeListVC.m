//
//  MySPCourseTimeListVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/18.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseTimeListVC.h"
#import "KGHUD.h"
#import "MySPAllCouseListDomain.h"
#import "MJExtension.h"
#import "KGHttpService.h"
#import "MySPAllCourseListCell.h"
#import "NSDate+Utils.h"
#import "MySPAllListHeaderView.h"
#import "MySPCourseListCourseDetailCell.h"
#import "MJRefresh.h"
#import "KGHttpService.h"

@interface MySPCourseTimeListVC () <UITableViewDataSource,UITableViewDelegate,MySPAllListHeaderViewDelegate>

@property (assign, nonatomic) NSInteger blueCell;

@property (assign, nonatomic) NSInteger oriCell;

@property (assign, nonatomic) BOOL flag;

@property (strong, nonatomic) NSMutableDictionary * tableDict;

@property (strong, nonatomic) NSMutableArray * views;

@property (assign, nonatomic) NSInteger pageNo;

@property (assign, nonatomic) NSInteger futureCount;

@end

@implementation MySPCourseTimeListVC

- (NSMutableArray *)views
{
    if (_views == nil)
    {
        _views = [NSMutableArray array];
    }
    return _views;
}

- (NSMutableDictionary *)tableDict
{
    if (_tableDict == nil)
    {
        _tableDict = [NSMutableDictionary dictionary];
    }
    
    return _tableDict;
}

- (NSMutableArray *)listDatas
{
    if (_listDatas == nil)
    {
        _listDatas = [NSMutableArray array];
    }
    
    return _listDatas;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageNo = 2;
    
    self.futureCount = 0;
    
    [self setupRefresh];
    
    self.tableView.frame = self.tableFrame;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;

    [self getColorCellIndex];
    
    [self setUpViews];
}

- (void)setUpViews
{
    for (NSInteger i=0; i<self.listDatas.count; i++)
    {
        MySPAllCouseListDomain * d = self.listDatas[i];
        
        MySPAllListHeaderView * view = [[[NSBundle mainBundle] loadNibNamed:@"MySPAllListHeaderView" owner:nil options:nil] firstObject];
        
        view.delegate = self;
        
        view.btn.tag = i;
        
        [self.tableDict setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)view.btn.tag]];
        
        view.frame = CGRectMake(0, 0, APPWINDOWWIDTH, 44);
        
        [view setData:d row:i];
        
        if (self.futureCount != 0)
        {
            if (i == self.oriCell)
            {
                view.courseNameLbl.textColor = [UIColor whiteColor];
                view.courseCountLbl.textColor = [UIColor whiteColor];
                view.timeLbl.textColor = [UIColor whiteColor];
                view.backgroundColor = [UIColor orangeColor];
            }
            else if (i >= self.blueCell)
            {
                view.courseNameLbl.textColor = [UIColor blueColor];
                view.courseCountLbl.textColor = [UIColor blueColor];
                view.timeLbl.textColor = [UIColor blueColor];
            }
        }
        else
        {
            view.courseNameLbl.textColor = [UIColor blackColor];
            view.courseCountLbl.textColor = [UIColor blackColor];
            view.timeLbl.textColor = [UIColor blackColor];
        }

        [self.views addObject:view];
    }
}

#pragma mark - 获取单元格颜色
- (void)getColorCellIndex
{
    for (NSInteger i=0;i<self.listDatas.count;i++)
    {
        MySPAllCouseListDomain * d = self.listDatas[i];
        
        NSDate * inputDate = [NSDate dateFromString:d.plandate withFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        if ([inputDate daysBetweenCurrentDateAndDate] > 0) //未来的
        {
            self.futureCount++;
            
            self.oriCell = i;
            self.blueCell = i+1;
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.views[section];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 121;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * num = [self.tableDict objectForKey:[NSString stringWithFormat:@"%ld",(long)section]];
    
    return [num integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resid = @"detailcoursecell";
    
    MySPCourseListCourseDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:resid];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MySPCourseListCourseDetailCell" owner:nil options:nil] firstObject];
    }
    
    [cell setData:self.listDatas[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - 按钮点击代理
- (void)viewBtnClick:(MySPAllListHeaderView *)view
{
    NSString * key = [NSString stringWithFormat:@"%ld",(long)view.btn.tag];
    
    NSString * currentState = [self.tableDict objectForKey:key];
    
    if ([currentState isEqualToString:@"0"])
    {
        [self.tableDict setValue:@"1" forKey:key];
        
        //刷新那组单元格
        NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:view.btn.tag];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    }
    
    else if ([currentState isEqualToString:@"1"])
    {
        [self.tableDict setValue:@"0" forKey:key];
        
        //刷新那组单元格
        NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:view.btn.tag];
        
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    }
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
    [[KGHttpService sharedService] getListAll:self.classuuid pageNo:[NSString stringWithFormat:@"%ld",(long)self.pageNo] success:^(MySPAllCourseListVO *courseListVO)
     {
         NSArray * tempArr = [NSArray arrayWithArray:[MySPAllCouseListDomain objectArrayWithKeyValuesArray:courseListVO.data]];
         
         if (tempArr == nil || tempArr.count == 0)
         {
             self.tableView.footerRefreshingText = @"没有更多了...";
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
             {
                 [self.tableView footerEndRefreshing];
             });
         }
         else
         {
             self.pageNo ++;
             
             for (MySPAllCouseListDomain * d in tempArr)
             {
                 [self.listDatas addObject:d];
             }
             
             [self.tableView footerEndRefreshing];
             
             [self getColorCellIndex];
             
             [self.views removeAllObjects];
             
             [self setUpViews];
             
             [self.tableView reloadData];

         }
     }
     faild:^(NSString *errorMsg)
     {
         [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
     }];
}


@end
