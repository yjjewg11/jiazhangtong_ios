//
//  FPGiftwareDetialVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/27.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPGiftwareDetialVC.h"
#import "KGHUD.h"
#import "ShareOpenVC.h"
#import "KGHttpService.h"
#import "MBProgressHUD+HM.h"
#import "KGDateUtil.h"
#import "FPTimeLineDetailMoreView.h"
@interface FPGiftwareDetialVC ()<UIWebViewDelegate,FPTimeLineDetailMoreViewDelegate>
{
    IBOutlet UIScrollView *contentScrollView;
    IBOutlet UIWebView * myWebView;
    
    IBOutlet UIImageView * dzImageView;
    IBOutlet UIButton *dzBtn;
    
    __weak IBOutlet UIButton *shareBtn;
    IBOutlet UIImageView *favImageView;
    IBOutlet UIButton *favBtn;
    
    FPTimeLineDetailMoreView *moreView;
    __weak IBOutlet UIButton *moreBtn;
    BOOL moreViewIsShow;
}
@property (weak, nonatomic) IBOutlet UIButton *pinlunBtn;


@property  ShareOpenVC* shareOpenVC;
@end

@implementation FPGiftwareDetialVC
- (IBAction)dianZanClick:(id)sender {
    
    if ( dzBtn.selected == YES) {
        [self delDZ:sender];
    }else{
        [self savwDZ:sender];
    }

}
- (IBAction)shareClick:(id)sender {
    if(self.shareOpenVC==nil){
        self.shareOpenVC=[[ShareOpenVC alloc]init];
    }
    
    NSString * title=self.domain.title;
    NSString * url=self.domain.share_url;
    
    [self.shareOpenVC toShare:title url:url];
    
}
- (IBAction)favClick:(id)sender {
    
    //收藏
    if (favBtn.selected == YES) {
        [self delFavorites:sender];
    }else{
        [self saveFavorites:sender];
    }
    
    
}
- (IBAction)pinlunClick:(id)sender {
}
- (IBAction)moreBtnClick:(id)sender {
    
    if(moreView==nil){
       
        moreView = [[[NSBundle mainBundle] loadNibNamed:@"FPTimeLineDetailMoreView" owner:nil options:nil] firstObject];
        moreView.delegate = self;
        NSLog(@"moreView=%f=%f=%f=%f",self.view.width-moreView.width-10,self.view.height-moreView.height-10,moreView.width, moreView.height);
        moreView.frame = CGRectMake(self.view.width-moreView.width-10,self.view.height-moreView.height-10, moreView.width, moreView.height);
        
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.3];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [[moreView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
        //添加最上层
        [self.view addSubview:moreView];
        
        return;

    }
    
    if (moreViewIsShow == YES)
    {
        [moreView setHidden:true];
        
        moreViewIsShow = NO;
    }else{
        [moreView setHidden:false];
        if(moreView)[self.view bringSubviewToFront:moreView];
        moreViewIsShow=YES;
    }
   
}
- (void)deleteBtn{
    NSLog(@"deleteBtn");

}

- (void)modifyBtn{
    NSLog(@"modifyBtn");
}
//保存收藏
- (void)saveFavorites:(UIButton *)button
{
    [[KGHUD sharedHud] show:self.view];
    
    
   
    
    if (self.domain.title == nil)
    {
        [MBProgressHUD showError:@"现在还不能收藏哦,请稍后再试"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [[KGHUD sharedHud] hide:self.view];
                       });
        return;
    }
    FavoritesDomain * domain = [[FavoritesDomain alloc] init];
    domain.title = self.domain.title;
    domain.type  = Topic_FPTimeLine;
    domain.reluuid = self.domain.uuid;
    domain.createtime = [KGDateUtil presentTime];
    button.enabled = NO;
    
    
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
    [[KGHttpService sharedService] delFavorites:self.domain.uuid success:^(NSString *msgStr) {
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

//保存点赞
- (void)savwDZ:(UIButton *)sender {
    
    [[KGHUD sharedHud] show:self.view];
    sender.enabled = NO;
    
    if (self.domain.uuid == nil)
    {
        sender.enabled = YES;
        [MBProgressHUD showError:@"现在还不能点赞呢,请稍后再试"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [[KGHUD sharedHud] hide:self.view];
                       });
        return;
    }
    [[KGHttpService sharedService] baseDianzan_save:self.domain.uuid type:Topic_FPTimeLine success:^(NSString *msgStr) {
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
    [[KGHttpService sharedService] baseDianzan_delete:self.domain.uuid type:Topic_FPTimeLine success:^(NSString *msgStr)
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




- (void)viewDidLoad {
    [super viewDidLoad];
    
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.opaque = NO;
    contentScrollView.scrollEnabled = NO;
    myWebView.scrollView.scrollEnabled = YES;
    
    myWebView.delegate = self;
    
    NSLog(@"myWebView loadRequest, url=%@",self.domain.share_url);
    [self resetViewParam];
    // Do any additional setup after loading the view from its nib.
}


//
//
////保存点赞
//- (void)savwDZ:(UIButton *)sender {
//    [[KGHUD sharedHud] show:self.view];
//    sender.enabled = NO;
//    
//    if (announcementDomain.uuid == nil)
//    {
//        sender.enabled = YES;
//        [MBProgressHUD showError:@"现在还不能点赞呢,请稍后再试"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//                       {
//                           [[KGHUD sharedHud] hide:self.view];
//                       });
//        return;
//    }
//    
//    [[KGHttpService sharedService] saveDZ:announcementDomain.uuid type:Topic_Articles success:^(NSString *msgStr) {
//        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
//        
//        dzImageView.image = [UIImage imageNamed:@"zan2"];
//        sender.selected = !sender.selected;
//        sender.enabled = YES;
//    } faild:^(NSString *errorMsg) {
//        sender.enabled = YES;
//        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
//    }];
//}
//
////取消点赞
//- (void)delDZ:(UIButton *)sender
//{
//    [[KGHUD sharedHud] show:self.view];
//    
//    sender.enabled = NO;
//    [[KGHttpService sharedService] delDZ:announcementDomain.uuid success:^(NSString *msgStr)
//     {
//         [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
//         
//         dzImageView.image = [UIImage imageNamed:@"zan1"];
//         sender.selected = !sender.selected;
//         sender.enabled = YES;
//     } faild:^(NSString *errorMsg) {
//         sender.enabled = YES;
//         [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
//         
//     }];
//}
//
- (void)resetViewParam {
    
    
    
    self.title = self.domain.title;

    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.domain.share_url]]];
    
    if(self.domain.yidianzan>0) {
        dzImageView.image = [UIImage imageNamed:@"zan2"];
        dzBtn.selected = YES;
    }
    
    if(!self.domain.isFavor) {
        favImageView.image = [UIImage imageNamed:@"shoucang2"];
        favBtn.selected = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[KGHUD sharedHud] show:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[KGHUD sharedHud] hide:self.view];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
     [[KGHUD sharedHud] hide:self.view];
}
@end
