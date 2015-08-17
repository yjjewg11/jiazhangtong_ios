//
//  SettingViewController.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "SettingViewController.h"

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
    _dataArray = @[@[@"修改密码",@"推送通知"],@[@"意见反馈",@"关于我们",@"检查更新"],@[@"退出"]];
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
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                vc = [[AdvanceViewController alloc] init];
            }
                break;
            case 1:{
                vc = [[AboutWeViewController alloc] init];
            }
                break;
            case 2:
                [[KGHUD sharedHud] show:self.view];
                [MobClick checkUpdateWithDelegate:self selector:@selector(handleUpdate:)];
                return;
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

#pragma mark - 处理更新回调
- (void)handleUpdate:(NSDictionary *)dic{
    [[KGHUD sharedHud] hide:self.view];
    BOOL update = [[dic objectForKey:@"update"] boolValue];
    if (update) {
        _urlString = [dic objectForKey:@"path"];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有新版本需要更新!" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"更新", nil];
        alertView.tag = 21;
        [alertView show];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最新版本了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}


#pragma UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 21) {
        if (buttonIndex == Number_One) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_urlString]];
        }
        return;
    }
    
    if(buttonIndex == Number_One) {
        
        KGUser * currentUser =  [KGAccountTool account];
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.userNameTextField.text = currentUser.loginname;
        loginVC.userPwdTextField.text = currentUser.password;
        
        [[KGHttpService sharedService] logout:^(NSString *msgStr) {
            [KGAccountTool delAccount];
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



@end
