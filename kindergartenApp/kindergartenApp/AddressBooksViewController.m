//
//  AddressBooksViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/19.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AddressBooksViewController.h"
#import "ChatViewController.h"
#import "KGHttpService.h"
#import "AnnouncementDomain.h"
#import "KGHUD.h"
#import "UIColor+Extension.h"
#import "AddressBookDomain.h"
#import "AddressbookTableViewCell.h"

@interface AddressBooksViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView * addressbookTableView;
    AddressBookResp * addressBookList;
    UIWebView * telWebView;
}


@end

@implementation AddressBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    addressbookTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    addressbookTableView.separatorColor = [UIColor clearColor];
    addressbookTableView.delegate   = self;
    addressbookTableView.dataSource = self;
    [addressbookTableView registerNib:[UINib nibWithNibName:@"AddressbookTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddressbookTableViewCell"];
    
    [self getTableData];
    
    //注册cell功能按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressbookCellFunBtnNotification:) name:Key_Notification_AddressbookCellFun object:nil];
}

//帖子高度改变通知
- (void)addressbookCellFunBtnNotification:(NSNotification *)notification {
    NSDictionary * dic = notification.userInfo;
    AddressBookDomain * domain = [dic objectForKey:@"addressBookDomain"];
    NSInteger type = [[dic objectForKey:@"type"] integerValue];
    
    if(type == Number_Ten) {
        //打电话
        if (!telWebView) {
            telWebView = [[UIWebView alloc] init];
        }
        if (telWebView.superview) {
            [telWebView removeFromSuperview];
        }
        [telWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",domain.tel]]]];
        [self.view addSubview:telWebView];
    } else {
        //发消息
        ChatViewController * chatVC = [[ChatViewController alloc] init];
        chatVC.addressbookDomain = domain;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//获取数据加载表格
- (void)getTableData{
    [[KGHUD sharedHud] show:self.contentView];
    
    [[KGHttpService sharedService] getAddressBookList:^(AddressBookResp *addressBookResp) {
        
        addressBookList = addressBookResp;
        [addressbookTableView reloadData];
        [[KGHUD sharedHud] hide:self.contentView];
        
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}


#pragma UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return Number_Two;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==Number_Zero) {
        return [addressBookList.listKD count];
    }
    return [addressBookList.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AddressbookTableViewCell * cell = [AddressbookTableViewCell cellWithTableView:tableView];
    AddressbookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressbookTableViewCell"];
    if(indexPath.section == Number_Zero) {
        [cell resetValue:[addressBookList.listKD objectAtIndex:indexPath.row] parame:nil];
    } else {
        AddressBookDomain * domain = [addressBookList.list objectAtIndex:indexPath.row];
        [cell resetValue:domain parame:nil];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}



@end
