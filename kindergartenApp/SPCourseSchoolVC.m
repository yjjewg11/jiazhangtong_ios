//
//  SPCourseSchoolVC.m
//  kindergartenApp
//
//  Created by Mac on 15/10/23.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPCourseSchoolVC.h"
#import "MXPullDownMenu.h"
#import "SpCourseVC.h"
#import "ACMacros.h"
#import "KGHttpService.h"
#import "SPDataListVO.h"
#import "SPCourseDomain.h"
#import "KGHUD.h"
#import "SpCourseCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "SPSchoolDomain.h"
#import "SPCourseDetailVC.h"
#import "SPSchoolDetailVC.h"
#import <CoreLocation/CoreLocation.h>

@interface SPCourseSchoolVC () <MXPullDownMenuDelegate,SpCourseVCDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *_dataOfCourseType;
    NSArray *_dataOfSort;
    NSArray *_lookAllInSchoolList;
    
    NSInteger _currentDataOfCourseTypeIndex;
    NSInteger _currentDataOfSortIndex;
    
}

@property (strong, nonatomic) UISegmentedControl * segCtrl;
@property (strong, nonatomic) SpCourseVC * tableVC;
@property (strong, nonatomic) MXPullDownMenu *dropMenu;



//请求参数:控制再次请求
@property (strong, nonatomic) NSString * courseSort;
@property (strong, nonatomic) NSString * schoolSort;
@property (strong, nonatomic) NSString * type;

@property (strong, nonatomic) CLLocationManager * mgr;
@property (strong, nonatomic) NSString * mappoint;
@end

@implementation SPCourseSchoolVC

- (CLLocationManager *)mgr
{
    if (_mgr == nil)
    {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

- (SPDataListVO *)courseList
{
    if (_courseList == nil)
    {
        _courseList = [[SPDataListVO alloc] init];
    }
    return _courseList;
}

- (SpCourseVC * )tableVC
{
    if (_tableVC == nil)
    {
        _tableVC = [[SpCourseVC alloc] init];
        CGFloat tableX = Number_Zero;
        CGFloat tableY = CGRectGetMaxY(self.dropMenu.frame);
        CGFloat tableW = self.view.width;
        CGFloat tableH = self.view.frame.size.height - self.dropMenu.frame.size.height - APPSTATUSBARHEIGHT - APPTABBARHEIGHT;
        
        _tableVC.showHeaderView = NO;
        _tableVC.tableFrame = CGRectMake(tableX, tableY, tableW, tableH);
        _tableVC.tableView.scrollEnabled = YES;
        _tableVC.tableView.showsVerticalScrollIndicator = NO;
        [_tableVC.tableView setHeaderHidden:YES];
        [self.view addSubview:self.tableVC.tableView];
    }
    return _tableVC;
}

- (UISegmentedControl *)segCtrl
{
    if (_segCtrl == nil)
    {
        NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"课程 ",@"学校",nil];
        _segCtrl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    }
    return _segCtrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpSegmentedBtn];
    //下拉菜单
    [self setUpListBtns];
    //集成刷新控件
    [self setupRefresh];
    self.tableVC.delegate = self;
    
    //载入课程数据
    if (self.firstJoinSelDatakey == -1)
    {
        self.type = @"";
    }
    else
    {
        self.type = [NSString stringWithFormat:@"%ld",(long)self.firstJoinSelDatakey];
    }
    
    self.courseSort = [self getSortValueWithName:_dataOfSort[0]];
    [self getCourseDataWithCourseType:self.type sort:self.courseSort];
    
    //载入培训机构数据
    self.schoolSort = [self getSortValueWithName:_dataOfSort[_currentDataOfSortIndex]];
    
    [self getSchoolDataWithMapPoint:self.mappoint sort:self.schoolSort];
    
    [self getLocationData];
}

