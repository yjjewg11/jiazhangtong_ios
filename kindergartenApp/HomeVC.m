//
//  HomeVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/15.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "HomeVC.h"
#import "KGHttpService.h"
#import "KGAccountTool.h"
#import "KGNavigationController.h"
#import "KGHUD.h"
#import "LoginViewController.h"
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"
#import "KGDateUtil.h"
#import "InteractViewController.h"
#import "EnrolStudentHomeVC.h"
#import "AnnouncementListViewController.h"
#import "StudentSignRecordViewController.h"
#import "TimetableViewController.h"
#import "RecipesListViewController.h"
#import "GiftwareArticlesViewController.h"
#import "SpCourseHomeVC.h"
#import "TeacherJudgeViewController.h"
#import "PopupView.h"
#import "MoreMenuView.h"
#import "BrowseURLViewController.h"
#import "AddressBooksViewController.h"

#import "Masonry.h"

#define FunItemH 60.00;
#define FunItemW 50.00;

@interface HomeVC () <CLLocationManagerDelegate,AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate>
{
    PopupView * popupView;
    DiscorveryNewNumberDomain * numberDomain;
    UIScrollView * scrollView;
}

@property (strong, nonatomic) CLLocationManager * mgr;

@end

@implementation HomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self autoLoginJessionid];
//    [self autoLogin];
    
    //获取地理坐标
    [self getMapLocation];
    
    //获取最新话题地址
    [self getSysConfig];
    
    //#pragma mark - 获取话题和消息 显示最新消息数量
    [self getNewsNumber];
    
    //注册通知，用于发现模块 最新数目显示
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(getNewsNumber) name:@"homerefreshnum" object:nil];
    
    [self initHomeView];

}

- (void)checkUserLogin
{
    KGUser * account = [KGAccountTool account];
    if(account)
    {
        [[KGHttpService sharedService] login:account success:^(NSString *msgStr)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self initHomeView];
            });
        }
        faild:^(NSString *errorMsg)
        {
            [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[KGNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        }];
    }
}
-(void) initDataByUserLoginAfter{
    [UploadPhotoToRemoteService upLoadAllFromLocalDB];
    //淘宝消息登录
    [KGAccountService login];
    
     [GuidePageController firstLaunch];
    
    //获取首页动态菜单
    [[KGHttpService sharedService] getDynamicMenu:^(NSArray *menuArray) {
        
    } faild:^(NSString *errorMsg) {
        
    }];
    
    [[KGHttpService sharedService] getGroupList:^(NSArray *groupArray) {
        
    } faild:^(NSString *errorMsg) {
        
    }];
    
    [[KGHttpService sharedService] getEmojiList:^(NSString *msgStr) {
        
    } faild:^(NSString *errorMsg) {
        
    }];

}


#pragma mark - 初始化view
- (void)initHomeView
{
//    [self initDataByUserLoginAfter];
    NSMutableArray *homeMenuBtnArr=[NSMutableArray array];
    
   
    [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"班级互动" iconUrl:@"hudong" tag:10]];
    [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"课程表" iconUrl:@"kechenbiao" tag:11]];
     [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"每日食谱" iconUrl:@"shipu" tag:12]];
    
     [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"校园公告" iconUrl:@"gonggao" tag:13]];
     [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"签到记录" iconUrl:@"qiandao" tag:14]];
      [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"视频" iconUrl:@"jiankongshiping" tag:20]];
    
    
    [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"评价老师" iconUrl:@"pingjialaoshi" tag:15]];
    [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"宝宝入学" iconUrl:@"baobaoruxue" tag:16]];
    [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"通讯录" iconUrl:@"tongxunlu" tag:17]];
     [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"通讯录" iconUrl:@"tongxunlu" tag:17]];
     [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"特长课程" iconUrl:@"techang1" tag:18]];
   
    [homeMenuBtnArr addObject:[[HomeMenuBtn alloc]initData:@"更多" iconUrl:@"gengduo" tag:19]];
