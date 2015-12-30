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
}

@property (strong, nonatomic) NSString * groupuuid;

@end

@implementation DiscorveryVC

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
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
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
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
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
            
            NSArray * nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            
            // 设置header，通过遍历cookies来一个一个的设置header
            for (NSHTTPCookie *cookie in nCookies)
            {
                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:cookie.properties];
                
                [dict setValue:@"/" forKey:@"Path"];
                [dict setValue:[self cutUrlDomain:url] forKey:@"Domain"];
                
                NSHTTPCookie * ck = [NSHTTPCookie cookieWithProperties:dict];
                
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:@[ck]
                                                                   forURL:[NSURL URLWithString:url]
                                                          mainDocumentURL:nil];
            }
            
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
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 64) collectionViewLayout:layout];
    
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

#pragma mark - 网页使用的方法
- (void)finishProject:(NSString *)url
{
    // 这段代码要放倒gcd中去 否则会出现This application is modifying the autolayout engine from a background thread
    dispatch_async(dispatch_get_main_queue(), ^
    {
        _collectionView.hidden = NO;
        _webview.hidden = YES;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.navigationController.navigationBarHidden = NO;
    });
}

#pragma mark - js调用方法
- (void)jsessionToPhone:(NSString *)id
{
    _jsessionId = id;
}

- (NSString *)getJsessionid:(NSString *)id
{
    return [KGHttpService sharedService].loginRespDomain.userinfo.uuid;
}


- (void)setShareContent:(NSString *)title content:(NSString *)content pathurl:(NSString *)pathurl httpurl:(NSString *)httpurl
{
    ShareDomain * domain = [[ShareDomain alloc] init];
    
    domain.title = title;
    
    domain.pathurl = pathurl;
    
    domain.httpurl = httpurl;
    
    domain.content = title;
    
    //微博
    [UMSocialData defaultData].extConfig.sinaData.urlResource.resourceType = UMSocialUrlResourceTypeImage;
    [UMSocialData defaultData].extConfig.sinaData.shareText = domain.httpurl;
    //微信
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = domain.httpurl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = domain.httpurl;
    //qq
    [UMSocialData defaultData].extConfig.qqData.urlResource.resourceType = UMSocialUrlResourceTypeImage;
    [UMSocialData defaultData].extConfig.qqData.url = domain.httpurl;
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55be15a4e0f55a624c007b24" shareText:domain.content shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:domain.pathurl]]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil] delegate:self];
}

- (void)selectImgPic:(NSString *)groupuuid
{
    [self uploadAllImages];
}

- (void)selectHeadPic
{
    _myActionSheet = [[UIActionSheet alloc]
                      initWithTitle:nil
                      delegate:self
                      cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                      otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [_myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
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


@end
