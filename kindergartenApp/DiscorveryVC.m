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
#import "KGNavigationController.h"
#import "ZYQAssetPickerController.h"
#import "UMSocial.h"
#import "ShareDomain.h"
#import "HLActionSheet.h"

#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import <objc/message.h>

@interface DiscorveryVC () <UICollectionViewDataSource,UICollectionViewDelegate,DiscorveryTypeCellDelegate,UIScrollViewDelegate,UIWebViewDelegate,TuiJianCellDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UMSocialUIDelegate,TestJSExport,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>
{
    NSString * _jsessionId;
    
    UIActionSheet * _myActionSheet;
    
    JSContext * _context;
    
    UICollectionView * _collectionView;
    
    UIWebView * _webview;
    
    DiscorveryMeiRiTuiJianDomain * _tuijianDomain;
    
    NSMutableArray * _remenjingxuanData;
    
    DiscorveryNewNumberDomain * _numberDomain;
    
    DiscorveryHomeLayout * _layOut;
    
    NSMutableArray * _haveReMenJingXuanPic;
    
    BOOL _canReqData;
    
    NSInteger _pageNo;

    NSTimer *_timer;	// 用于UIWebView保存图片
    int _gesState;	  // 用于UIWebView保存图片
    NSString *_imgURL;  // 用于UIWebView保存图片
    BOOL longPress;
}

@property (strong, nonatomic) NSString * groupuuid;

@property (assign, nonatomic) NSInteger sheetType;  //标记打开的actionsheet是否可以识别二维码

@end

@implementation DiscorveryVC

//js注入用
static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";

// 用于UIWebView保存图片
enum
{
    GESTURE_STATE_NONE = 0,
    GESTURE_STATE_START = 1,
    GESTURE_STATE_MOVE = 2,
    GESTURE_STATE_END = 4,
    GESTURE_STATE_ACTION = (GESTURE_STATE_START | GESTURE_STATE_END),
};

static NSString *const TypeColl = @"typecoll";
static NSString *const TuiJianColl= @"tuijiancoll";
static NSString *const TopicColl = @"topiccoll";
static NSString *const Nodata = @"nodata";

- (void)tryBtnClicked
{
    [self getTuiJianData];
    
    [self initCollectionView];
    
    [self initWebView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSNotification * no = [[NSNotification alloc] initWithName:@"homerefreshnum" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:no];
    
    if (_webview.hidden == NO)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
}

- (void)initWebView
{
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 64)];
    
    _webview.delegate = self;
    
    _webview.scrollView.bounces = NO;
    
    _webview.scrollView.showsHorizontalScrollIndicator = NO;
    
    _webview.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_webview];
    
    _webview.hidden = YES;
}