//    NSArray * imgSrcArr = @[@"hudong",@"kechenbiao",@"shipu",@"gonggao",@"qiandao",@"pingjialaoshi",@"baobaoruxue",@"tongxunlu",@"techang1",@"gengduo"];
//    
//    NSArray * nameTitleArr = @[@"班级互动",@"课程表",@"每日食谱",@"校园公告",@"签到记录",@"评价老师",@"宝宝入学",@"通讯录",@"特长课程",@"更多"];

    
    
    //创建scrollview
    scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make)
    {
         make.edges.equalTo(self.view);//此处替代了cgrectmake
    }];
    
    //创建一个container好让scrollview自动计算出contentsize
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make)
    {
         make.edges.equalTo(scrollView);
         make.width.equalTo(scrollView);
    }];
    
    //先把广告view加进去
    AdMoGoView * adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone adType:AdViewTypeCustomSize
                                          adMoGoViewDelegate:self];
    adView.adWebBrowswerDelegate = self;
    adView.frame = CGRectMake((APPWINDOWWIDTH - 320)/2 , 0, 320, 150);
    [container addSubview:adView];
    
    //再创建一个funview
    UIView * funContainer = [UIView new];
    [container addSubview:funContainer];
    [funContainer mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.equalTo(container).with.insets(UIEdgeInsetsMake(150, 0, 0, 0));
    }];
    
    //分割线view
    UIView * sepView = [UIView new];
    sepView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [funContainer addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.height.mas_equalTo(@2);
        make.top.equalTo(funContainer.mas_top);
        make.left.equalTo(funContainer.mas_left);
        make.right.equalTo(funContainer.mas_right);
    }];
    
    //接下来创建每个功能view
    NSInteger count = homeMenuBtnArr.count;
    CGFloat padding = 20;//每个功能view的间距
    UIView * lastView = nil;
    
    for ( NSInteger i = 0 ; i < count ; ++i )
    {
        
        
        HomeMenuBtn * homeMenuBtn=homeMenuBtnArr[i];
        UIView *subv = [UIView new];
        [funContainer addSubview:subv];
        
        //创建title lbl
        UILabel *lable = [[UILabel alloc] init];
        lable.text = homeMenuBtn.name;
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentCenter;
        [subv addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(subv.mas_left);
            make.right.equalTo(subv.mas_right);
            make.bottom.equalTo(subv.mas_bottom);
            make.height.mas_equalTo(@15);
        }];
        
        //创建image view
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:homeMenuBtn.iconUrl];
        [subv addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.equalTo(subv.mas_top).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
            make.right.equalTo(subv.mas_right).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
            make.left.equalTo(subv.mas_left).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
            make.bottom.equalTo(lable.mas_top).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        //创建button
        UIButton * btn = [[UIButton alloc] init];
        btn.tag = homeMenuBtn.tag;
        [btn addTarget:self action:@selector(funBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [subv addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.edges.equalTo(subv);
        }];
        
        NSInteger row = (NSInteger)(i / 3) + 1;
        NSInteger col = (i % 3) + 1;

        CGFloat cellW = (APPWINDOWWIDTH - 4 * 20) / 3;
        CGFloat cellH = (APPWINDOWWIDTH - 4 * 20) / 3 + 15;
        CGFloat cellX = padding + (col - 1) * cellW + (col - 1) * padding;
        CGFloat cellY = padding + (row - 1) * cellW + (row - 1) * padding;
        
        subv.frame = CGRectMake(cellX, cellY, cellW, cellH);
        
        lastView = subv;
    }
    
    [funContainer mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.bottom.equalTo(lastView.mas_bottom);
    }];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.bottom.equalTo(funContainer.mas_bottom);
    }];
}

#pragma mark - 获取地理坐标
- (void)getMapLocation
{
    self.mgr = [[CLLocationManager alloc] init];
    
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    [defu setObject:@"" forKey:@"map_point"];
    [defu synchronize];
    
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
    
    NSString *mappoint = [NSString stringWithFormat:@"%lf,%lf",loc.coordinate.longitude,loc.coordinate.latitude];
    if (mappoint == nil || [mappoint isEqualToString:@""])
    {
        mappoint = @"";
    }
    
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];//使用偏好设置保存数据
    [defu setObject:mappoint forKey:@"map_point"];
    [defu synchronize];//调用同步的方法，把数据保存到沙盒
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
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView
{}
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView
{}
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error
{}
- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView
{}
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView
{}

