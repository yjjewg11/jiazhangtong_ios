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
//#import "Masonry.h"
#import "KGNSStringUtil.h"
#import "TopicInteractionDomain.h"
#import "TopicInteractionFrame.h"

@interface AnnouncementInfoViewController () <UIWebViewDelegate> {
    
    IBOutlet UIScrollView * contentScrollView;
    IBOutlet UILabel   * titleLabel;
    IBOutlet UIWebView * myWebView;
    IBOutlet UILabel   * groupLabel;
    IBOutlet UILabel   * createTimeLabel;
    TopicInteractionView * topicView;
    AnnouncementDomain * announcementDomain;
}

@end

@implementation AnnouncementInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = announcementDomain.title;
    self.keyBoardController.isShowKeyBoard = YES;
    self.keyboardTopType = EmojiAndTextMode;
    
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.opaque = NO;
    myWebView.delegate = self;
    [self getAnnouncementDomainInfo];
    
    self.contentView.width = KGSCREEN.size.width;
    contentScrollView.width = KGSCREEN.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//加载帖子互动
- (void)loadTopicInteractionView {
    if(topicView) {
        [topicView removeFromSuperview];
    }
    TopicInteractionDomain * domain = [TopicInteractionDomain new];
    domain.dianzan = announcementDomain.dianzan;
    domain.replyPage = announcementDomain.replyPage;
    domain.topicType = announcementDomain.topicType;
    domain.topicUUID = announcementDomain.uuid;
    domain.borwseType = BrowseType_Count;
    
    self.topicInteractionDomain = domain;
    
    TopicInteractionFrame * topicFrame = [TopicInteractionFrame new];
    topicFrame.topicInteractionDomain  = domain;
    
    CGFloat y = CGRectGetMaxY(createTimeLabel.frame) + Number_Ten;
    topicView = [[TopicInteractionView alloc] init];
    [contentScrollView addSubview:topicView];
    
    topicView.topicInteractionFrame = topicFrame;
    
    topicView.size = CGSizeMake(CELLCONTENTWIDTH, topicFrame.topicInteractHeight);
    topicView.origin = CGPointMake(0, CGRectGetMaxY(createTimeLabel.frame));
    
    CGFloat contentHeight = y + topicFrame.topicInteractHeight + 64;
    CGFloat contentWidth  = KGSCREEN.size.width;
    contentScrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}


- (void)getAnnouncementDomainInfo {
    
    [[KGHttpService sharedService] getAnnouncementInfo:_annuuid success:^(AnnouncementDomain *announcementObj) {
        
        announcementDomain = announcementObj;
        [self resetViewParam];
        [self loadTopicInteractionView];
        
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}


- (void)resetViewParam {
    titleLabel.text = announcementDomain.title;
    [myWebView loadHTMLString:announcementDomain.message baseURL:nil];
    groupLabel.text = [[KGHttpService sharedService] getGroupNameByUUID:announcementDomain.groupuuid];
    createTimeLabel.text = announcementDomain.create_time;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //webview 自适应高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = CGRectMake(Number_Zero, CGRectGetMaxY(titleLabel.frame), KGSCREEN.size.width, fittingSize.height);
    groupLabel.y = CGRectGetMaxY(webView.frame) + Number_Ten;
    groupLabel.x = KGSCREEN.size.width - groupLabel.width - CELLPADDING;
    createTimeLabel.y = CGRectGetMaxY(groupLabel.frame) + Number_Ten;
    createTimeLabel.x = KGSCREEN.size.width - createTimeLabel.width - CELLPADDING;
    topicView.y = CGRectGetMaxY(groupLabel.frame) + 30;
    contentScrollView.contentSize = CGSizeMake(KGSCREEN.size.width, topicView.height + topicView.y + CELLPADDING);
    
}

- (void)alttextFieldDidEndEditing:(UITextField *)textField {
    NSString * replyText = [KGNSStringUtil trimString:textField.text];
    if(replyText && ![replyText isEqualToString:String_DefValue_Empty]) {
        NSDictionary *dic = @{Key_TopicTypeReplyText : [KGNSStringUtil trimString:textField.text]};
        [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_TopicReply object:self userInfo:dic];
        
        [textField resignFirstResponder];
    }
}


//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain {
    ReplyPageDomain * replyPageDomain = announcementDomain.replyPage;
    if(!replyPageDomain) {
        replyPageDomain = [[ReplyPageDomain alloc] init];
    }
    
    [replyPageDomain.data insertObject:domain atIndex:Number_Zero];
    
    [self loadTopicInteractionView];
}


@end
