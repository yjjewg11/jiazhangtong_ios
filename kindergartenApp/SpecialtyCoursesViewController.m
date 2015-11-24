//
//  SpecialtyCoursesViewController.m
//  kindergartenApp
//
//  Created by OxfordLing on 15/10/19.
//  Tel:18080246336
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpecialtyCoursesViewController.h"
#import "AFNetworking.h"
#import "KGHttpService.h"
#import "KGHttpUrl.h"
#import "SpCourseItem.h"
#import "ACMacros.h"
#import "SpCourseVC.h"
#import "SPCourseSchoolVC.h"
#import "KGHUD.h"
#import "SPCourseDomain.h"
#import "MJExtension.h"
#import "SPHotCourseVC.h"
#import "SPCourseDetailVC.h"
#import <CoreLocation/CoreLocation.h>
#import "MJRefresh.h"

#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"

@interface SpecialtyCoursesViewController () <UIScrollViewDelegate,SPHotCourseVCDelegate,AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) AdMoGoView * adView;
@property (strong, nonatomic) UIView * courseView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView * sepView;

@property (strong, nonatomic) NSArray * adPictures;

@property (strong, nonatomic) NSMutableArray * spCourseDomains;

@property (strong, nonatomic) NSMutableArray * hotSpCourses;

@property (strong, nonatomic) NSMutableArray * spCourseDatakeys;

@property (assign, nonatomic) NSInteger reqIndex;

@property (strong, nonatomic) SPHotCourseVC *hotCourseTable;

@property (assign, nonatomic) CGFloat contentHeight;

@property (strong, nonatomic) NSString * map_point;

@property (strong, nonatomic) CLLocationManager * mgr;

@property (assign, nonatomic) NSInteger pageNo;

@end

@implementation SpecialtyCoursesViewController

- (CLLocationManager *)mgr
{
    if (_mgr == nil)
    {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone adType:AdViewTypeCustomSize
                                  adMoGoViewDelegate:self];
    
    self.adView.adWebBrowswerDelegate = self;
    self.adView.frame = CGRectMake(0.0, 0, APPWINDOWWIDTH, 150.0);
    
    [self.scrollView addSubview:self.adView];
    
}

- (SPHotCourseVC *)hotCourseTable
{
    if (_hotCourseTable == nil)
    {
        _hotCourseTable = [[SPHotCourseVC alloc] init];
        _hotCourseTable.delegate = self;
        CGFloat tableX = Number_Zero;
        CGFloat tableY = _sepView.frame.size.height + _courseView.frame.size.height + APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 20 + Cell_Height2 + 10;
        CGFloat tableW = App_Frame_Width;
        CGFloat tableH = Row_Height * self.hotSpCourses.count + Cell_Height3 + Cell_Height2;
        _hotCourseTable.tableFrame = CGRectMake(tableX, tableY, tableW, tableH);
    }
    return _hotCourseTable;
}

- (NSMutableArray *)hotSpCourses
{
    if (_hotSpCourses == nil)
    {
        _hotSpCourses = [NSMutableArray array];
    }
    return _hotSpCourses;
}

- (NSMutableArray *)spCourseDatakeys
{
    if(_spCourseDatakeys == nil)
    {
        _spCourseDatakeys = [NSMutableArray array];
    }
    return _spCourseDatakeys;
}

- (NSArray * )adPictures
{
    if (_adPictures == nil)
    {
        _adPictures = [NSArray array];
    }
    return _adPictures;
}

- (NSMutableArray * )spCourseDomains
{
    if (_spCourseDomains == nil)
    {
        _spCourseDomains = [NSMutableArray array];
    }
    return _spCourseDomains;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"特长课程";
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT);
    _scrollView.delegate = self;
    
    _courseView = [[UIView alloc] init];
    _courseView.frame = CGRectMake(0, 150, 1, 1);
    
    _sepView = [[UIView alloc] init];
    _sepView.frame = CGRectMake(0, 1, APPWINDOWWIDTH, 20);
    _sepView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    

    [self.view addSubview:_scrollView];
    [self loadSPCourse];
    [self getLocationData];
    
    for (UIView *v in _scrollView.subviews)
    {
        v.hidden = YES;
    }
}

