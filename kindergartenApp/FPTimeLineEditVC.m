//
//  FPTimeLineEditVC.m
//  kindergartenApp
//
//  Created by Mac on 16/2/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPTimeLineEditVC.h"
#import "UIImageView+WebCache.h"
#import "DBNetDaoService.h"
#import "KGHttpService.h"
#import "MBProgressHUD+HM.h"
@interface FPTimeLineEditVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UITextView *note;

@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UITextField *time;

@end

@implementation FPTimeLineEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑";
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:self.domain.path]];
//    self.note.placeholder=@"";
    self.note.text = self.domain.note;
    self.address.text = self.domain.address;
    self.time.text = self.domain.photo_time;
    
    
    self.address.delegate = self;
    
    //创建编辑按钮
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    barbtn.title = @"保存";
    barbtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = barbtn;
}

- (void)save
{
    self.domain.note = self.note.text;
    self.domain.address = self.address.text;
    
//    FPFamilyPhotoNormalDomain domain=[[FPFamilyPhotoNormalDomain alloc]init];
//    domain.uuid=self.domain.uuid;
//    domain.note=self.note.text;
//    doman.
    MBProgressHUD *hud=[MBProgressHUD showMessage:@"保存中.."];
    hud.removeFromSuperViewOnHide=YES;
    
    [[KGHttpService sharedService] postByDomainBodyJson:[KGHttpUrl modifyFPItemUrl] params:self.domain success:^(KGBaseDomain *baseDomain) {
        [hud hide:YES];
        [MBProgressHUD showSuccess:@"保存成功!"];
        [self.delegate updateFPFamilyPhotoNormalDomain:self.domain];
         [self.navigationController popViewControllerAnimated:YES];

    } faild:^(NSString *errorMessage) {
        [hud hide:YES];
        [MBProgressHUD showError:errorMessage];
    }];
    
    
 
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{//回收键盘,取消第一响应者
    [textField resignFirstResponder]; return YES;
    
}
//2.点击空白处回收键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.note resignFirstResponder];
    [self.address resignFirstResponder];
}
@end
