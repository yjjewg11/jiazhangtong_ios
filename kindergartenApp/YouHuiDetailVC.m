//
//  YouHuiDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGHUD.h"
#import "KGHttpService.h"
#import "YouHuiDetailVC.h"
#import "ShareViewController.h"
#import "PopupView.h"
#import "ReplyListViewController.h"
#import "KGDateUtil.h"
#import "AnnouncementDomain.h"

#import "HLActionSheet.h"
#import "UMSocial.h"
#import "SystemShareKey.h"

@interface YouHuiDetailVC () <UIWebViewDelegate,UIActionSheetDelegate,UMSocialUIDelegate>
{
    PopupView * popupView;
    ShareViewController * shareVC;
    AnnouncementDomain * announcementDomain;
    
    __weak IBOutlet UIButton *dianZanBtn;
    __weak IBOutlet UIButton *shouCangBtn;
    
    __weak IBOutlet UIImageView *dianZanImg;
    __weak IBOutlet UIImageView *shouCangImg;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString * urlStr;
@property (strong, nonatomic) NSString * tels;
@property (strong, nonatomic) NSArray * telsNum;

@end

@implementation YouHuiDetailVC

- (NSArray *)telsNum
{
    if (_telsNum == nil)
    {
        _telsNum = [NSArray array];
    }
    return _telsNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动详情";
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.scrollView.scrollEnabled = YES;
    
    self.webView.delegate = self;
    
    [self getArticlesInfo];//获取精品文章详情
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (announcementDomain) {
        [[KGHUD sharedHud] show:self.view];
        [self performSelector:@selector(lazyUrlExc) withObject:self afterDelay:1.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 优惠活动详情，点赞收藏信息
- (void)getArticlesInfo
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getYouHuiInfo:self.uuid success:^(AnnouncementDomain *announcementObj)
    {
        announcementDomain = announcementObj;
        self.urlStr = announcementDomain.share_url;
        self.tels = announcementDomain.link_tel;
        [[KGHUD sharedHud] hide:self.view];
        [self resetViewParam];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view msg:errorMsg];
    }];
}

- (void)resetViewParam
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
    if(announcementDomain.dianzan && !announcementDomain.dianzan.canDianzan)
    {
        dianZanImg.image = [UIImage imageNamed:@"zan2"];
        dianZanBtn.selected = YES;
    }
    
    if(!announcementDomain.isFavor)
    {
        shouCangImg.image = [UIImage imageNamed:@"shoucang2"];
        shouCangBtn.selected = YES;
    }
}


- (IBAction)articlesFunBtnClicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
            //赞
            if (sender.selected == YES) {
                [self delDZ:sender];
            }else{
                [self savwDZ:sender];
            }
            break;
        case 11: {
            //分享
            [self shareClicked];
            break;
        }
        case 12:
            //收藏
            if (sender.selected == YES) {
                [self delFavorites:sender];
            }else{
                [self saveFavorites:sender];
            }
            break;
        case 13: {
            //评论
            ReplyListViewController * baseVC = [[ReplyListViewController alloc] init];
            baseVC.topicUUID = announcementDomain.uuid;
            [self.navigationController pushViewController:baseVC animated:YES];
            break;
        }
        case 14: {
            
            self.tels = [self.tels stringByReplacingOccurrencesOfString:@"/" withString:@","];
            
            self.telsNum = [self.tels componentsSeparatedByString:@","];
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"为您查询到如下联系号码" delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            
            for (NSString * str in self.telsNum)
            {
                [sheet addButtonWithTitle:str];
            }
            
            [sheet showInView:self.view];
            
            break;
        }
    }
}

#pragma mark - actionsheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
       NSString * uuid = self.uuid;
       
       //调用接口保存用户信息
       [[KGHttpService sharedService] saveTelUserDatas:uuid type:@"85" success:^(NSString *msg)
       {
            
       }
       faild:^(NSString *errorMsg)
       {
           NSLog(@"保存咨询信息失败");
       }];
       
    });
    
    NSString *callString = [NSString stringWithFormat:@"tel://%@",self.telsNum[buttonIndex-1]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callString]];
}

