//
//  GiftwareArticlesInfoViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/31.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "GiftwareArticlesInfoViewController.h"
#import "KGHUD.h"
#import "KGHttpService.h"
#import "ReplyListViewController.h"
#import "ShareViewController.h"
#import "UIView+Extension.h"
#import "PopupView.h"
#import "FavoritesDomain.h"
#import "KGDateUtil.h"
#import "UMSocial.h"
#import "SystemShareKey.h"
#import "MBProgressHUD+HM.h"

#define RemoveHUDNotification @"RemoveHUD"

@interface GiftwareArticlesInfoViewController () <UIWebViewDelegate> {
    
    IBOutlet UIScrollView *contentScrollView;
    IBOutlet UIWebView * myWebView;

    IBOutlet UIImageView * dzImageView;
    IBOutlet UIButton *dzBtn;
    
    IBOutlet UIImageView *favImageView;
    IBOutlet UIButton *favBtn;
    PopupView * popupView;
    ShareViewController * shareVC;
    AnnouncementDomain * announcementDomain;
    
}

@property (strong, nonatomic) NSString * urlStr;

@end

@implementation GiftwareArticlesInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文章详情";
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.opaque = NO;
    contentScrollView.scrollEnabled = NO;
    myWebView.scrollView.scrollEnabled = YES;
    
    myWebView.delegate = self;
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

#pragma mark - 精品文章详情，点赞收藏信息
- (void)getArticlesInfo
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getArticlesInfo:_annuuid success:^(AnnouncementDomain *announcementObj)
    {
        announcementDomain = announcementObj;
        self.urlStr = announcementDomain.share_url;
        [[KGHUD sharedHud] hide:self.view];
        [self resetViewParam];
    }
    faild:^(NSString *errorMsg)
    {
    }];
}

- (void)resetViewParam {
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
    if(announcementDomain.dianzan && !announcementDomain.dianzan.canDianzan) {
        dzImageView.image = [UIImage imageNamed:@"zan2"];
        dzBtn.selected = YES;
    }
    
    if(!announcementDomain.isFavor) {
        favImageView.image = [UIImage imageNamed:@"shoucang2"];
        favBtn.selected = YES;
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
    }
}

//保存点赞
- (void)savwDZ:(UIButton *)sender {
    [[KGHUD sharedHud] show:self.view];
    sender.enabled = NO;
    
    if (announcementDomain.uuid == nil)
    {
        sender.enabled = YES;
        [MBProgressHUD showError:@"现在还不能点赞呢,请稍后再试"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
            [[KGHUD sharedHud] hide:self.view];
        });
        return;
    }
    [[KGHttpService sharedService] saveDZ:announcementDomain.uuid type:Topic_Articles success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];

        dzImageView.image = [UIImage imageNamed:@"zan2"];
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

        dzImageView.image = [UIImage imageNamed:@"zan1"];
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
    domain.type  = Topic_Articles;
    domain.reluuid = announcementDomain.uuid;
    domain.createtime = [KGDateUtil presentTime];
    button.enabled = NO;
    
    if (announcementDomain.title == nil)
    {
        [MBProgressHUD showError:@"现在还不能收藏哦,请稍后再试"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
           [[KGHUD sharedHud] hide:self.view];
        });
        return;
    }
    
    
    [[KGHttpService sharedService] saveFavorites:domain success:^(NSString *msgStr) {
        favImageView.image = [UIImage imageNamed:@"shoucang2"];
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
        favImageView.image = [UIImage imageNamed:@"shoucang1"];
    } failed:^(NSString *errorMsg) {
        button.enabled = YES;
        button.selected = !button.selected;
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 重新设置webview contentsize
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    myWebView.scrollView.contentSize = CGSizeMake(0, myWebView.scrollView.contentSize.height + 100);
}

#pragma mark - 最新通过url加载webview数据
- (void)lazyUrlExc
{
    [[KGHUD sharedHud] hide:self.view];
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

@end
