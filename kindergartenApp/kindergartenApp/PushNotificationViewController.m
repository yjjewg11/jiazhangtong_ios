//
//  PushNotificationViewController.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "PushNotificationViewController.h"

#define NewMessageKey @"newMessage"
#define VoiceKey @"voice"
#define ShakeKey @"shake"

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
    _dataArray = @[@"新消息",@"声音",@"震动"];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PushNotificationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PushNotificationTableViewCell"];
    cell.flagTitleLabel.text = _dataArray[indexPath.row];
    
    NSString * key;
    switch (indexPath.row) {
        case 0:
            key = NewMessageKey;
            break;
        case 1:
            key = VoiceKey;
            break;
        case 2:
            key = ShakeKey;
            break;
    }
    
    cell.mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