//保存点赞
- (void)savwDZ:(UIButton *)sender
{
    [[KGHUD sharedHud] show:self.view];
    sender.enabled = NO;
    [[KGHttpService sharedService] saveDZ:announcementDomain.uuid type:Topic_YHHD success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
        
        dianZanImg.image = [UIImage imageNamed:@"zan2"];
        sender.selected = !sender.selected;
        sender.enabled = YES;
    } faild:^(NSString *errorMsg) {
        sender.enabled = YES;
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

//取消点赞
- (void)delDZ:(UIButton *)sender
{
    [[KGHUD sharedHud] show:self.view];
    
    sender.enabled = NO;
    [[KGHttpService sharedService] delDZ:announcementDomain.uuid success:^(NSString *msgStr)
     {
         [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
         
         dianZanImg.image = [UIImage imageNamed:@"zan1"];
         sender.selected = !sender.selected;
         sender.enabled = YES;
     } faild:^(NSString *errorMsg) {
         sender.enabled = YES;
         [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
         
     }];
}


//分享
- (void)shareClicked
{
    AnnouncementDomain * domain = [[AnnouncementDomain alloc] init];
    
    domain.share_url = announcementDomain.share_url;
    domain.title = self.title;
    
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
                 pasteboard.string = domain.share_url;
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
- (void)handelShareWithShareType:(NSString *)shareType domain:(AnnouncementDomain *)domain
{
    NSString * contentString = domain.title;
    
    NSString * shareurl = domain.share_url;
    
    if(!shareurl || [shareurl length] == 0)
    {
        shareurl = @"http://wenjie.net";
    }
    
    //微信title设置方法：
    [UMSocialData defaultData].extConfig.wechatSessionData.title = domain.title;
    
    //朋友圈title设置方法：
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = domain.title;
    [UMSocialWechatHandler setWXAppId:ShareKey_WeChat appSecret:ShareKey_WeChatSecret url:domain.share_url];
    [UMSocialData defaultData].extConfig.qqData.title = domain.title;
    [UMSocialData defaultData].extConfig.qqData.url = domain.share_url;
    
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

//保存收藏
- (void)saveFavorites:(UIButton *)button
{
    [[KGHUD sharedHud] show:self.view];
    
    FavoritesDomain * domain = [[FavoritesDomain alloc] init];
    domain.title = announcementDomain.title;
    domain.type  = Topic_YHHD;
    domain.reluuid = announcementDomain.uuid;
    domain.createtime = [KGDateUtil presentTime];
    button.enabled = NO;
    
    [[KGHttpService sharedService] saveFavorites:domain success:^(NSString *msgStr) {
        shouCangImg.image = [UIImage imageNamed:@"shoucang2"];
        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
        button.selected = !button.selected;
        button.enabled = YES;
    } faild:^(NSString *errorMsg) {
        button.selected = !button.selected;
        button.enabled = YES;
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

//取消收藏
- (void)delFavorites:(UIButton *)button{
    [[KGHUD sharedHud] show:self.view];
    button.enabled = NO;
    [[KGHttpService sharedService] delFavorites:announcementDomain.uuid success:^(NSString *msgStr) {
        button.selected = !button.selected;
        button.enabled = YES;
        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
        shouCangImg.image = [UIImage imageNamed:@"shoucang1"];
    } failed:^(NSString *errorMsg) {
        button.enabled = YES;
        button.selected = !button.selected;
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 点赞相关


#pragma mark - 重新设置webview contentsize
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.scrollView.contentSize = CGSizeMake(0, self.webView.scrollView.contentSize.height + 100);
}

#pragma mark - 最新通过url加载webview数据
- (void)lazyUrlExc
{
    [[KGHUD sharedHud] hide:self.view];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

@end