#pragma mark - 加载特长课程分类
- (void)loadSPCourse
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseType:^(NSArray *spCourseTypeArr)
    {
        self.spCourseDomains = [NSMutableArray arrayWithArray:spCourseTypeArr];
        
        SPCourseTypeDomain * totalDomain = [[SPCourseTypeDomain alloc] init];
        totalDomain.datavalue = @"查看全部";
        totalDomain.datakey = -1;
        
        [self.spCourseDomains addObject:totalDomain];
        
        [self setUpSPCourses];
        
        [self responseHandler];
        
        [self loadHotCourse];  //加载热门课程
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 加载热门课程
- (void)loadHotCourse
{
    if (self.map_point == nil)
    {
        self.map_point = @"";
    }
    
    [[KGHttpService sharedService] getSPHotCourse:self.map_point pageNo:@"" success:^(SPDataListVO *hotCourseList)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        NSMutableArray * marr = [NSMutableArray array];
        
        for (NSDictionary *d in hotCourseList.data)
        {
            SPCourseDomain * domain = [SPCourseDomain objectWithKeyValues:d];
            
            [marr addObject:domain];
        }
        
        self.hotSpCourses = marr;
        
        [self setUpSPCoursesTable];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.contentHeight = CGRectGetMaxY(self.hotCourseTable.tableView.frame);
            
            _scrollView.contentSize = CGSizeMake(0, self.contentHeight);
        });
        
        self.hotCourseTable.hotSpCourses = marr;
        self.hotCourseTable.mappoint = self.map_point;
        
        [self responseHandlerOfHotCourse];
        
        [self.hotCourseTable.tableView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

//请求之后的处理 需要判断是否还需要再次请求
- (void)responseHandler
{
    if(self.spCourseDomains.count == 0)
    {
        [self loadSPCourse];
    }
}

- (void)responseHandlerOfHotCourse
{
    self.reqIndex++;
    if(self.hotSpCourses.count == 0)
    {
        [self loadHotCourse];
    }
    else
    {
        for (UIView *v in _scrollView.subviews)
        {
            v.hidden = NO;
        }
        _courseView.hidden = NO;
        self.reqIndex = Number_Zero;
    }
}

#pragma mark - 根据特长课程创建图标显示
- (void)setUpSPCourses
{
    int totalloc = 5;
    CGFloat spcoursew = 53;
    CGFloat spcourseh = 71;
    CGFloat margin = (App_Frame_Width - totalloc * spcoursew) / (totalloc + 1);
    CGFloat lastH = 0;
    
    for (NSInteger i = 0; i < self.spCourseDomains.count - 1; i++)
    {
        NSInteger row = (NSInteger)(i / totalloc);  //行号
        NSInteger loc = i % totalloc;               //列号
        
        SpCourseItem * item = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseItem" owner:nil options:nil] firstObject];
        
        SPCourseTypeDomain * domain = self.spCourseDomains[i];
        [item setDatas:domain];
        
        [self.spCourseDatakeys addObject:@(domain.datakey)];
        
        item.courseBtn.tag = i;
        [item.courseBtn addTarget:self action:@selector(courseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat itemX = margin + (margin + spcoursew) * loc;
        CGFloat itemY =  (margin + spcourseh) * row;
        CGFloat itemH = item.frame.size.height;
        CGFloat itemW = item.frame.size.width;
        
        item.frame = CGRectMake(itemX, itemY, itemW, itemH);
        lastH = CGRectGetMaxY(item.frame);
        [_courseView addSubview:item];
    }
    [self.spCourseDatakeys addObject:@""];
    
    [_courseView setSize:CGSizeMake(APPWINDOWWIDTH, Number_Ten + lastH)];
    _courseView.hidden = YES;
    
    [_sepView setOrigin:CGPointMake(0, CGRectGetMaxY(_courseView.frame))];
    _sepView.hidden = YES;
    
    [_scrollView addSubview:_sepView];
    [_scrollView addSubview:_courseView];
}

#pragma mark - 选择课程按钮点击
- (void)courseBtnClick:(UIButton * )btn
{
    SPCourseTypeDomain * domain = self.spCourseDomains[btn.tag];
    
    SPCourseSchoolVC * courseSchoolVC = [[SPCourseSchoolVC alloc] init];
    
    NSMutableArray *marr = [NSMutableArray array];
    NSInteger clickedIndex = 0;
    for (NSInteger i=0;i<self.spCourseDomains.count;i++)
    {
        SPCourseTypeDomain *d = self.spCourseDomains[i];
        if ([d.datavalue isEqualToString:domain.datavalue])
        {
            clickedIndex = i;
        }
        [marr addObject:d.datavalue];
    }
    
    [marr exchangeObjectAtIndex:0 withObjectAtIndex:clickedIndex];
    [self.spCourseDatakeys exchangeObjectAtIndex:0 withObjectAtIndex:clickedIndex];

    courseSchoolVC.courseNameList = marr;
    courseSchoolVC.firstJoinSelType = domain.datavalue;
    courseSchoolVC.firstJoinSelDatakey = domain.datakey;
    courseSchoolVC.courseDatakeys = self.spCourseDatakeys;
    
    [self.navigationController pushViewController:courseSchoolVC animated:YES];
}

- (void)setUpSPCoursesTable
{
    [_scrollView addSubview:self.hotCourseTable.tableView];
}

- (void)spHotCourseVCSearchAllCourse:(SPHotCourseVC *)hotCourse
{
    SPCourseSchoolVC * courseSchoolVC = [[SPCourseSchoolVC alloc] init];
    
    NSMutableArray *marr = [NSMutableArray array];

    for (NSInteger i=0;i<self.spCourseDomains.count;i++)
    {
        SPCourseTypeDomain *d = self.spCourseDomains[i];

        [marr addObject:d.datavalue];
    }
    
    [marr exchangeObjectAtIndex:0 withObjectAtIndex:self.spCourseDomains.count - 1];
    [self.spCourseDatakeys exchangeObjectAtIndex:0 withObjectAtIndex:self.spCourseDomains.count - 1];
    
    courseSchoolVC.courseNameList = marr;
    courseSchoolVC.firstJoinSelType = @"查看全部";
    courseSchoolVC.firstJoinSelDatakey = -1;
    courseSchoolVC.courseDatakeys = self.spCourseDatakeys;
    
    [self.navigationController pushViewController:courseSchoolVC animated:YES];
}

- (void)pushToDetailVC:(SPHotCourseVC *)hotCourseVC dataSourceType:(HotDataSourseType)type selIndexPath:(NSIndexPath *)indexPath
{
    SPCourseDetailVC * detailVC = [[SPCourseDetailVC alloc] init];
    
    SPCourseDomain * domain = self.hotSpCourses[indexPath.row];
    
    detailVC.uuid = domain.uuid;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 芒果广告
#pragma mark - 芒果广告相关
- (CGSize)adMoGoCustomSize
{
    return CGSizeMake(320, 150);
}

#pragma mark AdMoGoDelegate delegate
/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingModalView{
    return self;
}
/**
 * 广告开始请求回调
 */
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告开始请求回调");
}
/**
 * 广告接收成功回调
 */
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告接收成功回调");
}
/**
 * 广告接收失败回调
 */
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error{
    NSLog(@"广告接收失败回调");
}
/**
 * 点击广告回调
 */
- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView{
    NSLog(@"点击广告回调");
}
/**
 *You can get notified when the user delete the ad
 广告关闭回调
 */
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告关闭回调");
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
    
    self.map_point = [NSString stringWithFormat:@"%lf,%lf",loc.coordinate.longitude,loc.coordinate.latitude];
    
    //请求数据，刷新表格
    [self loadHotCourse];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f -- %f",scrollView.contentSize.height,scrollView.contentOffset.y);
}

@end
