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
#import "SpCourseHomeAdCell.h"
#import "SpCourseHomeCourseTypesCell.h"
#import "SpCourseHomeCourseCell.h"
#import "SPCourseSchoolVC.h"
#import "SPCourseDetailVC.h"
#import "NoNetView.h"

#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"

#define FinishReqCount 2

@interface SpCourseHomeVC () <UICollectionViewDataSource,UICollectionViewDelegate,AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate,SpCourseHomeCourseTypesCellDelegate,NoNetViewDelegate>
{
    SDRotationLoopProgressView * _LoadView;
    
    NoNetView * _noNetView;
    
    UIScrollView * _scrollView;
    
    NSMutableArray * _courseTypes;
    
    NSMutableArray * _hotCourseData;
    
    NSMutableArray * _courseTypesDatakeys;
    
    UICollectionView * _collectionView;
    
    AdMoGoView * _adView;
    
    SpCourseHomeAdCell * _adCell;
    
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

static NSString *const ADCellID = @"adcellcoll";
static NSString *const TypeCellID = @"typecellcoll";
static NSString *const CourseCellID = @"coursecellcoll";

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone adType:AdViewTypeCustomSize
                                  adMoGoViewDelegate:self];
    
    _adView.adWebBrowswerDelegate = self;
    
    _adView.frame = CGRectMake(0.0, 0, APPWINDOWWIDTH, 150.0);
    
    [_adCell.adView addSubview:_adView];
    
    if (_adReqSuccess && _firstJoinSwitch)
    {
        _firstJoinSwitch = NO;
        _adCell.imgView.hidden = YES;
        [_collectionView reloadData];
    }
}

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
    
    //初始化视图
    [self initCollectionView];
    
    _courseTypes = [NSMutableArray array];
    _hotCourseData = [NSMutableArray array];
    
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
        
        //保存所有datakeys
        _courseTypesDatakeys = [NSMutableArray array];
        for (SPCourseTypeDomain * domain in _courseTypes)
        {
            if (domain.datakey == -1)
            {
                [_courseTypesDatakeys addObject:@""];
            }
            else
            {
                [_courseTypesDatakeys addObject:@(domain.datakey)];
            }

        }
        if (_reqSuccessCount == FinishReqCount)
        {
            [self hidenLoadView];
            [self.view addSubview:_collectionView];
        }
    }
    faild:^(NSString *errorMsg)
    {
        _reqFailedCount++;
        if (_reqFailedCount == 2)
        {
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
            [self.view addSubview:_collectionView];
        }
    }
    faild:^(NSString *errorMsg)
    {
        _reqFailedCount++;
        if (_reqFailedCount == 2)
        {
            [self showNoNetView];
        }
    }];
}



#pragma mark - collection的数据源 & 代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2 + _hotCourseData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        SpCourseHomeAdCell * adCell = [collectionView dequeueReusableCellWithReuseIdentifier:ADCellID forIndexPath:indexPath];
        
        _adCell = adCell;
        
        return adCell;
    }
    else if (indexPath.row == 1)
    {
        SpCourseHomeCourseTypesCell * typesCell = [collectionView dequeueReusableCellWithReuseIdentifier:TypeCellID forIndexPath:indexPath];
        
        typesCell.delegate = self;
        
        [typesCell setData:_courseTypes];
        
        return typesCell;
    }
    else
    {
        SpCourseHomeCourseCell * courseCell = [collectionView dequeueReusableCellWithReuseIdentifier:CourseCellID forIndexPath:indexPath];
        
        [courseCell setCourseCellData:_hotCourseData[indexPath.row-2]];
        
        return courseCell;
    }
    
    return nil;
}

#pragma mark - 按钮点击跳转
- (void)pushToVC:(UIButton *)btn
{
    SPCourseTypeDomain * domain = _courseTypes[btn.tag];
    
    SPCourseSchoolVC * courseSchoolVC = [[SPCourseSchoolVC alloc] init];
    
    NSMutableArray *marr = [NSMutableArray array];
    NSInteger clickedIndex = 0;
    for (NSInteger i=0;i<_courseTypes.count;i++)
    {
        SPCourseTypeDomain *d = _courseTypes[i];
        if ([d.datavalue isEqualToString:domain.datavalue])
        {
            clickedIndex = i;
        }
        [marr addObject:d.datavalue];
    }
    
    [marr exchangeObjectAtIndex:0 withObjectAtIndex:clickedIndex];
    [_courseTypesDatakeys exchangeObjectAtIndex:0 withObjectAtIndex:clickedIndex];
    
    courseSchoolVC.courseNameList = marr;
    courseSchoolVC.firstJoinSelType = domain.datavalue;
    courseSchoolVC.firstJoinSelDatakey = domain.datakey;
    courseSchoolVC.courseDatakeys = _courseTypesDatakeys;
    
    [self.navigationController pushViewController:courseSchoolVC animated:YES];

}

