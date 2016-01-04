//
//  YouHuiTableVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "YouHuiTableVC.h"
#import "YouHuiCell.h"

@interface YouHuiTableVC ()

@end

@implementation YouHuiTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.rowHeight = 90;
    
    [self.tableView setFrame:self.tableRect];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YouHuiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"youhuicell"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YouHuiCell" owner:nil options:nil] firstObject];
    }
    
    [cell setData:self.dataArr[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate pushToDetailVC:self uuid:((YouHuiDomain *)self.dataArr[indexPath.row]).uuid title:((YouHuiDomain *)self.dataArr[indexPath.row]).title];
}



@end
