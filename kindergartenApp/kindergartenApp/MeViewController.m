//
//  MeViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "MeViewController.h"
#import "KGAccountTool.h"
#import "UIWindow+Extension.h"
#import "KGUser.h"
#import "LoginViewController.h"
#import "KGNavigationController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "MeTableViewCell.h"
#import "KGHttpService.h"
#import "MeFunTableViewCell.h"
#import "StudentInfoViewController.h"

#define CellIdentifier @"MyCellIdentifier"
#define CellDefIdentifier @"MyDefCellIdentifier"

@interface MeViewController () <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView * meTableView;
    NSArray              * studentMArray;
}

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    studentMArray = [KGHttpService sharedService].loginRespDomain.list;
    
    meTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    meTableView.separatorColor = [UIColor clearColor];
    meTableView.delegate   = self;
    meTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
            [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].keyWindow.rootViewController = [[KGNavigationController alloc] initWithRootViewController:loginVC];
            });
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
        }];
        
       
    }
}


#pragma UITableView delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [studentMArray count] + Number_Two;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Number_One;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < [studentMArray count]) {
        //table前几个分组显示学生基本信息
        return [self loadStudentInfoCell:tableView cellForRowAtIndexPath:indexPath];
    } else {
        return [self loadFunCell:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (UITableViewCell *)loadStudentInfoCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:Number_Zero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell resetCellParam:(KGUser *)[studentMArray objectAtIndex:indexPath.row]];
    return cell;
}


- (UITableViewCell *)loadFunCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeFunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellDefIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeFunTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:Number_Zero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    switch (indexPath.section - [studentMArray count]) {
        case Number_Zero:
            [cell resetCellParam:@"收藏" img:@"meshoucang"];
            break;
        case Number_One:
            [cell resetCellParam:@"设置" img:@"meshezhi"];
            break;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < [studentMArray count]){
        return 60;
    }else{
        return 35;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section < [studentMArray count]) {
        //学生信息详情
        StudentInfoViewController * studentInfoVC = [[StudentInfoViewController alloc] init];
        studentInfoVC.studentInfo = [studentMArray objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:studentInfoVC animated:YES];
    } else {
        [self funCellSelected:indexPath];
    }
}


- (void)funCellSelected:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.section - [studentMArray count];
    
//    BaseViewController * vc = nil;
    switch (index) {
        case Number_Zero:{
            MyCollectionViewController * vc = [[MyCollectionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Number_One:{
            SettingViewController * vc = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}




@end