#pragma mark - webview dele
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _context = [[JSContext alloc] init];
    
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //打印异常
    _context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"异常:%@", exceptionValue);
    };
    
    //以 JSExport 协议关联 native 的方法
    _context[@"JavaScriptCall"] = self;
    
    [self hidenLoadView];
    _webview.hidden = NO;
    
    //下面是二维码相关
    // 当iOS版本大于7时，向下移动20dp
    // 防止内存泄漏
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    // 响应touch事件，以及获得点击的坐标位置，用于保存图片
    [_webview stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
    
    [_webview stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [_webview stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
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
    
    [self initWebView];
    
    //这个通知用于更新 消息数目提示
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateNumData) name:@"updateNumData" object:nil];
    
    //二维码长按手势
    UILongPressGestureRecognizer *longtapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longtap:)];
    
    [_webview addGestureRecognizer:longtapGesture];
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
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            self.navigationController.navigationBarHidden = YES;
            
             NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
             NSString * url = [defu objectForKey:@"sns_url"];
            
            if ([url isEqualToString:@""])
            {
                return;
            }
            else
            {
                _collectionView.hidden = YES;
                
                [self showLoadView];
                
                NSMutableDictionary * cookieDic = [NSMutableDictionary dictionary];
                [cookieDic setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
                [cookieDic setObject:[KGHttpService sharedService].loginRespDomain.JSESSIONID forKey:NSHTTPCookieValue];
                [cookieDic setObject:@"/" forKey:NSHTTPCookiePath];
                [cookieDic setObject:[self cutUrlDomain:url] forKey:NSHTTPCookieDomain];
                NSHTTPCookie * cookieUser = [NSHTTPCookie cookieWithProperties:cookieDic];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieUser];
                
                [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            }
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

#pragma mark - 每日推荐代理
- (void)openTuiJianWebView:(NSString *)url
{
    if (_tuijianDomain.url == nil || [_tuijianDomain.url isEqualToString:@""])
    {
        return;
    }
    else
    {
        _collectionView.hidden = YES;
        
        [self showLoadView];
        
        NSMutableDictionary * cookieDic = [NSMutableDictionary dictionary];
        [cookieDic setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
        [cookieDic setObject:[KGHttpService sharedService].loginRespDomain.JSESSIONID forKey:NSHTTPCookieValue];
        [cookieDic setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieDic setObject:[self cutUrlDomain:url] forKey:NSHTTPCookieDomain];
        NSHTTPCookie * cookieUser = [NSHTTPCookie cookieWithProperties:cookieDic];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieUser];
        
        [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
        [[KGHttpService sharedService] meiRiJingXuanHuiDiao:^(NSString *data)
        {
            
        }
        faild:^(NSString *errorMsg)
        {
            NSLog(@"每日推荐回调失败 + %@",errorMsg);
        }];
    }
}

#pragma mark - 点击跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    
    if (indexPath.row >= 2)
    {
        DiscorveryReMenJingXuanDomain * domain = _remenjingxuanData[indexPath.row - 2];
        
        NSString * url = domain.webview_url;
        
        if (url == nil || [url isEqualToString:@""])
        {
            return;
        }
        else
        {
            _collectionView.hidden = YES;
            
            NSMutableDictionary * cookieDic = [NSMutableDictionary dictionary];
            [cookieDic setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
            [cookieDic setObject:[KGHttpService sharedService].loginRespDomain.JSESSIONID forKey:NSHTTPCookieValue];
            [cookieDic setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieDic setObject:[self cutUrlDomain:url] forKey:NSHTTPCookieDomain];
            NSHTTPCookie * cookieUser = [NSHTTPCookie cookieWithProperties:cookieDic];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieUser];
            [self showLoadView];
            
            [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
    }
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    DiscorveryHomeLayout *layout = [[DiscorveryHomeLayout alloc] init];
    
    _layOut = layout;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49) collectionViewLayout:layout];
    
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
             _collectionView.footerRefreshingText = @"没有更多了...";
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
         [_collectionView footerEndRefreshing];
     }];
}

- (NSString *)cutUrlDomain:(NSString *)url
{
    NSMutableString * tempurl = [[NSMutableString alloc] initWithString:url];
    
    NSString * myUrl = [tempurl componentsSeparatedByString:@"//"][1];
    NSString * secondUrl = [myUrl componentsSeparatedByString:@"/"][0];
    
    NSString * domain = nil;
    
    if ([secondUrl rangeOfString:@":"].location != NSNotFound)
    {
        domain = [secondUrl componentsSeparatedByString:@":"][0];
    }
    else
    {
        domain = secondUrl;
    }
    
    return domain;
}

#pragma mark - js调用方法
- (void)finishProject:(NSString *)url
{
    //防止键盘没有弹回就调用js导致崩溃的bug
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_webview endEditing:YES];
    });
    
    // 这段代码要放到主线程中去 否则会出现This application is modifying the autolayout engine from a background thread
    dispatch_async(dispatch_get_main_queue(), ^
    {
        _collectionView.hidden = NO;
        _webview.hidden = YES;
        _context = nil;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.navigationController.navigationBarHidden = NO;
    });
}

- (void)jsessionToPhone:(NSString *)id
{
    _jsessionId = id;
}

- (NSString *)getJsessionid:(NSString *)id
{
    return [KGHttpService sharedService].loginRespDomain.userinfo.uuid;
}

