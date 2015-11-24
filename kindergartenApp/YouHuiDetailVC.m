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

@interface YouHuiDetailVC () <UIWebViewDelegate,UIActionSheetDelegate>
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
    
    if(announcementDomain.dianzan && !announcementDomain.dianzan.canDianzan) {
        dianZanImg.image = [UIImage imageNamed:@"zan2"];
        dianZanBtn.selected = YES;
    }
    
    if(!announcementDomain.isFavor) {
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
- (void)savwDZ:(UIButton *)sender {
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
    if(!popupView)
    {
        popupView = [[PopupView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, KGSCREEN.size.width, KGSCREEN.size.height)];
        popupView.alpha = Number_Zero;
        
        CGFloat height = 140;
        shareVC = [[ShareViewController alloc] init];
        shareVC.view.frame = CGRectMake(Number_Zero,  KGSCREEN.size.height-height, KGSCREEN.size.width, height);
        [popupView addSubview:shareVC.view];
        [self.view addSubview:popupView];
        [self addChildViewController:shareVC];
    }
    shareVC.announcementDomain = announcementDomain;
    [UIView viewAnimate:^{
        popupView.alpha = Number_One;
    } time:Number_AnimationTime_Five];
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
