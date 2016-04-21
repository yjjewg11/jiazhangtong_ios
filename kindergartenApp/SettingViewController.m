//
//  SettingViewController.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "SettingViewController.h"
#import "KGDateUtil.h"
#import "KGHttpService.h"
#import "SDWebImageManager.h"

#import "MobClick.h"

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * dataArray;
@property (strong, nonatomic) NSString * urlString;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"SettingViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingViewCell"];
    _dataArray = @[@[@"修改密码",@"推送通知",@"清除缓存"],@[@"意见反馈",@"关于我们"],@[@"退出"]];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * array = _dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SettingViewCell"];
    cell.titleLabel.text = _dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseViewController * vc;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                vc = [[ModifyPasswordViewController alloc] init];
            }
                break;
            case 1:{
                vc = [[PushNotificationViewController alloc] init];
            }
                break;
            case 2:{
                NSInteger i = [[SDImageCache sharedImageCache] getSize];
                
                //重新获取网页地址
                [self getSysConfig];
                //清除web缓存
                NSURLCache * cache = [NSURLCache sharedURLCache];
                [cache removeAllCachedResponses];
                [cache setDiskCapacity:0];
                [cache setMemoryCapacity:0];
                //清除缓存的图片
                [[SDImageCache sharedImageCache] clearDisk];
                NSString * msg = [NSString stringWithFormat:@"清除了%.2lfMB的缓存",(((long)i / 1024.00)/1024.00)];
                 
                UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"成功" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [al show];
                
                [[DBNetDaoService defaulService] restAllTable];
            }
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                vc = [[AdvanceViewController alloc] init];
                [[SPKitExample sharedInstance] exampleOpenFeedbackViewController:YES fromViewController:self];
                
                return;
            }
                break;
            case 1:{
                vc = [[AboutWeViewController alloc] init];
            }
                break;
        }
    }else if (indexPath.section == 2){
        [self logoutBtnClicked];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)logoutBtnClicked {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


#pragma UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == Number_One) {
        
        KGUser * currentUser =  [KGAccountTool account];
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.userNameTextField.text = currentUser.loginname;
        loginVC.userPwdTextField.text = currentUser.password;
        
        [[KGHttpService sharedService] logout:^(NSString *msgStr) {
            [KGAccountTool delAccount];
            [KGAccountService logout];
            [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].keyWindow.rootViewController = [[KGNavigationController alloc] initWithRootViewController:loginVC];
            });
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
        }];
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getSysConfig
{
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    NSString * time = [defu objectForKey:@"timeofreq"];
    NSString * sns_url = [defu objectForKey:@"sns_url"];
    NSLog(@"磁盘存放的时间:%@ , 最新话题地址:%@",time,sns_url);
    
    if (time == nil || [time isEqualToString:@""])  //第一次进来，请求一个md5,并设置时间
    {
        [defu setObject:[KGDateUtil getTime] forKey:@"timeofreq"];//设置当前时间
        
        [[KGHttpService sharedService] getSysConfig:@"" success:^(SystemConfigOfTopic *sysDomain)
         {
             [defu setObject:sysDomain.md5 forKey:@"md5"]; //设置md5
             if (sysDomain.sns_url == nil)
             {
                 sysDomain.sns_url = @"";
             }
             [defu setObject:sysDomain.sns_url forKey:@"sns_url"]; //设置话题url
             [defu synchronize];
         }
                                              faild:^(NSString *errorMsg)
         {
             
         }];
    }
    else //不是第一次进来，获取存到磁盘的时间，和当前时间做比较，如果大于一天，就调用sys方法
    {
        if ([KGDateUtil intervalSinceNow:time] >= 0) //这里可以改天数
        {
            //是时候调用了
            NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
            NSString * md5 = [defu objectForKey:@"md5"];
            [defu setObject:[KGDateUtil getTime] forKey:@"timeofreq"];//设置当前时间
            
            if (md5 == nil || [md5 isEqualToString:@""])
            {
                md5 = @"";
            }
            
            [[KGHttpService sharedService] getSysConfig:md5 success:^(SystemConfigOfTopic *sysDomain)
             {
                 [defu setObject:sysDomain.md5 forKey:@"md5"]; //设置md5
                 if (sysDomain.sns_url == nil)
                 {
                     sysDomain.sns_url = @"";
                 }
                 [defu setObject:sysDomain.sns_url forKey:@"sns_url"]; //设置话题url
                 [defu synchronize];
             }
                                                  faild:^(NSString *errorMsg)
             {
                 
             }];
        }
        else
        {
            NSLog(@"还没到时候调用这个方法");
        }
    }
}

@end