#pragma mark - 分享的js
- (void)setShareContent:(NSString *)title content:(NSString *)content pathurl:(NSString *)pathurl httpurl:(NSString *)httpurl
{
    //防止键盘没有弹回就调用js导致崩溃的bug
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_webview endEditing:YES];
    });
    
    ShareDomain * domain = [[ShareDomain alloc] init];
    
    domain.title = title;
    
    domain.pathurl = pathurl;
    
    domain.httpurl = httpurl;
    
    domain.content = title;
    
    if (domain.title == nil)
    {
        domain.title = @"";
    }
    
    NSArray *titles = @[@"微博",@"微信",@"朋友圈",@"QQ好友",@"复制链接"];
    NSArray *imageNames = @[@"xinlang",@"weixin",@"pyquan",@"QQ",@"fuzhilianjie"];
    HLActionSheet *sheet = [[HLActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    
    [sheet showActionSheetWithClickBlock:^(NSInteger btnIndex)
     {
         switch (btnIndex)
         {
             case 0:
             {
                 [self handelShareWithShareType:UMShareToSina domain:domain];
             }
                 break;
                 
             case 1:
             {
                 [self handelShareWithShareType:UMShareToWechatSession domain:domain];
             }
                 break;
                 
             case 2:
             {
                 [self handelShareWithShareType:UMShareToWechatTimeline domain:domain];
             }
                 break;
                 
             case 3:
             {
                 [self handelShareWithShareType:UMShareToQQ domain:domain];
             }
                 break;
                 
             case 4:
             {
                 UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
                 pasteboard.string = domain.httpurl;
                 //提示复制成功
                 UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已复制分享链接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 [av show];
             }
                 break;
                 
             default:
                 break;
         }
     }
     cancelBlock:^
     {
         NSLog(@"取消");
     }];
}

#pragma mark - 处理分享操作
- (void)handelShareWithShareType:(NSString *)shareType domain:(ShareDomain *)domain
{
    NSString * contentString = domain.title;
    
    NSString * shareurl = domain.httpurl;
    
    if(!shareurl || [shareurl length] == 0)
    {
        shareurl = @"www.wenjienet.com";
    }
    
    //微信title设置方法：
    [UMSocialData defaultData].extConfig.wechatSessionData.title = domain.title;
    
    //朋友圈title设置方法：
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = domain.title;
    [UMSocialWechatHandler setWXAppId:@"wx6699cf8b21e12618" appSecret:@"639c78a45d012434370f4c1afc57acd1" url:domain.httpurl];
    [UMSocialData defaultData].extConfig.qqData.title = domain.title;
    [UMSocialData defaultData].extConfig.qqData.url = domain.httpurl;
    
    if (shareType == UMShareToSina)
    {
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",contentString,shareurl];
        [UMSocialData defaultData].extConfig.sinaData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:shareurl];
    }
    
    //设置分享内容，和回调对象
    [[UMSocialControllerService defaultControllerService] setShareText:contentString shareImage:[UIImage imageNamed:@"jiazhang_180"] socialUIDelegate:self];
    
    UMSocialSnsPlatform * snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareType];
    
    snsPlatform.snsClickHandler(self, [UMSocialControllerService defaultControllerService],YES);
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    UIAlertView * alertView;
    NSString * string;
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        string = @"分享成功";
    }
    else if (response.responseCode == UMSResponseCodeCancel)
    {
    }
    else
    {
        string = @"分享失败";
    }
    if (string && string.length)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)selectImgPic:(NSString *)groupuuid
{
    //防止键盘没有弹回就调用js导致崩溃的bug
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_webview endEditing:YES];
        [self uploadAllImages];
    });
}

