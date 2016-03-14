//
//  FPImagePickerVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPImagePickerVC.h"
#import "FPImagePickerGroupTableCell.h"
#import "FPImagePickerSelectVC.h"
#import "FPUploadVC.h"

@interface FPImagePickerVC () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}

@end

@implementation FPImagePickerVC

- (NSMutableArray *)groups
{
    if (_groups == nil)
    {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 获取所有组
    [self getAllGroupData];
    
    //创建tableview
    [self initTableView];
    
    // 设置按钮
    [self setupButtons];
    
    self.title = @"选择相册";
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)setupButtons
{
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//    
//    self.navigationItem.rightBarButtonItem = barItem;
}

#pragma mark -<UITableViewDelegate>
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * gpID = @"group_id";
    
    FPImagePickerGroupTableCell * cell = [tableView dequeueReusableCellWithIdentifier:gpID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FPImagePickerGroupTableCell" owner:nil options:nil] firstObject];
    }
    
    [cell setData:self.groups[indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ALAssetsGroup *group = self.groups[indexPath.row];
    
    FPImagePickerSelectVC * vc = [[FPImagePickerSelectVC alloc] init];
    
    vc.group = group;
    
    vc.totalCount = group.numberOfAssets;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getAllGroupData
{
    [[FPUploadVC defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group != nil)
        {
            [self.groups addObject:group];
            [_tableView reloadData];
        }
    }
    failureBlock:^(NSError *error)
    {
     
    }];
}

- (void)dealloc
{
    NSLog(@"picker delloc ---");
}


@end
