//
//  SpCourseHomeVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/25.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseHomeVC.h"
#import "SDRotationLoopProgressView.h"
#import "KGHttpService.h"
#import "SPCourseTypeDomain.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SPCourseDetailVC.h"
#import "NoNetView.h"
#import "SpCourseAndSchoolListVC.h"
#import "SpCourseHomeFuncCell.h"
#import "SpCourseCell.h"

#define FinishReqCount 2

@interface SpCourseHomeVC () <SpCourseHomeFuncCellDelegate,NoNetViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _courseTypes;
    NSMutableArray * _hotCourseData;
//    AdMoGoView * _adView;
    NSInteger _reqSuccessCount;
    NSInteger _reqFailedCount;
    NSInteger _pageNo;
    BOOL _canReqData;
    BOOL _adReqSuccess;
    BOOL _firstJoinSwitch;
    NSString * _mappoint;
    UITableView * _tableView;
}

@end

@implementation SpCourseHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _firstJoinSwitch = YES;
    _canReqData = YES;
    _pageNo = 2;
    
    //读取坐标
     NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
     _mappoint = [defu objectForKey:@"map_point"];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"特长课程";

    //加载课程分类
    [self loadCourseTypesData];
    
    //加载热门课程
    [self loadHotCourseData];
    
    //初始化tableview
    [self initTableView];
    
    //加载ad
//    [self initAD];
}

#pragma mark - 初始化tableview
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setupRefresh];
}
//
//#pragma mark - 创建ad
//- (void)initAD
//{
//    _adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone adType:AdViewTypeCustomSize
//                              adMoGoViewDelegate:self];
//    
//    _adView.adWebBrowswerDelegate = self;
//    
//    _adView.frame = CGRectMake((APPWINDOWWIDTH - 320) / 2, 0, 320, 150);
//}

#pragma mark - 加载课程分类数据
- (void)loadCourseTypesData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getSPCourseType:^(NSArray *spCourseTypeArr)
    {
        _courseTypes = [NSMutableArray arrayWithArray:spCourseTypeArr];
        
        //创建一个 查看全部的分类，方便在下个界面查询它
        SPCourseTypeDomain * totalDomain = [[SPCourseTypeDomain alloc] init];
        totalDomain.datavalue = @"查看全部";
        totalDomain.datakey = -1;
        [_courseTypes addObject:totalDomain];
        _reqSuccessCount++;

        if (_reqSuccessCount == FinishReqCount)
        {
            [self hidenLoadView];
            [self.view addSubview:_tableView];
        }
    }
    faild:^(NSString *errorMsg)
    {
        _reqFailedCount++;
        if (_reqFailedCount == 2)
        {
            [self hidenLoadView];
            [self showNoNetView];
        }
    }];
}

#pragma mark - 加载热门课程数据
- (void)loadHotCourseData
{
    [[KGHttpService sharedService] getSPHotCourse:_mappoint pageNo:@"" success:^(SPDataListVO *hotCourseList)
    {
        _hotCourseData = [NSMutableArray arrayWithArray:[SPCourseDomain objectArrayWithKeyValuesArray:hotCourseList.data]];
        _reqSuccessCount++;
        
        if (_reqSuccessCount == FinishReqCount)
        {
            [self hidenLoadView];
            [self.view addSubview:_tableView];
        }
    }
    faild:^(NSString *errorMsg)
    {
        _reqFailedCount++;
        if (_reqFailedCount == 2)
        {
            [self hidenLoadView];
            [self showNoNetView];
        }
    }];
}

#pragma mark - 没有网络连接重试代理
- (void)tryBtnClicked
{
    [self hidenNoNetView];
    
    _pageNo = 2;
    _reqSuccessCount = 0;
    _reqFailedCount = 0;
    
    //加载课程分类
    [self loadCourseTypesData];
    
    //加载热门课程
    [self loadHotCourseData];
}

#pragma mark - tableview 的数据源 & 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + _hotCourseData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString * funcell = @"fun_cell";
        SpCourseHomeFuncCell * cell = [tableView dequeueReusableCellWithIdentifier:funcell];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseHomeFuncCell" owner:nil options:nil] firstObject];
        }
        cell.delegate = self;
        [cell setData:_courseTypes];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString * coursecell = @"course_cell";
        SpCourseCell * cell = [tableView dequeueReusableCellWithIdentifier:coursecell];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseCell" owner:nil options:nil] firstObject];
        }
        [cell setCourseCellData:_hotCourseData[indexPath.row - 1]];
        return cell;
    }
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return _adView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 210;
    }
    else
    {
        return 103;
    }
}

#pragma mark - 按钮点击跳转
- (void)pushToVC:(UIButton *)btn
{
    SpCourseAndSchoolListVC * vc = [[SpCourseAndSchoolListVC alloc] init];
    
    vc.firstJoinIndex = btn.tag;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 更多按钮点击跳转
- (void)pushToHotCourseVC
{
    SpCourseAndSchoolListVC * vc = [[SpCourseAndSchoolListVC alloc] init];
    
    vc.firstJoinIndex = _courseTypes.count - 1;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选中cell后调转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return;
    }
    
    SpCourseDetailVC * detailVC = [[SpCourseDetailVC alloc] init];
    
    SPCourseDomain * domain = _hotCourseData[indexPath.row - 1];
    
    detailVC.uuid = domain.uuid;
    
    detailVC.map_point = domain.map_point;
    
    detailVC.schoolName = domain.group_name;
    
    detailVC.locationName = domain.address;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 上拉刷新，下拉加载数据
- (void)setupRefresh
{
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing) showActivityView:YES];
    _tableView.footerPullToRefreshText = @"上拉加载更多";
    _tableView.footerReleaseToRefreshText = @"松开立即加载";
    _tableView.footerRefreshingText = @"正在加载中...";
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    [[KGHttpService sharedService] getSPHotCourse:_mappoint pageNo:[NSString stringWithFormat:@"%ld",(long)_pageNo] success:^(SPDataListVO *hotCourseList)
     {
         NSArray * data = [NSMutableArray arrayWithArray:[SPCourseDomain objectArrayWithKeyValuesArray:hotCourseList.data]];
         if (data == nil || data.count == 0)
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
             {
                 _tableView.footerRefreshingText = @"没有更多了...";
                 [_tableView footerEndRefreshing];
             });
         }
         else
         {
             _pageNo++;
             [_hotCourseData addObjectsFromArray:data];
             [_tableView reloadData];
             [_tableView footerEndRefreshing];
         }
     }
     faild:^(NSString *errorMsg)
     {
         [_tableView footerEndRefreshing];
     }];
}


#pragma mark - 芒果广告相关
- (CGSize)adMoGoCustomSize
{
    return CGSizeMake(320, 150);
}
- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}
//- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView
//{}
//- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView
//{}
//- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error
//{}
//- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView
//{}
//- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView
//{}

- (void)dealloc
{
    NSLog(@"delloc -- ");
}

@end
