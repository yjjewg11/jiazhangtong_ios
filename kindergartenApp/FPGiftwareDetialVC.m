//
//  FPGiftwareDetialVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/27.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPGiftwareDetialVC.h"

#import "ShareOpenVC.h"

@interface FPGiftwareDetialVC ()
{
    IBOutlet UIScrollView *contentScrollView;
    IBOutlet UIWebView * myWebView;
    
    IBOutlet UIImageView * dzImageView;
    IBOutlet UIButton *dzBtn;
    
    __weak IBOutlet UIButton *shareBtn;
    IBOutlet UIImageView *favImageView;
    IBOutlet UIButton *favBtn;
}
@property (weak, nonatomic) IBOutlet UIButton *pinlunBtn;


@property  ShareOpenVC* shareOpenVC;
@end

@implementation FPGiftwareDetialVC
- (IBAction)dianZanClick:(id)sender {
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
}
- (IBAction)pinlunClick:(id)sender {
}
- (IBAction)moreBtnClick:(id)sender {
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.opaque = NO;
    contentScrollView.scrollEnabled = NO;
    myWebView.scrollView.scrollEnabled = YES;
    
    myWebView.delegate = self;
    
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

@end