#pragma mark - 获取最新话题
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
         {}];
    }
    else //不是第一次进来，获取存到磁盘的时间，和当前时间做比较，如果大于一天，就调用sys方法
    {
        if ([KGDateUtil intervalSinceNow:time] >= 0) //这里可以改天数
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
             {}];
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
             if (newnum.today_unreadPushMsg>0)
             {
                 UITabBarItem * item = self.tabBarController.tabBar.items[2];
                 item.image = [UIImage imageNamed:@"hxiaoxi3"];
             }
             
             [defu setObject:@(newnum.today_goodArticle) forKey:@"jingpingwenzhangnum"];
             [defu setObject:@(newnum.today_snsTopic) forKey:@"huatinum"];
             [defu setObject:@(newnum.today_pxbenefit) forKey:@"youhuihuodongnum"];
             [defu setObject:@(newnum.today_unreadPushMsg) forKey:@"xiaoxinum"];
             [defu synchronize];
             
             NSNotification * noti = [[NSNotification alloc] initWithName:@"updateNumData" object:nil userInfo:nil];
             [[NSNotificationCenter defaultCenter] postNotification:noti];
         }
     }
     faild:^(NSString *errorMsg)
     {}];
}

#pragma mark - 功能按钮点击
- (IBAction)funBtnClicked:(UIButton *)sender
{
    BaseViewController * baseVC = nil;
    switch (sender.tag)
    {
        case 10:
            baseVC = [[InteractViewController alloc] init];
            [self umengEvent:@"interactCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 11:
            baseVC = [[TimetableViewController alloc] init];
            [self umengEvent:@"timetableCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 12:
            baseVC = [[RecipesListViewController alloc] init];
            [self umengEvent:@"recipesCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 13:
            baseVC = [[AnnouncementListViewController alloc] init];
            [self umengEvent:@"announcementCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 14:
            baseVC = [[StudentSignRecordViewController alloc] init];
            [self umengEvent:@"signCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 15:
            baseVC = [[TeacherJudgeViewController alloc] init];
            [self umengEvent:@"teacherCommentCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 16:
            baseVC = [[EnrolStudentHomeVC alloc] init];
            [self umengEvent:@"babyJoinCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 17:
            baseVC = [[AddressBooksViewController alloc] init];
            [self umengEvent:@"messageCount" attributes:@{@"name":@"iphone"} number:@(1)];
            baseVC.title = @"通讯录";
            break;
        case 18:
            baseVC = [[SpCourseHomeVC alloc] init];
            break;
        case 19:
            [self loadMoreFunMenu:sender];
            [self umengEvent:@"interactCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 20:
//              baseVC = [[EZCameraListViewController alloc] init];
//            [self umengEvent:@"shipingCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
   
        default:
            break;
    }
    if(baseVC)
    {
        [self.navigationController pushViewController:baseVC animated:YES];
    }
}

#pragma mark - UM 点击统计
- (void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number
{
    NSString * numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}

#pragma mark - 更多按钮点击
- (void)loadMoreFunMenu:(UIButton *)sender
{
    if(!popupView)
    {
        popupView = [[PopupView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, KGSCREEN.size.width, KGSCREEN.size.height)];
        popupView.alpha = Number_Zero;
        
        NSArray * moreMenuArray = [KGHttpService sharedService].dynamicMenuArray;
        NSInteger totalRow = ([moreMenuArray count] + Number_Four - Number_One) / Number_Four;
        CGFloat moreViewH = (totalRow * 77) + 64;
        CGFloat moreViewY = KGSCREEN.size.height - moreViewH;
        
        MoreMenuView * moreVC = [[MoreMenuView alloc] initWithFrame:CGRectMake(Number_Zero, moreViewY, KGSCREEN.size.width, moreViewH)];
        [popupView addSubview:moreVC];
        [moreVC loadMoreMenu:moreMenuArray];
        moreVC.MoreMenuBlock = ^(DynamicMenuDomain * domain)
        {
            [self didSelectedMoreMenuItem:domain];
        };
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:popupView];
    }
    
    [UIView viewAnimate:^{
        popupView.alpha = Number_One;
    } time:Number_AnimationTime_Five];
}

- (void)didSelectedMoreMenuItem:(DynamicMenuDomain *)domain
{
    [self popupCallback];
    
    if(domain)
    {
        BrowseURLViewController * vc = [[BrowseURLViewController alloc] init];
        vc.title = domain.name;
        vc.url = domain.url;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)popupCallback
{
    [UIView viewAnimate:^
    {
        popupView.alpha = Number_Zero;
    } time:Number_AnimationTime_Five];
}




//验证不通过允许进入
- (void)notAllowedEntner{
    
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[KGNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    //
    //    self.rootViewController  = [[KGNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    //    [self makeKeyAndVisible];
    
}
//验证通过允许进入
- (void)allowedEntner{
//    [GuidePageController firstLaunch];
    [self initDataByUserLoginAfter];
    //    [self makeKeyAndVisible];
    
    
}
//第三方登录
- (void)autoLoginThirdAccessToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *access_token=[defaults objectForKey:KEY_thirdLogin_access_token];
    NSString *type=[defaults objectForKey:KEY_thirdLogin_type];
    
    if(access_token.length>0&&type.length>0){
        [self userinfo_thirdLogin:access_token type:type];
    }
    
    [self notAllowedEntner];
}

/**
 access_token
 String
 是
 票据
 type
 String
 是
 取值:qq, weixin
 */
- (void)userinfo_thirdLogin: (NSString *)access_token type:(NSString *)type{
    
    NSDictionary *  dic=@{@"access_token":access_token,@"type":type};
    NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/userinfo/thirdLogin.json"];
    //    [[KGHUD sharedHud] show:self.rootViewController.view msg:@"登录中..."];
    
    [[KGHttpService sharedService] postByDicByParams:url param:dic success:^(id success) {
        //        [[KGHUD sharedHud] hide:self.rootViewController.view];
        LoginRespDomain *loginRespDomain = [LoginRespDomain objectWithKeyValues:success];
        [KGHttpService sharedService].loginRespDomain = loginRespDomain;
        [KGHttpService sharedService].userinfo=loginRespDomain.userinfo;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:loginRespDomain.JSESSIONID forKey:Key_loginJessionID];
        [defaults setObject:type forKey:KEY_thirdLogin_type];
        [defaults setObject:access_token forKey:KEY_thirdLogin_access_token];
        [defaults synchronize];
        
        [self allowedEntner];
        
        
        
    } failed:^(NSString *errorMsg) {
        //        [[KGHUD sharedHud] hide:self.rootViewController.view];
        [self notAllowedEntner];
        
    }];
    
    
    
    
}
#pragma mark - 自动登录
- (void)autoLoginJessionid
{
    
    
    
       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * jid =  [defaults objectForKey:Key_loginJessionID];
    NSLog(@"local jessionid %@",jid);
    
    if(jid<1){
        
        [self autoLoginThirdAccessToken];
        return;
    }
       //已经登录
    LoginRespDomain *loginRespDomain=[KGHttpService sharedService].loginRespDomain;
        if([jid isEqualToString:loginRespDomain.JSESSIONID]){
             [self allowedEntner];
            return;
        }
    {
        //        [[KGHUD sharedHud] show: self.rootViewController];
        
        
        [[KGHttpService sharedService] cheakUserJessionID:jid success:^(NSString *msgStr)
         {
             
             //             [ [KGHUD sharedHud] hide:  self.rootViewController ];
             
             if ([msgStr isEqualToString:@"success"])
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    [self allowedEntner];
                                });
             }
             else
             {
                 [self autoLoginThirdAccessToken];
             }
             
         }faild:^(NSString *errorMsg)
         {
             [self autoLoginThirdAccessToken];
         }];
    }
}

@end