- (void)pushToHotCourseVC
{
    SPCourseSchoolVC * courseSchoolVC = [[SPCourseSchoolVC alloc] init];
    
    NSMutableArray *marr = [NSMutableArray array];
    
    for (NSInteger i=0;i<_courseTypes.count;i++)
    {
        SPCourseTypeDomain *d = _courseTypes[i];
        
        [marr addObject:d.datavalue];
    }
    
    [marr exchangeObjectAtIndex:0 withObjectAtIndex:_courseTypes.count - 1];
    [_courseTypesDatakeys exchangeObjectAtIndex:0 withObjectAtIndex:_courseTypes.count - 1];
    
    courseSchoolVC.courseNameList = marr;
    courseSchoolVC.firstJoinSelType = @"查看全部";
    courseSchoolVC.firstJoinSelDatakey = -1;
    courseSchoolVC.courseDatakeys = _courseTypesDatakeys;
    
    [self.navigationController pushViewController:courseSchoolVC animated:YES];
}

#pragma mark - 选中item后调转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPCourseDetailVC * detailVC = [[SPCourseDetailVC alloc] init];
    
    SPCourseDomain * domain = _hotCourseData[indexPath.row - 2];
    
    detailVC.uuid = domain.uuid;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 初始化视图相关
- (void)initCollectionView
{
    //创建coll布局
    SpCourseHomeWFLayout *layout = [[SpCourseHomeWFLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SpCourseHomeAdCell" bundle:nil] forCellWithReuseIdentifier:@"adcellcoll"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SpCourseHomeCourseTypesCell" bundle:nil] forCellWithReuseIdentifier:@"typecellcoll"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SpCourseHomeCourseCell" bundle:nil] forCellWithReuseIdentifier:@"coursecellcoll"];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self setupRefresh];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
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
                    
                }
                else
                {
                    _pageNo++;
                    [_hotCourseData addObjectsFromArray:data];
                    [_collectionView reloadData];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                    {
                        _canReqData = YES;
                    });
                }
            }
            faild:^(NSString *errorMsg)
            {
                 
            }];

        }
    }
}

#pragma mark - 菊花相关
- (void)showLoadView
{
    if (_LoadView == nil)
    {
        _LoadView = [SDRotationLoopProgressView progressView];
        
        _LoadView.frame = CGRectMake(0, 0, 100 * KWidth_Scale, 100 * KWidth_Scale);
        
        _LoadView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 64);
    }
    
    [self.view addSubview: _LoadView];
}

- (void)hidenLoadView
{
    [UIView animateWithDuration:0.3 animations:^
     {
         [_LoadView removeFromSuperview];
     }];
}

- (void)tryBtnClicked
{
    [_noNetView removeFromSuperview];
    _noNetView.delegate = nil;
    _noNetView = nil;
    
    _reqSuccessCount = 0;
    _reqFailedCount = 0;
    
    //加载课程分类
    [self loadCourseTypesData];
    
    //加载热门课程
    [self loadHotCourseData];
    
    //初始化视图
    [self initCollectionView];
}

- (void)showNoNetView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _noNetView = [[[NSBundle mainBundle] loadNibNamed:@"NoNetView" owner:nil options:nil] firstObject];
    
    _noNetView.delegate = self;
    
    _noNetView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 64);
    
    [self.view addSubview:_noNetView];
}

#pragma mark - 上拉刷新，下拉加载数据
/**
 *  集成刷新控件
 */
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
    _adReqSuccess = YES;
}
/**
 * 广告接收失败回调
 */
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error{
    NSLog(@"广告接收失败回调");
    _adReqSuccess = NO;
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
    _adCell.imgView.hidden = NO;
    _adCell.userInteractionEnabled = NO;
    [_collectionView reloadData];
}




@end
