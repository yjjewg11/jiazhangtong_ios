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

@interface FPTimeLineEditVC ()

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
    self.note.text = self.domain.note;
    self.address.text = self.domain.address;
    self.time.text = self.domain.create_time;
    
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
    //更新数据库
    [[DBNetDaoService defaulService] updatePhotoItemInfo:self.domain];
    
    //保存到服务器
    [[KGHttpService sharedService] modifyFPItemInfo:self.domain.address note:self.domain.note success:^(NSString *mgr)
    {
    } faild:^(NSString *errorMsg)
    {
    }];
    
    //通知详情页更新这个domain
    NSNotification * noti = [[NSNotification alloc] initWithName:@"updatedetail" object:self.domain userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];

    [self.navigationController popViewControllerAnimated:YES];
}


@end
