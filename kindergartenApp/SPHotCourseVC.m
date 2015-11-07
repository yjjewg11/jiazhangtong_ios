//
//  SPHotCourseVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPHotCourseVC.h"
#import "SpCourseCell.h"


@interface SPHotCourseVC () <UITableViewDataSource,UITableViewDelegate>


@end

@implementation SPHotCourseVC

- (NSMutableArray *)hotSpCourses
{
    if(_hotSpCourses == nil)
    {
        _hotSpCourses = [NSMutableArray array];
    }
    return _hotSpCourses;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.scrollEnabled = NO;
    
    self.tableView.rowHeight = Row_Height;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self setUpTableViewWithFrame:self.tableFrame];
}

- (void)setUpTableViewWithFrame:(CGRect)rect
{
    self.tableView.frame = rect;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotSpCourses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"spcourse";
    SpCourseCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseCell" owner:self options:nil] firstObject];
    }
    
    //设置数据
    [cell setCourseCellData:self.hotSpCourses[indexPath.row]];
    
    return cell;
}

#pragma mark - 表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
    StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
    view.titleLabel.text = @"热门课程";
    view.backgroundColor = [UIColor whiteColor];
    [view.funBtn addTarget:self action:@selector(hotHeaderClick) forControlEvents:UIControlEventTouchDown];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Cell_Height2;
}

- (void)hotHeaderClick
{
    [self.delegate spHotCourseVCSearchAllCourse:self];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate pushToDetailVC:self dataSourceType:0 selIndexPath:indexPath];
}


@end
