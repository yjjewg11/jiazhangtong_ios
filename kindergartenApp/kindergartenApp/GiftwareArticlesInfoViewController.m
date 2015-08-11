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

@interface GiftwareArticlesInfoViewController () {
    
    IBOutlet UILabel * titleLabel;
    
    IBOutlet UIWebView * myWebView;
    
    IBOutlet UILabel * createUserLabel;
    
    IBOutlet UILabel * timeLabel;
    
    IBOutlet UIView * bottomFunView;
    
    IBOutlet UIImageView * dzImageView;
    IBOutlet UIButton *dzBtn;
    PopupView * popupView;
    ShareViewController * shareVC;
}

@end

@implementation GiftwareArticlesInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文章详情";
    
    [self getArticlesInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getArticlesInfo {
    
    [[KGHttpService sharedService] getArticlesInfo:_announcementDomain.uuid success:^(AnnouncementDomain *announcementObj) {
        
        _announcementDomain = announcementObj;
        [self resetViewParam];
        
    } faild:^(NSString *errorMsg) {
        
    }];
}

- (void)resetViewParam {
    titleLabel.text = _announcementDomain.title;
    [myWebView loadHTMLString:_announcementDomain.message baseURL:nil];
    timeLabel.text = _announcementDomain.create_time;
    createUserLabel.text = _announcementDomain.create_user;
}


- (IBAction)articlesFunBtnClicked:(UIButton *)sender {
   
    switch (sender.tag) {
        case 10:
            //赞
            break;
        case 11: {
            //分享
            [self shareClicked];
            break;
        }
        case 12:
            //收藏
            break;
        case 13: {
            //评论
            ReplyListViewController * baseVC = [[ReplyListViewController alloc] init];
            baseVC.topicUUID = _announcementDomain.uuid;
            [self.navigationController pushViewController:baseVC animated:YES];
            break;
        }
    }
}

- (void)savwDZ {
    [[KGHUD sharedHud] show:self.contentView];
    
    [[KGHttpService sharedService] saveDZ:_announcementDomain.uuid type:Topic_Articles success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        dzImageView.image = [UIImage imageNamed:@"zan2"];
        dzBtn.userInteractionEnabled = NO;
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}


- (void)shareClicked {
    if(!popupView) {
        popupView = [[PopupView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, KGSCREEN.size.width, KGSCREEN.size.height)];
        popupView.alpha = Number_Zero;
        
        CGFloat height = 140;
        shareVC = [[ShareViewController alloc] init];
        shareVC.view.frame = CGRectMake(Number_Zero,  KGSCREEN.size.height-height, KGSCREEN.size.width, height);
        [popupView addSubview:shareVC.view];
        [self.view addSubview:popupView];
    }
    
    [UIView viewAnimate:^{
        popupView.alpha = Number_One;
    } time:Number_AnimationTime_Five];
    
}

@end
