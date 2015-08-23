//
//  PushNotificationViewController.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "PushNotificationViewController.h"

#define NewMessageKey @"newMessage"

@interface PushNotificationViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * dataArray;

@end

@implementation PushNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.rowHeight = 40;
    [_tableView registerNib:[UINib nibWithNibName:@"PushNotificationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PushNotificationTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _dataArray = @[@"新消息"];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PushNotificationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PushNotificationTableViewCell"];
    cell.flagTitleLabel.text = _dataArray[indexPath.row];
    
    cell.mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:NewMessageKey];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
