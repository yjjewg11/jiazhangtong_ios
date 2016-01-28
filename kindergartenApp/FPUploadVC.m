//
//  FPUploadVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPUploadVC.h"
#import "FPImagePickerVC.h"

@interface FPUploadVC () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView * uploadTable;

@property (nonatomic , strong) NSArray * assets;

@end

@implementation FPUploadVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self initTableView];
    
    //在右上角添加一个按钮来选择图片
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(openSelectImageView)];
    barbtn.title = @"选择图片";
    barbtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = barbtn;
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

- (void)openSelectImageView
{
    FPImagePickerVC * vc = [[FPImagePickerVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc
{
    NSLog(@"upload delloc ---");
}

@end
