//
//  SpCourseVC.m
//  kindergartenApp
//
//  Created by Mac on 15/10/23.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseVC.h"
#import "StudentInfoHeaderView.h"
#import "SpCourseCell.h"
#import "SPCourseDomain.h"
#import "MJExtension.h"
#import "SPSchoolDomain.h"

@interface SpCourseVC () <UITableViewDataSource,UITableViewDelegate>


@end

@implementation SpCourseVC

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.tableView.rowHeight = Row_Height;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    
    [self setUpTableViewWithFrame:self.tableFrame];
}

#pragma mark - Table view data source

#pragma mark - 数据表方法
- (void)setUpTableViewWithFrame:(CGRect)rect
{
    self.tableView.frame = rect;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSourceType == 0)    //course
    {
        return self.courseListArr.count;
    }
    else if(self.dataSourceType == 1)//school
    {
        return self.schoolListArr.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"spcourse";
    SpCourseCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseCell" owner:self options:nil] firstObject];
    }
    
    if (self.dataSourceType == 0)
    {
        [cell setCourseCellData:self.courseListArr[indexPath.row]];
        
    }
    else if (self.dataSourceType == 1)
    {
        [cell setSchoolCellData:self.schoolListArr[indexPath.row]];
        
    }
    else
    {
        return nil;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - 表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.showHeaderView)
    {
        if (self.dataSourceType == 0)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
            StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
            view.titleLabel.text = @"教授课程";
            view.backgroundColor = [UIColor whiteColor];
            return view;
        }
        else
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
            StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
            view.titleLabel.text = @"热门课程";
            view.backgroundColor = [UIColor whiteColor];
            return view;
        }
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.showHeaderView)
    {
        return Cell_Height2;
    }
    else
    {
        return 0.1;
    }
}

#pragma mark - 选择单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceType == 0)  //跳转到课程详情页面
    {
        [self.delegate pushToDetailVC:self dataSourceType:0 selIndexPath:indexPath];
    }
    else if (self.dataSourceType == 1)  //跳转到学校详情页面
    {
        [self.delegate pushToDetailVC:self dataSourceType:1 selIndexPath:indexPath];
    }
}


@end