- (void)selectHeadPic
{
    //防止键盘没有弹回就调用js导致崩溃的bug
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_webview endEditing:YES];
        
        _myActionSheet = [[UIActionSheet alloc]
                          initWithTitle:nil
                          delegate:self
                          cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                          otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
        
        //设置这个为不能识别二维码的方法
        self.sheetType = 0;
        
        [_myActionSheet showInView:self.view];
    });
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //上传头像调用的
    if (self.sheetType == 0)
    {
        //呼出的菜单按钮点击后的响应
        if (buttonIndex == _myActionSheet.cancelButtonIndex)
        {
            NSLog(@"取消");
        }
        
        switch (buttonIndex)
        {
            case 0:  //打开照相机拍照
                [self takePhoto];
                break;
                
            case 1:  //打开本地相册
                [self LocalPhoto];
                break;
        }
    }
    //识别二维码调用的
    else
    {
        //呼出的菜单按钮点击后的响应
        if (buttonIndex == _myActionSheet.cancelButtonIndex)
        {
            NSLog(@"取消");
        }
        else
        {
            [self recognizeTwoCode];
        }
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//上传头像
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(198.0, 198.0)];
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.5);
        
        //转base64
        NSString * imgBase64Str = [data base64EncodedStringWithOptions:0];
        
        NSString * commitStr = [NSString stringWithFormat:@"%@%@",@"data:image/png;base64,",imgBase64Str];
        
        NSString *imgJs = [NSString stringWithFormat:@"javascript:G_jsCallBack.selectHeadPic_callback('%@')", commitStr];
        
        [_webview stringByEvaluatingJavaScriptFromString:imgJs];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)uploadAllImages
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i=0; i<assets.count; i++)
    {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        //tempImg = [UtilMethod imageWithImageSimple:tempImg scaledToSize:CGSizeMake(120.0, 120.0)];
        NSData *data;
        data = UIImageJPEGRepresentation(tempImg, 0.1);
        
        //转base64
        NSString * imgBase64Str = [data base64EncodedStringWithOptions:0];
        
        NSString * commitStr = [NSString stringWithFormat:@"%@%@",@"data:image/png;base64,",imgBase64Str];
        
        NSString *imgJs = [NSString stringWithFormat:@"javascript:G_jsCallBack.selectPic_callback('%@')", commitStr];
        
        [_webview stringByEvaluatingJavaScriptFromString:imgJs];
    }
}

- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}


#pragma mark - 长按识别二维码功能

#pragma mark - 保存图片用于识别
- (void)recognizeTwoCode
{
    if (_imgURL)
    {
        //            NSLog(@"imgurl = %@", _imgURL);
    }
    
    NSString *urlToSave = [_webview stringByEvaluatingJavaScriptFromString:_imgURL];
    //        NSLog(@"image url = %@", urlToSave);
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
    UIImage* image = [UIImage imageWithData:data];
    
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
    //        NSLog(@"UIImageWriteToSavedPhotosAlbum = %@", urlToSave);
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - 长按保存图片
// 功能：UIWebView响应长按事件
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[_request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"])
    {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            NSLog(@"you are touching!");
            //            NSTimeInterval delaytime = 2;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                _gesState = GESTURE_STATE_START;
                NSLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [_webview stringByEvaluatingJavaScriptFromString:js];
                _imgURL = nil;
                
                if ([tagName isEqualToString:@"IMG"])
                {
                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                }
                //                if (_imgURL && longPress)
                //                {
                //                    _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                //                    longPress = NO;
                //                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                _gesState = GESTURE_STATE_MOVE;
                NSLog(@"you are move");
            }
        }
        else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
            [_timer invalidate];
            _timer = nil;
            _gesState = GESTURE_STATE_END;
            NSLog(@"touch end");
        }
        return NO;
    }
    
    return YES;
}

- (void)handleLongTouch
{
    //    NSLog(@"%@", _imgURL);
    if (_imgURL && _gesState == GESTURE_STATE_START)
    {
        _myActionSheet = nil;
        _myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"识别二维码图片", nil];
        _myActionSheet.cancelButtonIndex = _myActionSheet.numberOfButtons - 1;
        
        self.sheetType = 1;
        
        _gesState = GESTURE_STATE_END;
        
        [_myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

// 功能：显示对话框
-(void)showAlert:(NSString *)msg
{
    //    NSLog(@"showAlert = %@", msg);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}

// 功能：显示图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error)
    {
        [self showAlert:@"出错了..."];
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        
        if (image)
        {
            [LBXScanWrapper recognizeImage:image success:^(NSArray<LBXScanResult *> *array)
            {
                [weakSelf scanResultWithArray:array];
            }];
        }
    }
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self showAlert:@"识别失败了！"];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array)
    {
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    if (strResult.strScanned == nil)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:@"识别失败"];
    }
    else
    {
        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = strResult.strScanned;
        //提示复制成功
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已复制二维码链接到剪贴板,您可以复制到浏览器中打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
    }
}

#pragma mark - 手势长按
- (void)longtap:(UILongPressGestureRecognizer * )longtapGes
{
    if (_imgURL)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self handleLongTouch];
        });
    }
}



@end
