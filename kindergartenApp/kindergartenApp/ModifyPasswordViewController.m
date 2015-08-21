//
//  ModifyPasswordViewController.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * dataArray;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(handleSavePwd)];
    [rightItem setTintColor:[UIColor whiteColor]];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ModifyPasswordTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModifyPasswordTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 40;
    
    _dataArray = @[@"原密码",@"新密码",@"确认密码"];
}

- (void)handleSavePwd{
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; ++ i) {
        ModifyPasswordTableViewCell * cell = (ModifyPasswordTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [tempArray addObject:cell.passwordTextField.text];
    }
    if (![tempArray[1] isEqualToString:tempArray[2]]) {
        [[KGHUD sharedHud] show:self.view onlyMsg:@"两次输入的密码不一致"];
        return;
    }
    if (!([self isRange:tempArray[0]] &&
        [self isRange:tempArray[1]] &&
        [self isRange:tempArray[2]])) {
        [[KGHUD sharedHud] show:self.view onlyMsg:@"请输入长度在6~16位的密码"];
        return;
    }
    
    KGUser * user = [[KGUser alloc] init];
    user.oldpassowrd = tempArray[0];
    [user setUserPassword:tempArray[1]];
    [[KGHUD sharedHud] show:self.view];
    __weak typeof(self) weakSelf = self;
    [[KGHttpService sharedService] modifyPassword:user success:^(NSString *msg) {
        [[KGHUD sharedHud] show:self.view onlyMsg:msg];
        [weakSelf performSelector:@selector(back) withObject:self afterDelay:2.0];
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isRange:(NSString *)string{
    if (string.length >= 6 && string.length <= 16) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModifyPasswordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ModifyPasswordTableViewCell"];
    if (indexPath.row == 0) {
        cell.flagImageView.image = [UIImage imageNamed:@"yuanmima"];
        cell.passwordTextField.secureTextEntry = NO;
    }else{
        cell.flagImageView.image = [UIImage imageNamed:@"xinmima"];
    }
    cell.passwordTextField.placeholder = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
