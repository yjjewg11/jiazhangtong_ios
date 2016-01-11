//
//  ShowRouteVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/8.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "ShowRouteVC.h"
#import "RouteCell.h"
#import "RouteDomain.h"
#import "UIImage+Rotate.h"
#import "RouteDetailVC.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface ShowRouteVC () <UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UILabel *destinationLbl;
    __weak IBOutlet UIView *btnView;
    
    UITableView * _tableView;
    NSMutableArray * _dataSource;
    BMKRouteSearch* _routesearch;
    BMKLocationService* _locService;
    CLLocation * _myLocation;
    BMKPlanNode * start;
    BMKPlanNode * end;
    
    __weak IBOutlet UIImageView *busImg;
    
    __weak IBOutlet UIImageView *taxiImg;
    
    __weak IBOutlet UIImageView *walkImg;
}

@property (assign, nonatomic) BOOL noData;

@end

@implementation ShowRouteVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    destinationLbl.text = self.destinationName;
    
    //启用查看路径
    _routesearch = [[BMKRouteSearch alloc]init];
    
    //启用定位
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    
    self.title = @"查看路线";
    
    [self calPostion];
    [self calBusRoute];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 140)];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _dataSource = [NSMutableArray array];
    
    [self.view addSubview:_tableView];
}

- (IBAction)carBtn:(id)sender
{
    busImg.image = [UIImage imageNamed:@"bus"];
    taxiImg.image = [UIImage imageNamed:@"taxi_red"];
    walkImg.image = [UIImage imageNamed:@"walk"];
    
    _tableView.hidden = YES;
    [self calPostion];
    
    BMKDrivingRoutePlanOption * drivingRoutePlanOption = [[BMKDrivingRoutePlanOption alloc] init];
    drivingRoutePlanOption.from = start;
    drivingRoutePlanOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRoutePlanOption];
    
    if(flag)
    {
        NSLog(@"开车检索发送成功");
    }else
    {
        NSLog(@"开车检索发送失败");
    }
}

- (IBAction)walkBtn:(id)sender
{
    busImg.image = [UIImage imageNamed:@"bus"];
    taxiImg.image = [UIImage imageNamed:@"taxi"];
    walkImg.image = [UIImage imageNamed:@"walk_red"];
    
    _tableView.hidden = YES;
    [self calPostion];
    
    //开始算路
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"步行检索发送成功");
    }else
    {
        NSLog(@"步行检索发送失败");
    }
}

- (IBAction)busBtn:(id)sender
{
    busImg.image = [UIImage imageNamed:@"bus_red"];
    taxiImg.image = [UIImage imageNamed:@"taxi"];
    walkImg.image = [UIImage imageNamed:@"walk"];
    
    _tableView.hidden = YES;
    [self calPostion];
    [self calBusRoute];
}

- (void)calBusRoute
{
    //开始算路
    BMKTransitRoutePlanOption *transitRoutePlanOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRoutePlanOption.from = start;
    transitRoutePlanOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRoutePlanOption];
    
    if(flag)
    {
        NSLog(@"公交检索发送成功");
    }else
    {
        NSLog(@"公交检索发送失败");
    }
}

- (BOOL)calPostion
{
    if (_myLocation == nil)
    {
        return NO;
    }
    
    //设置我的位置：
    if (start == nil)
    {
        start = [[BMKPlanNode alloc]init];
    }
    start.pt = CLLocationCoordinate2DMake(_myLocation.coordinate.latitude, _myLocation.coordinate.longitude);
    
    //设置目的的位置
    if (end == nil)
    {
        end = [[BMKPlanNode alloc]init];
    }
    end.pt = self.destinationPosition;
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    _locService.delegate = self;
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    _locService.delegate = nil;
    _routesearch.delegate = nil; // 不用时，置nil
}

#pragma mark - tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * routeID = @"routeID";
    
    RouteCell * cell = [tableView dequeueReusableCellWithIdentifier:routeID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RouteCell" owner:nil options:nil] firstObject];
    }
    
    //设置数据
    RouteDomain * domain = _dataSource[indexPath.row];
    domain.count = indexPath.row + 1;
    
    [cell setData:domain];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - 步行
