//
//  SPSchoolDetailTableVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPSchoolDetailTableVC.h"
#import "SpCourseCell.h"
#import "SPTeacherCell.h"
#import "SPCourseDetailVC.h"

@interface SPSchoolDetailTableVC ()

@end

@implementation SPSchoolDetailTableVC

- (NSMutableArray *)courseList
{
    if (_courseList == nil)
    {
        _courseList = [NSMutableArray array];
    }
    return _courseList;
}

- (NSMutableArray *)teacherList
{
    if (_teacherList == nil)
    {
        _teacherList = [NSMutableArray array];
    }
    return _teacherList;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = Row_Height;
    self.tableView.frame = self.tableRect;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSourceType == 0)
    {
        return self.courseList.count;
    }
    else if (self.dataSourceType == 1)
    {
        return self.teacherList.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceType == 0)  //课程列表
    {
        SpCourseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"spcourse"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseCell" owner:nil options:nil] firstObject];
        }
        
        [cell setCourseCellData:self.courseList[indexPath.row]];
        
        return cell;
    }
    else if (self.dataSourceType == 1)
    {
        SPTeacherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"teachercell"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SPTeacherCell" owner:nil options:nil] firstObject];
        }
        
        [cell setTeacherCellData:self.teacherList[indexPath.row]];
        
        return cell;
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceType == 0)  //课程列表
    {
        [self.delegate pushToDetailVC:self dataSourceType:0 selIndexPath:indexPath];
    }
    else if (self.dataSourceType == 1) //老师列表
    {
        [self.delegate pushToDetailVC:self dataSourceType:1 selIndexPath:indexPath];
    }
}

@end
