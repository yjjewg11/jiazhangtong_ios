//
//  DiscorveryVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//
#import "DiscorveryVC.h"
#import "MJRefresh.h"
#import "KGHttpService.h"
#import "MJExtension.h"
#import "DiscorveryHomeLayout.h"
#import "DiscorveryTypeCell.h"
#import "TuiJianCell.h"
#import "NoDataView.h"
#import "GiftwareArticlesViewController.h"
#import "YouHuiVC.h"
#import "KGHUD.h"
#import "DiscorveryMeiRiTuiJianDomain.h"
#import "DiscorveryNewNumberDomain.h"
#import "DiscorveryJingXuanCell.h"
#import "DiscorveryWebVC.h"

@interface DiscorveryVC () <UICollectionViewDataSource,UICollectionViewDelegate,DiscorveryTypeCellDelegate,UIScrollViewDelegate,UIWebViewDelegate,TuiJianCellDelegate>
{
    UICollectionView * _collectionView;
    
    DiscorveryMeiRiTuiJianDomain * _tuijianDomain;
    
    NSMutableArray * _remenjingxuanData;
    
    DiscorveryNewNumberDomain * _numberDomain;
    
    DiscorveryHomeLayout * _layOut;
    
    NSMutableArray * _haveReMenJingXuanPic;
    
    BOOL _canReqData;
    
    NSInteger _pageNo;
}

@property (strong, nonatomic) NSString * groupuuid;

@property (strong, nonatomic) DiscorveryWebVC * webVC;

@end

@implementation DiscorveryVC

static NSString *const TypeColl = @"typecoll";
static NSString *const TuiJianColl= @"tuijiancoll";
static NSString *const TopicColl = @"topiccoll";
static NSString *const Nodata = @"nodata";

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)tryBtnClicked
{
    [self getTuiJianData];
    
    [self initCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_webVC != nil)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBarHidden = YES;
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.navigationController.navigationBarHidden = NO;
    }
    
    NSNotification * no = [[NSNotification alloc] initWithName:@"homerefreshnum" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:no];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideWebVC) name:@"deallocwebview" object:nil];
}

- (void)updateNumData
{
    //请求最新数据条数显示 红点
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    _numberDomain = [[DiscorveryNewNumberDomain alloc] init];
    _numberDomain.today_goodArticle = [[defu objectForKey:@"jingpingwenzhangnum"] integerValue];
    _numberDomain.today_snsTopic = [[defu objectForKey:@"huatinum"] integerValue];
    _numberDomain.today_pxbenefit = [[defu objectForKey:@"youhuihuodongnum"] integerValue];
    _numberDomain.today_unreadPushMsg = [[defu objectForKey:@"xiaoxinum"] integerValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发现";
    
    _pageNo = 2;
    
    [self updateNumData];
    
    //请求每日推荐
    [self getTuiJianData];
    
    [self initCollectionView];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(updateNumData) name:@"updateNumData" object:nil];
}

#pragma mark - 请求每日推荐
- (void)getTuiJianData
{
    [self showLoadView];
    [self hidenNoNetView];
    
    [[KGHttpService sharedService] getMeiRiTuiJian:^(DiscorveryMeiRiTuiJianDomain *mgr)
    {
        _tuijianDomain = mgr;
        
        //请求热门精选
        [self getReMenJingXuan];
    }
    faild:^(NSString *errorMsg)
    {
        [self hidenLoadView];
        [self showNoNetView];
    }];
}

#pragma mark - 请求热门精选
- (void)getReMenJingXuan
{
    [[KGHttpService sharedService] getReMenJingXuan:@"1" success:^(NSArray *remenjingxuanarr)
    {
        [self hidenLoadView];
        
        _remenjingxuanData = [NSMutableArray arrayWithArray:remenjingxuanarr];
        
        [self calCellHavePic];
        
        [self.view addSubview:_collectionView];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

#pragma mark - 创建是否有图片的判断数组
- (void)calCellHavePic
{
    _haveReMenJingXuanPic = [NSMutableArray array];
    
    for (DiscorveryReMenJingXuanDomain * d in _remenjingxuanData)
    {
        if (d.imgList.count == 0)
        {
            [_haveReMenJingXuanPic addObject:@(NO)];
        }
        else
        {
            [_haveReMenJingXuanPic addObject:@(YES)];
        }
    }
    
    //把数组交给layout
    _layOut.havePicArr = _haveReMenJingXuanPic;
}

#pragma mark - coll数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_remenjingxuanData.count == 0 || _remenjingxuanData == nil)
    {
        return 3;
    }
    else
    {
        return 2 + _remenjingxuanData.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        DiscorveryTypeCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:TypeColl forIndexPath:indexPath];
        
        cell.delegate = self;
        
        [cell setData:_numberDomain];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        TuiJianCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:TuiJianColl forIndexPath:indexPath];
        
        cell.delegate = self;
        
        [cell setData:_tuijianDomain];
        
        return cell;
    }
    else if (indexPath.row >= 2)
    {
        if (_remenjingxuanData.count == 0 || _remenjingxuanData == nil)
        {
            NoDataView * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:Nodata forIndexPath:indexPath];
            
            return cell;
        }
        else
        {
            DiscorveryJingXuanCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:TopicColl forIndexPath:indexPath];
            
            [cell setData:_remenjingxuanData[indexPath.row - 2]];
            
            return cell;
        }
    }
    return nil;
}