- (void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"错误标号:%d",error);
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        //清空数据源
        [_dataSource removeAllObjects];
        _dataSource = nil;
        _dataSource = [NSMutableArray array];
        
        NSLog(@"查到了%ld条步行线路",(long)result.routes.count);
        
        for (NSInteger i = 0; i<result.routes.count; i++)
        {
            BMKWalkingRouteLine * plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:i];
            
            NSLog(@" bb %@",plan.starting.title);
            
            RouteDomain * domain = [[RouteDomain alloc] init];
            
            domain.routeTime = [NSString stringWithFormat:@"%ld分钟",(long)plan.duration.minutes];
            domain.routeFar = [NSString stringWithFormat:@"%ld米",(long)plan.distance];
            
            //这里反地理编码 获取到 起点街道名称 和 终点街道名称
            NSArray * arr =  plan.steps;
            NSMutableArray * instructionArr = [NSMutableArray array];
            
            for (NSInteger j = 0; j<arr.count; j++)
            {
                BMKWalkingStep * step = arr[j];
                [instructionArr addObject:step.instruction];
            }
    
            domain.instructionArr = [NSMutableArray arrayWithArray:instructionArr];
            domain.type = 2;
            domain.plan = plan;
    
            [_dataSource addObject:domain];
        }
        
        [_tableView reloadData];
        _tableView.hidden = NO;
    }
}

#pragma mark - 开车
- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"错误标号:%d",error);
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        //清空数据源
        [_dataSource removeAllObjects];
        _dataSource = nil;
        _dataSource = [NSMutableArray array];
        
        NSLog(@"查到了%ld条开车线路",(long)result.routes.count);
        
        for (NSInteger i = 0; i<result.routes.count; i++)
        {
            BMKDrivingRouteLine * plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:i];
            
            RouteDomain * domain = [[RouteDomain alloc] init];
            
            domain.routeTime = [NSString stringWithFormat:@"%ld分钟",(long)plan.duration.minutes];
            domain.routeFar = [NSString stringWithFormat:@"%ld米",(long)plan.distance];
            
            //这里反地理编码 获取到 起点街道名称 和 终点街道名称
            NSArray * arr =  plan.steps;
            NSMutableArray * instructionArr = [NSMutableArray array];
            
            for (NSInteger j = 0; j<arr.count; j++)
            {
                BMKDrivingStep * step = arr[j];
                [instructionArr addObject:step.instruction];
            }
            
            domain.instructionArr = [NSMutableArray arrayWithArray:instructionArr];
            domain.type = 1;
            domain.plan = plan;
            
            [_dataSource addObject:domain];
        }
        
        [_tableView reloadData];
        _tableView.hidden = NO;
    }
}

#pragma mark - 公交
- (void)onGetTransitRouteResult:(BMKRouteSearch *)searcher result:(BMKTransitRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"错误标号:%d",error);
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        self.noData = NO;
        
        //清空数据源
        [_dataSource removeAllObjects];
        _dataSource = nil;
        _dataSource = [NSMutableArray array];
        
        NSLog(@"查到了%ld条公交线路",(long)result.routes.count);
        
        for (NSInteger i = 0; i<result.routes.count; i++)
        {
            BMKTransitRouteLine * plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:i];
            
            RouteDomain * domain = [[RouteDomain alloc] init];
            
            domain.routeTime = [NSString stringWithFormat:@"%ld分钟",(long)plan.duration.minutes];
            domain.routeFar = [NSString stringWithFormat:@"%ld米",(long)plan.distance];
            
            //这里反地理编码 获取到 起点街道名称 和 终点街道名称
            NSArray * arr =  plan.steps;
            NSMutableArray * instructionArr = [NSMutableArray array];
            
            for (NSInteger j = 0; j<arr.count; j++)
            {
                BMKTransitStep * step = arr[j];
                [instructionArr addObject:step.instruction];
            }
            
            domain.instructionArr = [NSMutableArray arrayWithArray:instructionArr];
            domain.type = 0;
            domain.plan = plan;
            
            [_dataSource addObject:domain];
        }
        
        [_tableView reloadData];
        _tableView.hidden = NO;
    }
    
    if (error == BMK_SEARCH_RESULT_NOT_FOUND)
    {
        self.noData = YES;
        
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有查询到公交信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [al show];
    }
}

#pragma mark - 获取我的位置
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    if (userLocation.location != nil)
    {
        _myLocation = userLocation.location;
    }
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location != nil)
    {
        _myLocation = userLocation.location;
    }
}

#pragma mark - 点击线路跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RouteDetailVC * vc = [[RouteDetailVC alloc] init];
    
    vc.domain = _dataSource[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end