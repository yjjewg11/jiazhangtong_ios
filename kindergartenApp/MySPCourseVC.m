//
//  MySPCourseVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseVC.h"
#import "MYSPCourseTableVC.h"
#import "KGHUD.h"
#import "KGHttpService.h"
#import "MySPCourseDomain.h"
#import "MJExtension.h"
#import "MySPCourseDetailVC.h"

@interface MySPCourseVC () <UIScrollViewDelegate,MYSPCourseTableVCDelegate>

@property (strong, nonatomic) UIView * topSelView;

@property (strong, nonatomic) UIButton * nowStudyBtn;

@property (strong, nonatomic) UIButton * endStudyBtn;

@property (strong, nonatomic) UIImageView * sepView;

@property (strong, nonatomic) UIImageView * pointerView;

@property (strong, nonatomic) MYSPCourseTableVC * tableViewStudying;

@property (strong, nonatomic) MYSPCourseTableVC * tableViewEnding;

@property (strong, nonatomic) UIScrollView * scrollView;

@property (strong, nonatomic) NSArray * nowStudyArr;

@property (strong, nonatomic) NSArray * endStudyArr;

@end

@implementation MySPCourseVC

- (NSArray *)nowStudyArr
{
    if (_nowStudyArr == nil)
    {
        _nowStudyArr = [NSArray array];
    }
    return _nowStudyArr;
}

- (NSArray *)endStudyArr
{
    if (_endStudyArr == nil)
    {
        _endStudyArr = [NSArray array];
    }
    return _endStudyArr;
}

- (MYSPCourseTableVC *)tableViewStudying
{
    if (_tableViewStudying == nil)
    {
        _tableViewStudying = [[MYSPCourseTableVC alloc] init];
        _tableViewStudying.tableFrame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - (APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 30));
        _tableViewStudying.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableViewStudying.dataSourceType = 0;
        _tableViewStudying.delegate = self;
    }
    return _tableViewStudying;
}

- (MYSPCourseTableVC *)tableViewEnding
{
    if (_tableViewEnding == nil)
    {
        _tableViewEnding = [[MYSPCourseTableVC alloc] init];
        _tableViewEnding.tableFrame = CGRectMake(APPWINDOWWIDTH, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - (APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 30));
        _tableViewEnding.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableViewEnding.dataSourceType = 1;
        _tableViewEnding.delegate = self;
    }
    return _tableViewEnding;
}

- (UIImageView *)sepView
{
    if (_sepView == nil)
    {
        _sepView = [[UIImageView alloc] initWithFrame:CGRectMake(APPWINDOWWIDTH / 2, 5, 1, 20)];
        _sepView.image = [UIImage imageNamed:@"fengexian"];
    }
    return _sepView;
}

- (UIView *)topSelView
{
    if (_topSelView == nil)
    {
        _topSelView = [[UIView alloc] initWithFrame:CGRectMake(0, APPSTATUSBARHEIGHT + APPTABBARHEIGHT, APPWINDOWWIDTH, 30)];
        
        _topSelView.backgroundColor = [UIColor whiteColor];
    }
    return _topSelView;
}

- (UIButton *)nowStudyBtn
{
    if (_nowStudyBtn == nil)
    {
        _nowStudyBtn = [[UIButton alloc] initWithFrame:CGRectMake(APPWINDOWWIDTH / 2 - 85, 0, 80, 25)];
        
        [_nowStudyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_nowStudyBtn setTitle:@"正在学习" forState:UIControlStateNormal];
        
        [_nowStudyBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
    }
    return _nowStudyBtn;
}

- (UIButton *)endStudyBtn
{
    if (_endStudyBtn == nil)
    {
        _endStudyBtn = [[UIButton alloc] initWithFrame:CGRectMake(APPWINDOWWIDTH / 2 + 5, 0, 80, 25)];
        
        [_endStudyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_endStudyBtn setTitle:@"学习完成" forState:UIControlStateNormal];
        
        [_endStudyBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _endStudyBtn;
}

- (UIImageView *)pointerView
{
    if (_pointerView == nil)
    {
        _pointerView = [[UIImageView alloc] initWithFrame:CGRectMake(APPWINDOWWIDTH / 2 - 80, 24, 70, 5)];
        
        _pointerView.image = [UIImage imageNamed:@"xiamian"];
    }
    return _pointerView;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.frame = CGRectMake(0, APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 30, APPWINDOWWIDTH, APPWINDOWHEIGHT - (APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 30));
        _scrollView.contentSize = CGSizeMake(APPWINDOWWIDTH * 2, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的特长课程";
    
    [self.topSelView addSubview:self.sepView];
    
    [self.topSelView addSubview:self.nowStudyBtn];
    
    [self.topSelView addSubview:self.endStudyBtn];
    
    [self.topSelView addSubview:self.pointerView];
    
    [self.view addSubview:self.topSelView];
    
    [self.scrollView addSubview:self.tableViewStudying.tableView];
    
    [self.scrollView addSubview:self.tableViewEnding.tableView];
    
    [self.view addSubview:self.scrollView];
    
    [self getMySPStudyingCourseListData];
    
    [self getMySPEndingCourseListData];
}


#pragma mark - 请求正在学学习数据
- (void)getMySPStudyingCourseListData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] MySPCourseList:@"" isdisable:@"0" success:^(SPDataListVO *msg)
    {
        self.tableViewStudying.studyingCourseArr = [NSMutableArray arrayWithArray:[MySPCourseDomain objectArrayWithKeyValuesArray:msg.data]];
        
        self.nowStudyArr = [NSMutableArray arrayWithArray:[MySPCourseDomain objectArrayWithKeyValuesArray:msg.data]];
        
        [[KGHUD sharedHud] hide:self.view];
        
        [self.tableViewStudying.tableView reloadData];
        
    }
    faild:^(NSString *errorMsg)
    {
        
    }];
}

#pragma mark - 请求已完成数据
- (void)getMySPEndingCourseListData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] MySPCourseList:@"" isdisable:@"1" success:^(SPDataListVO *msg)
    {
        self.tableViewEnding.endingCourseArr = [NSMutableArray arrayWithArray:[MySPCourseDomain objectArrayWithKeyValuesArray:msg.data]];
     
        self.endStudyArr = [NSMutableArray arrayWithArray:[MySPCourseDomain objectArrayWithKeyValuesArray:msg.data]];
        
        [[KGHUD sharedHud] hide:self.view];
        
        [self.tableViewEnding.tableView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        
    }];
}

#pragma mark - scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat index = (self.scrollView.contentOffset.x / APPWINDOWWIDTH);
    
    if (index <= 0.5)
    {
        [UIView animateWithDuration:0.4 animations:^
        {
            [self.pointerView setCenter:CGPointMake(self.nowStudyBtn.centerX, self.pointerView.centerY)];
        }];
    }
    else if (index > 0.5)
    {
        [UIView animateWithDuration:0.4 animations:^
        {
            [self.pointerView setCenter:CGPointMake(self.endStudyBtn.centerX, self.pointerView.centerY)];
        }];
    }
    
}

#pragma mark - 页面跳转代理
- (void)pushToDetailVC:(MYSPCourseTableVC *)vc dataSourseType:(NSInteger)dataScourseType selIndexPath:(NSIndexPath *)indexPath
{
    MySPCourseDetailVC * detailVC = [[MySPCourseDetailVC alloc] init];
    
    if (dataScourseType == 0)
    {
        detailVC.domain = self.nowStudyArr[indexPath.row];
    }
    else if (dataScourseType == 1)
    {
        detailVC.domain = self.endStudyArr[indexPath.row];
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
