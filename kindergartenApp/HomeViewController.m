//
//  HomeViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "HomeViewController.h"
#import "ImageCollectionView.h"
#import "Masonry.h"
#import "IntroductionViewController.h"
#import "UIView+Extension.h"
#import "RegViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "AnnouncementListViewController.h"
#import "InteractViewController.h"
#import "TeacherJudgeViewController.h"
#import "GiftwareArticlesViewController.h"
#import "StudentSignRecordViewController.h"
#import "MoreMenuView.h"
#import "PopupView.h"
#import "RecipesListViewController.h"
#import "TimetableViewController.h"
#import "UIColor+Extension.h"
#import "UIButton+Extension.h"
#import "ItemTitleButton.h"
#import "BrowseURLViewController.h"
#import "KGAccountTool.h"
#import "BaiduMobAdInterstitial.h"
#import "BaiduMobAdDelegateProtocol.h"
#import "BaiduMobAdView.h"
#import "KGNavigationController.h"
#import "LoginViewController.h"
#import "YouHuiVC.h"
#import "EnrolStudentsHomeVC.h"
#import <CoreLocation/CoreLocation.h>
#import "AddressBooksViewController.h"
#import "FeHourGlass.h"
#import "MBProgressHUD+HM.h"

#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"

#import "SpCourseHomeVC.h"
#import "KGDateUtil.h"
#import "NSDate+Utils.h"

@interface HomeViewController () <ImageCollectionViewDelegate, UIGestureRecognizerDelegate,AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate,CLLocationManagerDelegate>
{
    IBOutlet UIView * photosView;
    
    IBOutlet UIView * funiView;
    
    PopupView * popupView;
    UIView    * groupListView;
    ItemTitleButton  * titleBtn;
    NSArray   * groupDataArray;
    CGFloat     groupViewHeight;
    CLLocationManager *mgr;
    
    DiscorveryNewNumberDomain *numberDomain;
    
    FeHourGlass * _hourGlass;
}

@property (strong, nonatomic) AdMoGoView * adView;

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone adType:AdViewTypeCustomSize
                                  adMoGoViewDelegate:self];
    
    self.adView.adWebBrowswerDelegate = self;
    
    self.adView.frame = CGRectMake((APPWINDOWWIDTH - 360) / 2, 0, 360, 150.0);
    
    [photosView addSubview:self.adView];
    
    [photosView bringSubviewToFront:self.adView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestGroupDate];
    
    _hourGlass = [[FeHourGlass alloc] initWithView:photosView];
    
    _hourGlass.center = photosView.center;
    
    [photosView addSubview:_hourGlass];
    
    [_hourGlass showWhileExecutingBlock:^
    {
         
    }
    completion:^
    {
         
    }];
    
//    self.adView.hidden = YES;
//    funiView.hidden = YES;
//    photosView.hidden = YES;
    
//    [self loadNavTitle];
    
    [self autoLogin];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    mgr = [[CLLocationManager alloc] init];
    
    //使用偏好设置保存数据
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    
    [defu setObject:@"" forKey:@"map_point"];
    
    //调用同步的方法，把数据保存到沙盒
    [defu synchronize];
    
    [self getLocationData];
    
    //注册通知，用于发现模块 最新数目显示
    //注册通知
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(getNewsNumber) name:@"homerefreshnum" object:nil];
}

#pragma mark - 芒果广告相关
- (CGSize)adMoGoCustomSize
{
    return CGSizeMake(360, 150);
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
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告开始请求回调");
}
/**
 * 广告接收成功回调
 */
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告接收成功回调");
    [self.view bringSubviewToFront:self.adView];
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
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView
{
    self.adView.hidden = YES;
    photosView.userInteractionEnabled = NO;
    
    UIImageView * imgView = [[UIImageView alloc] init];
    
    imgView.frame = self.adView.frame;
    
    imgView.image = [UIImage imageNamed:@"adbanner"];
    
    [self.view addSubview:imgView];
}

