//
//  YouHuiVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "YouHuiVC.h"
#import "KGHUD.h"
#import "KGHttpService.h"
#import "YouHuiTableVC.h"
#import "YouHuiDomain.h"
#import "MJExtension.h"
#import "YouHuiDetailVC.h"
#import "MJRefresh.h"
#import <CoreLocation/CoreLocation.h>

@interface YouHuiVC () <CLLocationManagerDelegate,YouHuiTableVCDelegate>
{
    UIView * _warningView;
}

@property (strong, nonatomic) YouHuiTableVC * tableVC;

@property (strong, nonatomic) CLLocationManager * mgr;

@property (strong, nonatomic) NSString * mappoint;

@property (assign, nonatomic) NSInteger pageNo;

@end

@implementation YouHuiVC

- (CLLocationManager *)mgr
{
    if (_mgr == nil)
    {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

- (YouHuiTableVC *)tableVC
{
    if (_tableVC == nil)
    {
        _tableVC = [[YouHuiTableVC alloc] init];
        _tableVC.delegate = self;
        _tableVC.tableRect = CGRectMake(0, APPSTATUSBARHEIGHT + APPTABBARHEIGHT, APPWINDOWWIDTH, APPWINDOWHEIGHT - (APPSTATUSBARHEIGHT + APPTABBARHEIGHT));
    }
    return _tableVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"优惠活动";
    
    self.pageNo = 2;
    
    //创建tableview
    [self.view addSubview:self.tableVC.tableView];
    
    //集成刷新控件
    [self setupRefresh];
    
    //获取当前经纬度
    [self getLocationData];
    
    //请求数据，刷新表格
    [self getYouHuiData];
    
}

#pragma mark - 请求优惠活动数据
- (void)getYouHuiData
{
    [[KGHUD sharedHud] show:self.view];
    
    if (self.mappoint == nil)
    {
        self.mappoint = @"";
    }
    
    [[KGHttpService sharedService] getYouHuiList:self.mappoint pageNo:1 success:^(YouHuiDataListVO *teacherDomain)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        NSMutableArray * marr = [NSMutableArray array];
        
        for (NSDictionary * dict in teacherDomain.data)
        {
            YouHuiDomain * domain = [YouHuiDomain objectWithKeyValues:dict];
            
            [marr addObject:domain];
        }
        
        if (marr == nil  ||  marr.count == 0)
        {
            _warningView = [[[NSBundle mainBundle] loadNibNamed:@"PromptView" owner:nil options:nil] firstObject];
            
            [_warningView setOrigin:CGPointMake(0,APPTABBARHEIGHT + APPSTATUSBARHEIGHT + 20)];
            
            [self.view addSubview:_warningView];
            
            return;
        }
        else
        {
            self.tableVC.dataArr = marr;  //设置数据
            
            [self.tableVC.tableView reloadData];
        }
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

- (void)getLocationData
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        [self.mgr requestWhenInUseAuthorization];
    }
    
    self.mgr.delegate = self;
    
    self.mgr.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.mgr.distanceFilter = 5.0;
    
    [self.mgr startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = [locations firstObject];

    self.mappoint = [NSString stringWithFormat:@"%lf,%lf",loc.coordinate.longitude,loc.coordinate.latitude];
    
    //请求数据，刷新表格
    [self getYouHuiData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark - 跳转代理
- (void)pushToDetailVC:(YouHuiTableVC *)tableVC data:(NSString *)uuid
{
    YouHuiDetailVC * detailVC = [[YouHuiDetailVC alloc] init];
    
    detailVC.uuid = uuid;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 上拉刷新，下拉加载数据
- (void)setupRefresh
{
    // 1.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableVC.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableVC.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableVC.tableView.footerReleaseToRefreshText = @"松开立即加载更多";
    self.tableVC.tableView.footerRefreshingText = @"正在加载中...";
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    [[KGHttpService sharedService] getYouHuiList:self.mappoint pageNo:1 success:^(YouHuiDataListVO *teacherDomain)
    {
        
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];

}

@end
