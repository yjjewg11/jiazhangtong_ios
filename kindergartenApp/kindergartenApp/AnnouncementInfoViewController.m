//
//  AnnouncementInfoViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AnnouncementInfoViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "TopicInteractionView.h"
#import "Masonry.h"

@interface AnnouncementInfoViewController () {
    
    IBOutlet UIScrollView * contentScrollView;
    IBOutlet UILabel   * titleLabel;
    IBOutlet UIWebView * myWebView;
    IBOutlet UILabel   * groupLabel;
    IBOutlet UILabel   * createTimeLabel;
}

@end

@implementation AnnouncementInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getAnnouncementDomainInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//加载帖子互动
- (void)loadTopicInteractionView {
   
    CGFloat y = CGRectGetMaxY(createTimeLabel.frame) + Number_Ten;
    TopicInteractionView * topicView = [[TopicInteractionView alloc] init];
    [topicView loadFunView:_announcementDomain.dianzan reply:_announcementDomain.replyPage];
    topicView.topicType = Topic_Announcement;
    topicView.topicUUID = _announcementDomain.uuid;
    [contentScrollView addSubview:topicView];
    
    [topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(y));
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
        make.width.equalTo(@(CELLCONTENTWIDTH));
        make.height.equalTo(@(topicView.topicInteractHeight));
    }];
    
    [self.keyBoardController buildDelegate];
    
    CGFloat contentHeight = y + topicView.topicInteractHeight + 64;
    CGFloat contentWidth  = KGSCREEN.size.width;
    contentScrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}


- (void)getAnnouncementDomainInfo {
    
    [[KGHttpService sharedService] getAnnouncementInfo:_announcementDomain.uuid success:^(AnnouncementDomain *announcementObj) {
        
        _announcementDomain = announcementObj;
        [self resetViewParam];
        [self loadTopicInteractionView];
        
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}


- (void)resetViewParam {
    titleLabel.text = _announcementDomain.title;
    [myWebView loadHTMLString:_announcementDomain.message baseURL:nil];
    groupLabel.text = [[KGHttpService sharedService] getGroupNameByUUID:_announcementDomain.groupuuid];
    createTimeLabel.text = _announcementDomain.create_time;
}


@end