- (void)loadNavTitle {
    titleBtn = [[ItemTitleButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    if([[KGHttpService sharedService].loginRespDomain.group_list count] > Number_Zero) {
        [titleBtn setImage:@"xiajiantou" selImg:@"sjiantou"];
    }
    
    // 设置图片和文字
    NSString * title = @"首页";
    if([KGHttpService sharedService].groupDomain) {
        title = [KGHttpService sharedService].groupDomain.brand_name;
    }
    
    [titleBtn setTitle:title
                 forState:UIControlStateNormal];
    // 监听标题点击
    [titleBtn addTarget:self
                    action:@selector(titleFunBtnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
}

- (void)titleFunBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    CGFloat y = 0;
    if(!sender.selected) {
        y -= groupViewHeight;
        titleBtn.selected = NO;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        groupListView.y = y;
    }];
}

//加载机构下拉列表
- (void)loadGroupListView {
    if(groupDataArray && [groupDataArray count]>Number_Zero) {
        
        groupViewHeight = [groupDataArray count] * Cell_Height2;
        if (!groupListView) {
            groupListView = [[UIView alloc] initWithFrame:CGRectMake(Number_Zero, -groupViewHeight, KGSCREEN.size.width, groupViewHeight)];
            groupListView.backgroundColor = KGColorFrom16(0xE64662);
            [self.view addSubview:groupListView];
        }else{
            [groupListView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        GroupDomain *         domain = nil;
        UILabel     * groupNameLabel = nil;
        UILabel     *    spliteLabel = nil;
        UIButton    *            btn = nil;
        CGFloat   y = Number_Zero;
        
        for(NSInteger i=Number_Zero; i<[groupDataArray count]; i++) {
            
            domain = [groupDataArray objectAtIndex:i];
            y = Number_Fifteen + (i*Cell_Height2);
            
            groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(Number_Zero, y, KGSCREEN.size.width, Number_Fifteen)];
            groupNameLabel.font = [UIFont systemFontOfSize:Number_Fifteen];
            groupNameLabel.text = domain.company_name;
            groupNameLabel.textColor = [UIColor whiteColor];
            groupNameLabel.textAlignment = NSTextAlignmentCenter;
            [groupListView addSubview:groupNameLabel];
            
            btn = [[UIButton alloc] initWithFrame:CGRectMake(Number_Zero, y, KGSCREEN.size.width, Cell_Height2)];
            btn.targetObj = domain;
            [btn addTarget:self action:@selector(didSelectedGroupList:) forControlEvents:UIControlEventTouchUpInside];
            [groupListView addSubview:btn];
            
            if(i < [groupDataArray count]-Number_One) {
                spliteLabel = [[UILabel alloc] initWithFrame:CGRectMake(Number_Zero, CGRectGetMaxY(groupNameLabel.frame) + Number_Fifteen, KGSCREEN.size.width, 0.5)];
                spliteLabel.backgroundColor = [UIColor whiteColor];
                [groupListView addSubview:spliteLabel];
            }
        }
    }
}


//选择机构
- (void)didSelectedGroupList:(UIButton *)sender
{
    GroupDomain * domain = (GroupDomain *)sender.targetObj;
    [titleBtn setText:domain.company_name];
    [KGHttpService sharedService].groupDomain = domain;

    [self titleFunBtnClicked:titleBtn];
}

- (void)requestGroupDate
{
    groupDataArray = [KGHttpService sharedService].loginRespDomain.group_list;
    
    [self loadNavTitle];
    
    [self loadGroupListView];
    
    [self getSysConfig];
    
    [self getNewsNumber];
}

- (void)getSysConfig
{
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    NSString * time = [defu objectForKey:@"timeofreq"];
    NSString * sns_url = [defu objectForKey:@"sns_url"];
    NSLog(@"磁盘存放的时间:%@ , 最新话题地址:%@",time,sns_url);
    
    if (time == nil || [time isEqualToString:@""])  //第一次进来，请求一个md5,并设置时间
    {
        [defu setObject:[KGDateUtil getTime] forKey:@"timeofreq"];//设置当前时间
        
        [[KGHttpService sharedService] getSysConfig:@"" success:^(SystemConfigOfTopic *sysDomain)
        {
            [defu setObject:sysDomain.md5 forKey:@"md5"]; //设置md5
            if (sysDomain.sns_url == nil)
            {
                sysDomain.sns_url = @"";
            }
            [defu setObject:sysDomain.sns_url forKey:@"sns_url"]; //设置话题url
            [defu synchronize];
        }
        faild:^(NSString *errorMsg)
        {
            
        }];
    }
    else //不是第一次进来，获取存到磁盘的时间，和当前时间做比较，如果大于一天，就调用sys方法
    {
        if ([KGDateUtil intervalSinceNow:time] >= 1)
        {
            //是时候调用了
            NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
            NSString * md5 = [defu objectForKey:@"md5"];
            [defu setObject:[KGDateUtil getTime] forKey:@"timeofreq"];//设置当前时间
            
            if (md5 == nil || [md5 isEqualToString:@""])
            {
                md5 = @"";
            }
            
            [[KGHttpService sharedService] getSysConfig:md5 success:^(SystemConfigOfTopic *sysDomain)
            {
                [defu setObject:sysDomain.md5 forKey:@"md5"]; //设置md5
                if (sysDomain.sns_url == nil)
                {
                    sysDomain.sns_url = @"";
                }
                [defu setObject:sysDomain.sns_url forKey:@"sns_url"]; //设置话题url
                [defu synchronize];
            }
            faild:^(NSString *errorMsg)
            {
                
            }];
        }
        else
        {
            NSLog(@"还没到时候调用这个方法");
        }
    }
}

#pragma mark - 获取话题和消息 显示最新消息数量
- (void)getNewsNumber
{
    [[KGHttpService sharedService] getDiscorveryNewNumber:^(DiscorveryNewNumberDomain *newnum)
    {
        //设置给tabbar的消息按钮
        
        //使用偏好设置保存数据
        NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
        
        if (newnum != nil)
        {
            [defu setObject:@(newnum.today_goodArticle) forKey:@"jingpingwenzhangnum"];
            [defu setObject:@(newnum.today_snsTopic) forKey:@"huatinum"];
            [defu setObject:@(newnum.today_pxbenefit) forKey:@"youhuihuodongnum"];
            [defu setObject:@(newnum.today_unreadPushMsg) forKey:@"xiaoxinum"];
            [defu synchronize];
            
            NSNotification * noti = [[NSNotification alloc] initWithName:@"updateNumData" object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotification:noti];
        }
        
        [self hidenLoadView];
        
        self.adView.hidden = NO;
        funiView.hidden = NO;
        photosView.hidden = NO;
    }
    faild:^(NSString *errorMsg)
    {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//人群属性接口
/**
 *  - 关键词数组
 */
-(NSArray*) keywords{
    NSArray* keywords = [NSArray arrayWithObjects:@"测试",@"关键词", nil];
    return keywords;
}

/**
 *  - 用户性别
 */
-(BaiduMobAdUserGender) userGender{
    return BaiduMobAdMale;
}

/**
 *  - 用户生日
 */
-(NSDate*) userBirthday{
    NSDate* birthday = [NSDate dateWithTimeIntervalSince1970:0];
    return birthday;
}

/**
 *  - 用户城市
 */
-(NSString*) userCity{
    return @"成都";
}


/**
 *  - 用户邮编
 */
-(NSString*) userPostalCode{
    return @"610000";
}


/**
 *  - 用户职业
 */
-(NSString*) userWork{
    return @"家长";
}

/**
 *  - 用户最高教育学历
 *  - 学历输入数字，范围为0-6
 *  - 0表示小学，1表示初中，2表示中专/高中，3表示专科
 *  - 4表示本科，5表示硕士，6表示博士
 */
-(NSInteger) userEducation{
    return  2;
}

/**
 *  - 用户收入
 *  - 收入输入数字,以元为单位
 */
-(NSInteger) userSalary{
    return 10000;
}

/**
 *  - 用户爱好
 */
-(NSArray*) userHobbies{
    NSArray* hobbies = [NSArray arrayWithObjects:@"学习",@"学生",@"爱好", nil];
    return hobbies;
}

/**
 *  - 其他自定义字段
 */
-(NSDictionary*) userOtherAttributes{
    NSMutableDictionary* other = [[NSMutableDictionary alloc] init];
    [other setValue:@"测试" forKey:@"测试"];
    return other;
}

#pragma mark - ImageCollectionViewDelegate

//单击回调
-(void)singleTapEvent:(NSString *)pType
{
    
}


#pragma mark - 功能按钮点击
- (IBAction)funBtnClicked:(UIButton *)sender {
    BaseViewController * baseVC = nil;
    switch (sender.tag) {
        case 10: {
//            NSArray * array = [NSArray new];
//            NSLog(@"====%@",  [array objectAtIndex:3]);
            baseVC = [[InteractViewController alloc] init];
//            [self showChildView:sharedAdView];
            break;
        } case 11:
            baseVC = [[EnrolStudentsHomeVC alloc] init];
            break;
        case 12:
            baseVC = [[AnnouncementListViewController alloc] init];
            break;
        case 13:
            baseVC = [[StudentSignRecordViewController alloc] init];
            break;
        case 14:
            baseVC = [[TimetableViewController alloc] init];
            break;
        case 15:
            baseVC = [[RecipesListViewController alloc] init];
            break;
        case 16:
            baseVC = [[GiftwareArticlesViewController alloc] init];
            break;
        case 17:
            baseVC = [[SpCourseHomeVC alloc] init];
            break;
        case 18:
            baseVC = [[TeacherJudgeViewController alloc] init];
            break;
        case 19:
            [self loadMoreFunMenu:sender];
            break;
        case 20:
            baseVC = [[AddressBooksViewController alloc] init];
            baseVC.title = @"通讯录";
            break;
        default:
            break;
    }
    
    if(baseVC) {
        [self.navigationController pushViewController:baseVC animated:YES];
    }
}


- (void)loadMoreFunMenu:(UIButton *)sender {
    
    if(!popupView) {
        popupView = [[PopupView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, KGSCREEN.size.width, KGSCREEN.size.height)];
        popupView.alpha = Number_Zero;
        
        NSArray * moreMenuArray = [KGHttpService sharedService].dynamicMenuArray;
        NSInteger totalRow = ([moreMenuArray count] + Number_Four - Number_One) / Number_Four;
        CGFloat moreViewH = (totalRow * 77) + 64;
        CGFloat moreViewY = KGSCREEN.size.height - moreViewH;
        MoreMenuView * moreVC = [[MoreMenuView alloc] initWithFrame:CGRectMake(Number_Zero, moreViewY, KGSCREEN.size.width, moreViewH)];
        [popupView addSubview:moreVC];
        [moreVC loadMoreMenu:moreMenuArray];
        moreVC.MoreMenuBlock = ^(DynamicMenuDomain * domain){
            [self didSelectedMoreMenuItem:domain];
        };

        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:popupView];
    }
    
    [UIView viewAnimate:^{
        popupView.alpha = Number_One;
    } time:Number_AnimationTime_Five];
    
}


- (void)popupCallback {
    [UIView viewAnimate:^{
        popupView.alpha = Number_Zero;
    } time:Number_AnimationTime_Five];
}

- (void)didSelectedMoreMenuItem:(DynamicMenuDomain *)domain {
    [self popupCallback];
    
    if(domain) {
        BrowseURLViewController * vc = [[BrowseURLViewController alloc] init];
        vc.title = domain.name;
        vc.url = @"http://jz.wenjienet.com/px-mobile/kd/index.html?fn=phone_myclassNews";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//自动登录
- (void)autoLogin
{
    KGUser * account = [KGAccountTool account];
    if(account)
    {
        [[KGHttpService sharedService] login:account success:^(NSString *msgStr)
        {
            [self requestGroupDate];
//            [titleBtn setImage:@"xiajiantou" selImg:@"sjiantou"];
        }
        faild:^(NSString *errorMsg)
        {
            [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[KGNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        }];
    }
}

#pragma mark - 获取位置
- (void)getLocationData
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        [mgr requestWhenInUseAuthorization];
    }
    
    mgr.delegate = self;
    
    mgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    mgr.distanceFilter = 5.0;
    
    [mgr startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = [locations firstObject];
    
    NSString *mappoint = [NSString stringWithFormat:@"%lf,%lf",loc.coordinate.longitude,loc.coordinate.latitude];
    
    if (mappoint == nil || [mappoint isEqualToString:@""])
    {
        mappoint = @"";
    }
    
    //使用偏好设置保存数据
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    
    [defu setObject:mappoint forKey:@"map_point"];
    
    //调用同步的方法，把数据保存到沙盒
    [defu synchronize];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"尝试获取您的位置失败,请检查是否开启定位功能!");
}


@end
