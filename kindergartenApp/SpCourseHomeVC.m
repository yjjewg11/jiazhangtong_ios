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
#import "SpCourseHomeWFLayout.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SpCourseHomeCourseTypesCell.h"
#import "SpCourseHomeCourseCell.h"
#import "SPCourseDetailVC.h"
#import "NoNetView.h"
#import "SpCourseAndSchoolListVC.h"

#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"

#define FinishReqCount 2

@interface SpCourseHomeVC () <UICollectionViewDataSource,UICollectionViewDelegate,AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate,SpCourseHomeCourseTypesCellDelegate,NoNetViewDelegate>
{
    UIScrollView * _scrollView;
    
    NSMutableArray * _courseTypes;
    
    NSMutableArray * _hotCourseData;
    
    UICollectionView * _collectionView;
    
    AdMoGoView * _adView;
    
    NSInteger _reqSuccessCount;
    
    NSInteger _reqFailedCount;
    
    NSInteger _pageNo;
    
    BOOL _canReqData;
    BOOL _adReqSuccess;
    BOOL _firstJoinSwitch;
    
    NSString * _mappoint;
}

@end

@implementation SpCourseHomeVC

static NSString *const TypeCellID = @"typecellcoll";
static NSString *const CourseCellID = @"coursecellcoll";

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
    
    //初始化scrollview
    [self initScrollView];
    
    //初始化视图
    [self initCollectionView];
    
    //加载广告
    [self initAD];
    
}

- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49)];
    
    _scrollView.bounces = NO;
    
    _scrollView.contentSize = CGSizeMake(0, APPWINDOWHEIGHT - 64 - 49 + 151);
    
    [self.view addSubview:_scrollView];
}

- (void)initAD
{
    _adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone adType:AdViewTypeCustomSize
                              adMoGoViewDelegate:self];
    
    _adView.adWebBrowswerDelegate = self;
    
    _adView.frame = CGRectMake((APPWINDOWWIDTH - 320) / 2, 0, APPWINDOWWIDTH, 150.0);
    
    [_scrollView addSubview:_adView];
}

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
            [_scrollView addSubview:_collectionView];
            _collectionView.scrollEnabled = NO;
            _scrollView.delegate = self;
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
            [_scrollView addSubview:_collectionView];
            _collectionView.scrollEnabled = NO;
            _scrollView.delegate = self;
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
    
    _reqSuccessCount = 0;
    _reqFailedCount = 0;
    
    //加载课程分类
    [self loadCourseTypesData];
    
    //加载热门课程
    [self loadHotCourseData];
    
    //初始化视图
    [self initCollectionView];
}

#pragma mark - collection的数据源 & 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1 + _hotCourseData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        SpCourseHomeCourseTypesCell * typesCell = [collectionView dequeueReusableCellWithReuseIdentifier:TypeCellID forIndexPath:indexPath];
        
        typesCell.delegate = self;
        
        [typesCell setData:_courseTypes];
        
        return typesCell;
    }
    else
    {
        SpCourseHomeCourseCell * courseCell = [collectionView dequeueReusableCellWithReuseIdentifier:CourseCellID forIndexPath:indexPath];
        
        [courseCell setCourseCellData:_hotCourseData[indexPath.row-1]];
        
        return courseCell;
    }
    
    return nil;
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

#pragma mark - 选中item后调转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
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

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    SpCourseHomeWFLayout *layout = [[SpCourseHomeWFLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 150, KGSCREEN.size.width, KGSCREEN.size.height - 64 - 44) collectionViewLayout:layout];
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.bounces = NO;
    
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SpCourseHomeCourseTypesCell" bundle:nil] forCellWithReuseIdentifier:@"typecellcoll"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SpCourseHomeCourseCell" bundle:nil] forCellWithReuseIdentifier:@"coursecellcoll"];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self setupRefresh];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 150 && _collectionView.contentOffset.y == 0)
    {
        [scrollView setContentOffset:CGPointMake(0, 150)];
        
        _scrollView.scrollEnabled = NO;
        
        _collectionView.scrollEnabled = YES;
        
        _scrollView.delegate = nil;
        
        [_collectionView setContentOffset:CGPointMake(0, 1)];
        
        _collectionView.bounces = YES;
        
        return;
    }
    
    if (scrollView.contentOffset.y <= 0)
    {
        _scrollView.scrollEnabled = YES;
        
        _collectionView.scrollEnabled = NO;
        
        _scrollView.delegate = self;
        
        _collectionView.bounces = NO;
        
        return;
    }
    else
    {
        [self loadMoreData:(scrollView)];
    }
}

- (void)loadMoreData:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    
    if(currentOffset >= maximumOffset)
    {
        if (_canReqData == YES)
        {
            _canReqData = NO;
            
            [[KGHttpService sharedService] getSPHotCourse:_mappoint pageNo:[NSString stringWithFormat:@"%ld",(long)_pageNo] success:^(SPDataListVO *hotCourseList)
             {
                 NSArray * data = [NSMutableArray arrayWithArray:[SPCourseDomain objectArrayWithKeyValuesArray:hotCourseList.data]];
                 if (data == nil || data.count == 0)
                 {
                     _canReqData = YES;
                 }
                 else
                 {
                     _pageNo++;
                     [_hotCourseData addObjectsFromArray:data];
                     [_collectionView reloadData];
                     
                     _canReqData = YES;
                 }
             }
             faild:^(NSString *errorMsg)
             {
                 _canReqData = YES;
             }];
        }
    }
}

#pragma mark - 上拉刷新，下拉加载数据
- (void)setupRefresh
{
    [_collectionView addFooterWithTarget:self action:@selector(footerRereshing) showActivityView:YES];
    _collectionView.footerPullToRefreshText = @"上拉加载更多";
    _collectionView.footerReleaseToRefreshText = @"松开立即加载";
    _collectionView.footerRefreshingText = @"正在加载中...";
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        _collectionView.footerRefreshingText = @"没有更多了";
        [_collectionView footerEndRefreshing];
    });
    
}


#pragma mark - 芒果广告相关
- (CGSize)adMoGoCustomSize
{
    return CGSizeMake(320, 150);
}

#pragma mark AdMoGoDelegate delegate
/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}
/**
 * 广告开始请求回调
 */
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView
{
    NSLog(@"广告开始请求回调");
}
/**
 * 广告接收成功回调
 */
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView
{
    NSLog(@"广告接收成功回调");
}
/**
 * 广告接收失败回调
 */
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error
{
    NSLog(@"广告接收失败回调");
}
/**
 * 点击广告回调
 */
- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView
{
    NSLog(@"点击广告回调");
}
/**
 *You can get notified when the user delete the ad
 广告关闭回调
 */
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView
{
    
}

@end
