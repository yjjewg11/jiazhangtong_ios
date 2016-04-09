//
//  FFMoiveEditPreviewVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/9.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FFMoiveEditPreviewVC.h"
#import "KGHUD.h"
#import "FPMoiveDomain.h"
#import "KGDateUtil.h"
#import "FFMovieShareData.h"
#import "KGHttpService.h"
#import "MBProgressHUD+HM.h"
@interface FFMoiveEditPreviewVC ()<UIWebViewDelegate,UIAlertViewDelegate>{
    
    __weak IBOutlet UIWebView *myWebView;
    
}

@end

@implementation FFMoiveEditPreviewVC
- (IBAction)submitBtn_click:(id)sender {
    
    

UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"相册名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

[alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
UITextField *nameField = [alertView textFieldAtIndex:0];

  nameField.text=self.domain.title;
[alertView show];


}

#pragma mark 窗口的代理方法，用户保存数据
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex!=1) return;
    UITextField *textField= [alertView textFieldAtIndex:0];
    self.domain.title=textField.text;
    
    [self fpMovie_save];
}
-(void)fpMovie_save{
    
    FPMoive4QDomain * domain4q= self.domain;
    FPMoiveDomain * saveDomain=[[FPMoiveDomain alloc]init];
    saveDomain.uuid=domain4q.uuid;
    saveDomain.title=domain4q.title;
    saveDomain.herald=domain4q.herald;
    //    saveDomain.photo_uuids=domain4q.photo_uuids;
    saveDomain.template_key=domain4q.template_key;
    saveDomain.mp3=domain4q.mp3;
    saveDomain.status=@"0";//发布。
    if(saveDomain.title==nil||saveDomain.title.length==0){
        [MBProgressHUD showError:@"请输入相册名"];
        return;
    }
    saveDomain.photo_uuids=[FFMovieShareData getFFMovie_photo_uuids];
    if(saveDomain.photo_uuids==nil ||saveDomain.photo_uuids.length==0){
        [MBProgressHUD showError:@"请选择照片"];
        return;
    }
    MBProgressHUD *hud=[MBProgressHUD showMessage:@"保存中"];
    hud.removeFromSuperViewOnHide=YES;
    [[KGHttpService sharedService] fpMovie_save:saveDomain success:^(KGBaseDomain *domain) {
        [hud hide:YES];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } faild:^(NSString *errorMsg) {
        [hud hide:YES];
        [MBProgressHUD showError:errorMsg];
    }];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.opaque = NO;
    myWebView.scrollView.scrollEnabled = YES;
    
    myWebView.delegate = self;
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.domain.share_url]]];
    
    NSLog(@"myWebView loadRequest, url=%@",self.domain.share_url);

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[KGHUD sharedHud] show:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[KGHUD sharedHud] hide:self.view];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [[KGHUD sharedHud] hide:self.view];
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
