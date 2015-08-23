//
//  ShareViewController.m
//  kindergartenApp
//
//  Created by You on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "ShareViewController.h"
#import "PopupView.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "SystemShareKey.h"
#import "KGHUD.h"

@interface ShareViewController () <UMSocialUIDelegate>

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:Number_ViewAlpha_Five];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)shareBtnClicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
            //微信
            [self handelShareWithShareType:UMShareToWechatSession];
            break;
        case 11:
            //QQ好友
            [self handelShareWithShareType:UMShareToQQ];
            break;
        case 12:
            [self handelShareWithShareType:UMShareToWechatTimeline];
            //朋友圈
            break;
        case 13:
            [self handelShareWithShareType:UMShareToSina];
            //新浪
            break;
    }
}

//处理分享操作
- (void)handelShareWithShareType:(NSString *)shareType{
    
    NSString * contentString = _announcementDomain.title;

    NSString * shareurl = _announcementDomain.share_url;
    if(!shareurl || [shareurl length]==Number_Zero) {
        shareurl = webUrl;
    }
    
//    [[KGHUD sharedHud] show:self.view.superview];
    
    //微信title设置方法：
    [UMSocialData defaultData].extConfig.wechatSessionData.title = _announcementDomain.title;
    //朋友圈title设置方法：
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = _announcementDomain.title;
    [UMSocialWechatHandler setWXAppId:ShareKey_WeChat appSecret:ShareKey_WeChatSecret url:shareurl];
    [UMSocialData defaultData].extConfig.qqData.title = _announcementDomain.title;
    [UMSocialData defaultData].extConfig.qqData.url = shareurl;
    
    //设置分享内容，和回调对象
    [[UMSocialControllerService defaultControllerService] setShareText:contentString shareImage:[UIImage imageNamed:@"jiazhang_180"] socialUIDelegate:self];
    UMSocialSnsPlatform * snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareType];
    snsPlatform.snsClickHandler(self, [UMSocialControllerService defaultControllerService],YES);
}

/**
 关闭当前页面之后
 @param fromViewControllerType 关闭的页面类型
 */
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    [[KGHUD sharedHud] hide:self.view.superview];
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [[KGHUD sharedHud] hide:self.view.superview];
    //根据`responseCode`得到发送结果,如果分享成功
    UIAlertView * alertView;
    NSString * string;
    if(response.responseCode == UMSResponseCodeSuccess){
        string = @"分享成功";
    }else if (response.responseCode == UMSResponseCodeCancel){
    }else{
        string = @"分享失败";
    }
    if (string && string.length) {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    [[KGHUD sharedHud] hide:self.view.superview];
}


- (IBAction)cancelShareBtnClicked:(UIButton *)sender {
    PopupView * view = (PopupView *)self.view.superview;
    [view singleBtnTap];
}



@end