#pragma mark - 界面跳转代理
- (void)pushToVC:(UIButton *)btn
{
    BaseViewController * baseVC = nil;
    switch (btn.tag)
    {
        case 0:
        {
            baseVC = [[GiftwareArticlesViewController alloc] init];
        }
            break;
        case 1:
        {
            [self setupWebView:nil];
        }
            break;
        case 2:
        {
            baseVC = [[YouHuiVC alloc] init];
        }
            break;
        default:
            break;
    }
    if(baseVC)
    {
        [self.navigationController pushViewController:baseVC animated:YES];
    }
}

#pragma mark - 点击跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 2)
    {
        [self setupWebView:((DiscorveryReMenJingXuanDomain *)_remenjingxuanData[indexPath.row-2]).webview_url];
    }
}

- (void)openTuiJianWebView:(NSString *)url
{
    [self setupWebView:url];
}

#pragma mark - 创建webview
/**
 *  不传url默认就是话题url
 *
 *  @param url 需要传递的url
 */
- (void)setupWebView:(NSString *)otherUrl
{
    DiscorveryWebVC * webvc;
    
    if (_webVC == nil)
    {
         webvc = [[DiscorveryWebVC alloc] init];
        
        _webVC = webvc;
        
        webvc.webViewFrame = CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 64);
        
        [self.view addSubview:webvc.view];
    }
    else
    {
        _webVC.view.alpha = 1;
    }
    
    if (otherUrl == nil)
    {
        NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
        
        NSString * url = [defu objectForKey:@"sns_url"];
        
        //    [webvc loadWithCookieSettingsUrl:@"http://120.25.212.44/px-rest/phone_Api/index.html" cookieDomain:nil path:nil];
        
        [webvc loadWithCookieSettingsUrl:url cookieDomain:[webvc cutUrlDomain:url] path:nil];
    }
    else
    {
        [webvc loadWithCookieSettingsUrl:otherUrl cookieDomain:[webvc cutUrlDomain:otherUrl] path:nil];
    }
    
    _collectionView.hidden = YES;
    
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:0];
    
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    DiscorveryHomeLayout *layout = [[DiscorveryHomeLayout alloc] init];
    
    _layOut = layout;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 44 - 70) collectionViewLayout:layout];
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DiscorveryTypeCell" bundle:nil] forCellWithReuseIdentifier:TypeColl
     ];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"TuiJianCell" bundle:nil] forCellWithReuseIdentifier:TuiJianColl
     ];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NoDataView" bundle:nil] forCellWithReuseIdentifier:Nodata
     ];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DiscorveryJingXuanCell" bundle:nil] forCellWithReuseIdentifier:TopicColl
     ];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self setupRefresh];
}

#pragma mark - webview通知
- (void)hideWebVC
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
       _collectionView.hidden = NO;
       
       [UIView animateWithDuration:0.4 animations:^
        {
            _webVC.view.transform = CGAffineTransformMakeTranslation(-APPWINDOWWIDTH, 0);
            _webVC.view.alpha = 0;
        }];
        
        _webVC = nil;
        
       [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:0];
       self.navigationController.navigationBarHidden = NO;
    });
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
    [[KGHttpService sharedService] getReMenJingXuan:[NSString stringWithFormat:@"%ld",(long)_pageNo] success:^(NSArray *remenjingxuanarr)
     {
         NSMutableArray * arr = [NSMutableArray arrayWithArray:remenjingxuanarr];
         
         if (arr.count == 0)
         {
             [_collectionView footerEndRefreshing];
         }
         else
         {
             _pageNo ++;
             
             [_remenjingxuanData addObjectsFromArray:arr];
             
             [self calCellHavePic];
             
             [_collectionView footerEndRefreshing];
             
             [_collectionView reloadData];
         }
     }
     faild:^(NSString *errorMsg)
     {
        
     }];
}
@end