- (NSString *)getSortValueWithName:(NSString *)sortName
{
    if([sortName isEqualToString:@"智能排序"])
    {
        return @"intelligent";
    }
    else if ([sortName isEqualToString:@"评价最高"])
    {
        return @"appraise";
    }
    else if ([sortName isEqualToString:@"距离最近"])
    {
        return @"distance";
    }
    else
    {
        return @"";
    }
}

#pragma mark - 请求课程列表数据
- (void)getCourseDataWithCourseType:(NSString *)courseType sort:(NSString *)sort
{
    [[KGHUD sharedHud] show:self.view];
    
    if (self.mappoint == nil)
    {
        self.mappoint = @"";
    }
    
    [[KGHttpService sharedService] getSPCourseList:@"" map_point:self.mappoint type:courseType sort:sort teacheruuid:@"" success:^(SPDataListVO *spCourseList)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        self.courseList = spCourseList;
        [self setUpCourseTable];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
    
}

#pragma mark - 请求特长班列表数据
- (void)getSchoolDataWithMapPoint:(NSString *)point sort:(NSString *)sort
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPSchoolList:point sort:sort success:^(SPDataListVO *spSchoolList)
    {
        [[KGHUD sharedHud] hide:self.view];
         
        self.schoolList = spSchoolList;
        [self setUpSchoolTable];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

//请求之后的处理 需要判断是否还需要再次请求
- (void)responseHandler {
    if(self.courseList == nil)
    {
        [self getCourseDataWithCourseType:self.type sort:self.courseSort];
    }
    else
    {
        for (UIView *v in self.view.subviews)
        {
            v.hidden = NO;
        }
    }
}

#pragma mark - 设置表数据源

/**
 *  重新设置table数据源 - 班级列表
 */
- (void)setUpCourseTable
{
    NSArray * courseListArr = self.courseList.data;
    NSMutableArray *marr = [NSMutableArray array];
    
    for (NSDictionary *dict in courseListArr)
    {
        SPCourseDomain * domain = [SPCourseDomain objectWithKeyValues:dict];
        [marr addObject:domain];
    }
    
    self.tableVC.courseListArr = marr;

   [self.tableVC.tableView reloadData];
}

/**
 *  重新设置table数据源 - 学校列表
 */
- (void)setUpSchoolTable
{
    NSArray * schoolListArr = self.schoolList.data;
    NSMutableArray *marr = [NSMutableArray array];
    
    for (NSDictionary *dict in schoolListArr)
    {
        SPSchoolDomain * domain = [SPSchoolDomain objectWithKeyValues:dict];
        [marr addObject:domain];
    }
    
    self.tableVC.schoolListArr = marr;

   [self.tableVC.tableView reloadData];
}

#pragma mark - 创建顶部选择按钮
- (void)setUpSegmentedBtn
{
    self.segCtrl.selectedSegmentIndex = 0;
    self.segCtrl.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.segCtrl;
    [self.segCtrl addTarget:self action:@selector(segMentAction:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - 顶部选择按钮事件
- (void)segMentAction:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    
    switch (index)
    {
        case 0:
        {
            self.tableVC.dataSourceType = 0;
            [self.tableVC.tableView reloadData];
            break;
        }
        case 1:
        {
            self.tableVC.dataSourceType = 1;
            [self.tableVC.tableView reloadData];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 创建顶部下拉菜单
- (void)setUpListBtns
{
    NSArray *testArray;
    _dataOfCourseType = self.courseNameList;
    _dataOfSort = @[@"智能排序",@"评价最高",@"距离最近"];
    testArray = @[_dataOfCourseType, _dataOfSort];
    self.dropMenu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor blackColor]];
    self.dropMenu.delegate = self;
    self.dropMenu.frame = CGRectMake(0,APPSTATUSBARHEIGHT+APPTABBARHEIGHT, APPWINDOWWIDTH, self.dropMenu.frame.size.height);
    [self.view addSubview:self.dropMenu];
}

// 实现代理.
#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    if (self.tableVC.dataSourceType == 0) //在课程列表里面
    {
        if (column == 0)  //根据课程类型
        {
            _currentDataOfCourseTypeIndex = row;
            self.type = self.courseDatakeys[row];
            self.courseSort = _dataOfSort[_currentDataOfSortIndex];
            [self getCourseDataWithCourseType:self.type sort:[self getSortValueWithName:self.courseSort]];
        }
        if (column == 1)  //根据排序方式
        {
            _currentDataOfSortIndex = row;
            self.type = self.courseDatakeys[_currentDataOfCourseTypeIndex];
            self.courseSort = [self getSortValueWithName:_dataOfSort[row]];
            [self getCourseDataWithCourseType:self.type sort:self.courseSort];
        }
    }
    else if (self.tableVC.dataSourceType == 1) //在学校列表里面
    {
        if (column == 0)  //根据课程类型
        {
            _currentDataOfCourseTypeIndex = row;
            self.schoolSort = [self getSortValueWithName:_dataOfSort[_currentDataOfSortIndex]];
            [self getSchoolDataWithMapPoint:@"" sort:self.schoolSort];
        }
        if (column == 1)  //根据排序方式
        {
            _currentDataOfSortIndex = row;
            self.schoolSort = [self getSortValueWithName:_dataOfSort[row]];
            [self getSchoolDataWithMapPoint:@"" sort:self.schoolSort];
        }
    }
}

#pragma mark - 上拉刷新，下拉加载数据
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableVC.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //自动刷新(一进入程序就下拉刷新)
//    [self.tableVC.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableVC.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableVC.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableVC.tableView.headerReleaseToRefreshText = @"松开立即刷新";
    self.tableVC.tableView.headerRefreshingText = @"正在刷新中...";
    
    self.tableVC.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableVC.tableView.footerReleaseToRefreshText = @"松开立即加载更多";
    self.tableVC.tableView.footerRefreshingText = @"正在加载中...";
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
       [self.tableVC.tableView reloadData];
       
       // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
       [self.tableVC.tableView headerEndRefreshing];
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
       [self.tableVC.tableView reloadData];
       
       // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
       [self.tableVC.tableView footerEndRefreshing];
    });
}

#pragma mark - 代理方法 - 导航控制器跳转
- (void)pushToDetailVC:(SpCourseVC *)spCourseVC dataSourceType:(DataSourseType)type selIndexPath:(NSIndexPath *)indexPath
{
    if (type == 0)
    {
        SPCourseDetailVC * detailVC = [[SPCourseDetailVC alloc] init];
        
        NSDictionary *dict = self.courseList.data[indexPath.row];
        
        detailVC.uuid = [dict objectForKey:@"uuid"];
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (type == 1)
    {
        SPSchoolDetailVC * detailVC = [[SPSchoolDetailVC alloc] init];
        
        NSDictionary * dict = self.schoolList.data[indexPath.row];
        
        detailVC.groupuuid = [dict objectForKey:@"uuid"];
        
//        detailVC.schoolDomain = [SPSchoolDomain objectWithKeyValues:self.schoolList.data[indexPath.row]];
        
        [self.navigationController pushViewController:detailVC animated:YES];
    
    }
}

#pragma mark - 获取位置
- (void)getLocationData
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        [self.mgr requestWhenInUseAuthorization];
    }
    
    self.mgr.delegate = self;
    
    self.mgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.mgr.distanceFilter = 5.0;
    
    [self.mgr startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = [locations firstObject];
    
    self.mappoint = [NSString stringWithFormat:@"%lf,%lf",loc.coordinate.longitude,loc.coordinate.latitude];
    
    //请求数据，刷新表格
    self.schoolSort = [self getSortValueWithName:_dataOfSort[_currentDataOfSortIndex]];
    [self getSchoolDataWithMapPoint:self.mappoint sort:self.schoolSort];
    
    self.courseSort = _dataOfSort[_currentDataOfSortIndex];
    self.type = self.courseDatakeys[_currentDataOfCourseTypeIndex];
    [self getCourseDataWithCourseType:self.type sort:[self getSortValueWithName:self.courseSort]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}


@end
