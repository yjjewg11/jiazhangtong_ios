//
//  DiscorveryWebVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/14.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "DiscorveryWebVC.h"
#import "UMSocial.h"
#import "ShareDomain.h"
#import "KGHttpService.h"
#import "KGHttpUrl.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "ZYQAssetPickerController.h"
#import <WebKit/WebKit.h>


@interface DiscorveryWebVC () <UIWebViewDelegate,UMSocialUIDelegate,TestJSExport,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>
{
    JSContext * _context;
    UIActionSheet * _myActionSheet;
    UIWebView * _webView;
    
    NSString * _jsessionId;
}

@end

@implementation DiscorveryWebVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.view.frame = self.webViewFrame;
    
    _webView = [[UIWebView alloc] init];
    
    _webView.frame = self.webViewFrame;
    
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    
    _webView.scrollView.bounces = NO;
    
    _webView.delegate = self;
    
    [self.view addSubview:_webView];
}

#pragma mark - 加载地址
/**
 *  加载url
 *
 *  @param url          url
 *  @param cookieDomain default nil value is @""
 *  @param cookiePath   default nil value is @"/"
 */
- (void)loadWithCookieSettingsUrl:(NSString *)url cookieDomain:(NSString *)cookieDomain path:(NSString *)cookiePath
{
    if (cookieDomain == nil)
    {
        cookieDomain = @"";
    }
    
    if (cookiePath == nil)
    {
        cookiePath = @"/";
    }
    
    NSArray * nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    // 设置header，通过遍历cookies来一个一个的设置header
    for (NSHTTPCookie *cookie in nCookies)
    {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:cookie.properties];
        
        [dict setValue:cookiePath forKey:@"Path"];
        [dict setValue:cookieDomain forKey:@"Domain"];
        
        NSHTTPCookie * ck = [NSHTTPCookie cookieWithProperties:dict];
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:@[ck]
                                                           forURL:[NSURL URLWithString:url]
                                                  mainDocumentURL:nil];
    }
    
    [self showLoadView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)clearWebViewContent
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]];
    
    [_webView loadRequest:request];
}

#pragma mark - 获取url中的主机地址
/**
 *  通过url取主机
 *
 *  @param url url
 *
 *  @return cutted url
 */
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

#pragma mark - webview代理
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
    
//     以 block 形式关联 JavaScript function
//    _context[@"setShareContent"] =
//    ^(NSString *title,NSString * content,NSString *pathurl,NSString *httpurl)
//    {
//        NSLog(@"aaaa");
//    };
//
//    // 以 block 形式关联 JavaScript function
//    self.context[@"alert"] =
//    ^(NSString *str)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"msg from js" message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert show];
//    };
//
//    __block typeof(self) weakSelf = self;
//    self.context[@"addSubView"] =
//    ^(NSString *viewname)
//    {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 500, 300, 100)];
//        view.backgroundColor = [UIColor redColor];
//        UISwitch *sw = [[UISwitch alloc]init];
//        [view addSubview:sw];
//        [weakSelf.view addSubview:view];
//    };
    
    [self hidenLoadView];
}

- (void)finishProject:(NSString *)url
{
    _context = nil;
    _myActionSheet = nil;
    _webView = nil;
    
    NSNotification * no = [[NSNotification alloc] initWithName:@"deallocwebview" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:no];
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
    
    domain.content = content;
    
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
    
    [UMSocialSnsService presentSnsController:self appKey:@"55be15a4e0f55a624c007b24" shareText:domain.content shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:domain.pathurl]]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil] delegate:self];
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
        
        [_webView stringByEvaluatingJavaScriptFromString:imgJs];
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
        
        [_webView stringByEvaluatingJavaScriptFromString:imgJs];
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

- (void)dealloc
{
    NSLog(@"dealloc --- ");
    _context = nil;
    _jsessionId = nil;
    _webView = nil;
    _myActionSheet = nil;
}

@end
