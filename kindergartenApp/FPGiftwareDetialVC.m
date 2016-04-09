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
#import "SPBottomItem.h"
#import "SPBottomItemTools.h"
#import "FFMovieEditMainVC.h"
@interface FPGiftwareDetialVC ()<UIWebViewDelegate,FPTimeLineDetailMoreViewDelegate,UIAlertViewDelegate>
{

    IBOutlet UIScrollView *contentScrollView;
    IBOutlet UIWebView * myWebView;
    
    FPTimeLineDetailMoreView *moreView;
   NSMutableArray * _buttonItems;
    BOOL moreViewIsShow;
    
    FPTimeLineDetailMoreView * _moreView;
    BOOL _moreViewOpen;
   
    
}
@property (weak, nonatomic) IBOutlet UIView * bottomView;

@property  ShareOpenVC* shareOpenVC;

 @property (strong, nonatomic) SPBottomItem * pinglunSPBottomItem;

@end

@implementation FPGiftwareDetialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myWebView.backgroundColor = [UIColor clearColor]; 
    myWebView.opaque = NO;
    contentScrollView.scrollEnabled = NO;
    myWebView.scrollView.scrollEnabled = YES;
    
    myWebView.delegate = self;
    
    NSLog(@"myWebView loadRequest, url=%@",self.domain.share_url);
    CGSize size=self.bottomView.size;
    size.width=APPWINDOWWIDTH;
    [self.bottomView setSize:size];
    //创建底部按钮
    [self addBtn:self.bottomView];
    [self resetViewParam];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 创建底部按钮
- (void)addBtn:(UIView *)view
{
    
    NSArray * imageName = @[@"newshoucang1",@"fp_hudong",@"fp_dz",@"fp_fenxiang",@"fp_more"];
    NSArray * titleName = @[@"收藏",@"评论",@"点赞",@"分享",@"更多"];
    
    
    _buttonItems=[SPBottomItemTools createBottoms:view imageName:imageName titleName:titleName addTarget:self action:@selector(bottomBtnClicked:) ];
    
    
    self.pinglunSPBottomItem=_buttonItems[1];
    return;
}


#pragma mark - 下面按钮点击
- (void)bottomBtnClicked:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 0:
        {
            
            //收藏
            if (btn.selected == YES) {
                [self delFavorites:btn];
            }else{
                [self saveFavorites:btn];
            }
            break;
        }
        case 1://评论
        {
            
            [self baseReplyListVC_show];
            
            
        }
            break;
        case 2:
        {
            if ( btn.selected == YES) {
                [self delDZ:btn];
            }else{
                [self savwDZ:btn];
            }
        }
            break;
        case 3:
        {
            if(self.shareOpenVC==nil){
                self.shareOpenVC=[[ShareOpenVC alloc]init];
            }
            
            NSString * title=self.domain.title;
            NSString * url=self.domain.share_url;
            
            [self.shareOpenVC toShare:title url:url];
        }
            break;
        case 4:
        {
            [self showMoreView];
        }
            break;
        default:
            break;
    }
}

#pragma pinglun
- (void)baseReplyListVC_show{
    
    NSInteger type=Topic_FPGiftware;
    
    NSDictionary * dic = @{@"rel_uuid" :_domain.uuid, @"type" : [NSNumber numberWithInteger:type]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_ShowBaseReplyList object:self userInfo:dic];
    
    return;
    
    
}
- (void)showMoreView //39 90
{
    
    if(_moreView==nil){
        
        _moreView = [[[NSBundle mainBundle] loadNibNamed:@"FPTimeLineDetailMoreView" owner:nil options:nil] firstObject];
        _moreView.delegate = self;
        [_moreView setOrigin:CGPointMake(APPWINDOWWIDTH - 44, APPWINDOWHEIGHT)];
        [self.view addSubview:_moreView];
        [self.view bringSubviewToFront:self.bottomView];
    }
    if (_moreViewOpen == NO)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             [_moreView setOrigin:CGPointMake(APPWINDOWWIDTH - 44, CGRectGetMaxY(_bottomView.frame)-49-90)];
         }];
        _moreViewOpen = YES;
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             [_moreView setOrigin:CGPointMake(APPWINDOWWIDTH - 44, APPWINDOWHEIGHT)];
         }];
        _moreViewOpen = NO;
    }
}

- (void)deleteBtn{
    NSLog(@"deleteBtn");
    
    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"确定要删除吗?" message:@"请确认" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [al show];
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@rest/fPMovie/delete.json?uuid=%@", [KGHttpUrl getBaseServiceURL], self.domain.uuid];
                MBProgressHUD *hud=[MBProgressHUD showMessage:@"保存中.."];
        hud.removeFromSuperViewOnHide=YES;
        [[KGHttpService sharedService] postByBodyJson:url params:nil success:^(KGBaseDomain *baseDomain) {
             [self.navigationController popViewControllerAnimated:YES];
            [hud hide:YES];
             [MBProgressHUD showSuccess:baseDomain.ResMsg.message];

        } faild:^(NSString *errorMessage) {
            
            [hud hide:YES];
            [MBProgressHUD showError:errorMessage];
        }];
    }
}


- (void)modifyBtn{
    NSLog(@"modifyBtn");
    
    FFMovieEditMainVC *vc= [[FFMovieEditMainVC alloc]init];
    [FFMovieShareData getFFMovieShareData].domain=self.domain;
       [self.navigationController pushViewController:vc animated:NO];
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
       ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang2"];
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
  ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang1"];
        
        
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
        
        SPBottomItem * item = _buttonItems[2];
        item.imgView.image = [UIImage imageNamed:@"fp_dz2"];
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
         
         SPBottomItem * item = _buttonItems[2];
         item.imgView.image = [UIImage imageNamed:@"fp_dz"];
         sender.selected = !sender.selected;
         sender.enabled = YES;
     } faild:^(NSString *errorMsg) {
         sender.enabled = YES;
         [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
         
     }];
}







- (void)resetViewParam {
    
    
    
    self.title = self.domain.title;

    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.domain.share_url]]];
    
    
    if(self.domain.yidianzan>0)
    {
        SPBottomItem * item = _buttonItems[2];
        item.imgView.image = [UIImage imageNamed:@"fp_dz2"];
        item.btn.selected = YES;
    }
    else
    {
        SPBottomItem * item = _buttonItems[2];
        item.imgView.image = [UIImage imageNamed:@"fp_dz"];
        item.btn.selected = NO;
    }
    
    if(self.domain.isFavor)
    {
        SPBottomItem * item = _buttonItems[0];
        item.imgView.image = [UIImage imageNamed:@"fp_shoucang2"];
        item.btn.selected = YES;
    }
    else
    {
        SPBottomItem * item = _buttonItems[0];
        item.imgView.image = [UIImage imageNamed:@"newshoucang1"];
        item.btn.selected = NO;
    }
    
     SPBottomItem * item = _buttonItems[1];
    [item setTipNumber:self.domain.reply_count];
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
