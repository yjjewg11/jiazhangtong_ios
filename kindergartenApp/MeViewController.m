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
#import "MySPCourseVC.h"
#import "EnrolStudentMySchoolVC.h"
#import "FPHomeVC.h"

#define CellIdentifier @"MyCellIdentifier"
#define CellDefIdentifier @"MyDefCellIdentifier"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView * meTableView;
}

@end

@implementation MeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    meTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    meTableView.separatorColor = [UIColor clearColor];
    meTableView.delegate   = self;
    meTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self loadFunCell:tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)loadFunCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MeFunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellDefIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeFunTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:Number_Zero];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row)
    {
        case Number_Zero:
            [cell resetCellParam:@"收藏" img:@"meshoucang"];
            break;
        case Number_One:
            [cell resetCellParam:@"我的特长课程" img:@"metechangkecheng"];
            break;
        case 2:
            [cell resetCellParam:@"家庭相册" img:@"jiatingxiangce"];
            break;
        case 3:
            [cell resetCellParam:@"设置" img:@"meshezhi"];
            break;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self funCellSelected:indexPath];
}


- (void)funCellSelected:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case Number_Zero:
        {
            MyCollectionViewController * vc = [[MyCollectionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Number_One:
        {
            MySPCourseVC * vc = [[MySPCourseVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Number_Two:
        {
            FPHomeVC * vc = [[FPHomeVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            SettingViewController * vc = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

@end
