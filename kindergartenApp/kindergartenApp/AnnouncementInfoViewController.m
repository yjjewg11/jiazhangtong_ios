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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = announcementDomain.title;
    self.keyBoardController.isShowKeyBoard = YES;
    self.keyboardTopType = EmojiAndTextMode;
    
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.opaque = NO;
    myWebView.delegate = self;
    myWebView.scrollView.scrollEnabled = NO;
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
    
    topicView.size = CGSizeMake(APPWINDOWWIDTH, topicFrame.topicInteractHeight);
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
    announcementDomain.message = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>",announcementDomain.message];
    [myWebView loadHTMLString:announcementDomain.message baseURL:nil];
    groupLabel.text = [[KGHttpService sharedService] getGroupNameByUUID:announcementDomain.groupuuid];
    createTimeLabel.text = announcementDomain.create_time;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[KGHUD sharedHud] show:self.view];
    [self performSelector:@selector(lazyEx) withObject:self afterDelay:0.5];
}

#pragma mark - 延迟执行
- (void)lazyEx{
    NSLog(@"%lf,%lf",contentScrollView.contentSize.width,contentScrollView.contentSize.height);
    NSLog(@"%lf,%lf",myWebView.frame.size.width,myWebView.frame.size.height);
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
    
    
    groupLabel.y = CGRectGetMaxY(myWebView.frame) + Number_Ten;
    groupLabel.x = KGSCREEN.size.width - groupLabel.width - CELLPADDING;
    createTimeLabel.y = CGRectGetMaxY(groupLabel.frame) + Number_Ten;
    createTimeLabel.x = KGSCREEN.size.width - createTimeLabel.width - CELLPADDING;
    topicView.y = CGRectGetMaxY(groupLabel.frame) + 30;
    contentScrollView.contentSize = CGSizeMake(KGSCREEN.size.width, topicView.height + topicView.y + CELLPADDING);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
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
