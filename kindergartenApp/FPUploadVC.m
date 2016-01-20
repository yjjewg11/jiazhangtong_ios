//
//  FPUploadVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPUploadVC.h"

@interface FPUploadVC () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView * uploadTable;

@end

@implementation FPUploadVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)initTableView
{
    self.uploadTable = [[UITableView alloc] init];
    self.uploadTable.dataSource = self;
    self.uploadTable.delegate = self;
    self.uploadTable.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT);
    [self.view addSubview:self.uploadTable];
}

#pragma mark - tableview d & d
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
