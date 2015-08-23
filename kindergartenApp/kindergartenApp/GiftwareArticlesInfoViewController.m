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

#define RemoveHUDNotification @"RemoveHUD"

@interface GiftwareArticlesInfoViewController () <UIWebViewDelegate> {
    
    IBOutlet UIScrollView *contentScrollView;
    IBOutlet UILabel * titleLabel;
    IBOutlet UIWebView * myWebView;
    IBOutlet UILabel * createUserLabel;
    IBOutlet UILabel * timeLabel;
    IBOutlet UIView * bottomFunView;
    IBOutlet UIImageView * dzImageView;
    IBOutlet UIButton *dzBtn;
    
    IBOutlet UIImageView *favImageView;
    IBOutlet UIButton *favBtn;
    PopupView * popupView;
    ShareViewController * shareVC;
    AnnouncementDomain * announcementDomain;
}

@end

@implementation GiftwareArticlesInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文章详情";
    
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.opaque = NO;
    myWebView.scrollView.scrollEnabled = NO;
    myWebView.delegate = self;
    [self getArticlesInfo];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (announcementDomain) {
        [[KGHUD sharedHud] show:self.view];
        [self performSelector:@selector(lazyEx) withObject:self afterDelay:1.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getArticlesInfo {
    
    [[KGHttpService sharedService] getArticlesInfo:_annuuid success:^(AnnouncementDomain *announcementObj) {
        
        announcementDomain = announcementObj;
        [self resetViewParam];
        
    } faild:^(NSString *errorMsg) {
        
    }];
}

- (void)resetViewParam {
    titleLabel.text = announcementDomain.title;
    
    announcementDomain.message = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>",announcementDomain.message];
    
    [myWebView loadHTMLString:announcementDomain.message baseURL:nil];
    timeLabel.text = announcementDomain.create_time;
    createUserLabel.text = announcementDomain.create_user;
    
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
    [[KGHUD sharedHud] show:self.contentView];
    sender.enabled = NO;
    [[KGHttpService sharedService] saveDZ:announcementDomain.uuid type:Topic_Articles success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        dzImageView.image = [UIImage imageNamed:@"zan2"];
        sender.selected = !sender.selected;
        sender.enabled = YES;
    } faild:^(NSString *errorMsg) {
        sender.enabled = YES;
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}

//取消点赞
- (void)delDZ:(UIButton *)sender{
    [[KGHUD sharedHud] show:self.contentView];
    sender.enabled = NO;
    [[KGHttpService sharedService] delDZ:announcementDomain.uuid success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        dzImageView.image = [UIImage imageNamed:@"zan1"];
        sender.selected = !sender.selected;
        sender.enabled = YES;
    } faild:^(NSString *errorMsg) {
        sender.enabled = YES;
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}


//分享
- (void)shareClicked {
    if(!popupView) {
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
- (void)saveFavorites:(UIButton *)button {
    [[KGHUD sharedHud] show:self.contentView];
    
    FavoritesDomain * domain = [[FavoritesDomain alloc] init];
    domain.title = announcementDomain.title;
    domain.type  = Topic_Articles;
    domain.reluuid = announcementDomain.uuid;
    domain.createtime = [KGDateUtil presentTime];
    button.enabled = NO;
    [[KGHttpService sharedService] saveFavorites:domain success:^(NSString *msgStr) {
        favImageView.image = [UIImage imageNamed:@"shoucang2"];
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        button.selected = !button.selected;
        button.enabled = YES;
    } faild:^(NSString *errorMsg) {
        button.selected = !button.selected;
        button.enabled = YES;
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}

//取消收藏
- (void)delFavorites:(UIButton *)button{
    [[KGHUD sharedHud] show:self.contentView];
    button.enabled = NO;
    [[KGHttpService sharedService] delFavorites:announcementDomain.uuid success:^(NSString *msgStr) {
        button.selected = !button.selected;
        button.enabled = YES;
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        favImageView.image = [UIImage imageNamed:@"shoucang1"];
    } failed:^(NSString *errorMsg) {
        button.enabled = YES;
        button.selected = !button.selected;
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[KGHUD sharedHud] show:self.view];
    [self performSelector:@selector(lazyEx) withObject:self afterDelay:0.5];
}

#pragma mark - 延迟执行
- (void)lazyEx{
    
    [[KGHUD sharedHud] hide:self.view];
    
    //获取页面高度（像素）
    NSString * clientheight_str = [myWebView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    myWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [myWebView sizeThatFits:myWebView.frame.size];
    //获取内容实际高度（像素）
    NSString * height_str= [myWebView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    myWebView.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.view.frame.size.width, height);
    
    
    createUserLabel.y = CGRectGetMaxY(myWebView.frame) + Number_Ten;
    createUserLabel.x = KGSCREEN.size.width - createUserLabel.width - CELLPADDING;
    timeLabel.y = CGRectGetMaxY(createUserLabel.frame) + Number_Ten;
    timeLabel.x = KGSCREEN.size.width - timeLabel.width - CELLPADDING;
    contentScrollView.contentSize = CGSizeMake(KGSCREEN.size.width, timeLabel.height + timeLabel.y + CELLPADDING);
}

@end
