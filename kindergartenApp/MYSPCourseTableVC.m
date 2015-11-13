//
//  MYSPCourseTableVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MYSPCourseTableVC.h"
#import "MYSPCourseTableViewCell.h"

@interface MYSPCourseTableVC () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation MYSPCourseTableVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.dataSource = self;
    
    self.tableView.frame = self.tableFrame;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSourceType == 0)
    {
        return self.studyingCourseArr.count;
    }
    else if(self.dataSourceType == 1)
    {
        return self.endingCourseArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYSPCourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mysp"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MYSPCourseTableViewCell" owner:nil options:nil] firstObject];;
    }

    if (self.dataSourceType == 0)
    {
        [cell setData:self.studyingCourseArr[indexPath.row]];
    }
    else if (self.dataSourceType == 1)
    {
        [cell setData:self.endingCourseArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate pushToDetailVC:self dataSourseType:self.dataSourceType selIndexPath:indexPath];
}

@end
