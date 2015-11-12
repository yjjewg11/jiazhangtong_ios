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

@interface MySPCourseVC ()

@property (strong, nonatomic) UIView * topSelView;

@property (strong, nonatomic) UIButton * nowStudyBtn;

@property (strong, nonatomic) UIButton * endStudyBtn;

@property (strong, nonatomic) UIImageView * sepView;

@property (strong, nonatomic) UIImageView * pointerView;

@property (strong, nonatomic) MYSPCourseTableVC * tableViewStudying;

@property (strong, nonatomic) MYSPCourseTableVC * tableViewEnding;

@property (strong, nonatomic) UIScrollView * scrollView;

@end

@implementation MySPCourseVC

- (MYSPCourseTableVC *)tableViewStudying
{
    if (_tableViewStudying == nil)
    {
        _tableViewStudying = [[MYSPCourseTableVC alloc] init];
        _tableViewStudying.tableFrame = CGRectMake(0, APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 30, APPWINDOWWIDTH, APPWINDOWHEIGHT - (APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 30));
        _tableViewStudying.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableViewStudying.dataSourceType = 0;
    }
    return _tableViewStudying;
}

- (MYSPCourseTableVC *)tableViewEnding
{
    if (_tableViewEnding == nil)
    {
        _tableViewEnding = [[MYSPCourseTableVC alloc] init];
        _tableViewEnding.tableFrame = CGRectMake(APPWINDOWWIDTH, APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 30, APPWINDOWWIDTH, APPWINDOWHEIGHT - (APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 30));
        _tableViewEnding.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableViewEnding.dataSourceType = 1;
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
        _scrollView.frame = CGRectMake(0, APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 30, APPWINDOWWIDTH * 2, APPWINDOWHEIGHT - (APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 30));
        _scrollView.contentSize = CGSizeMake(APPWINDOWWIDTH * 2, 0);
        _scrollView.pagingEnabled = YES;
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

- (void)getMySPStudyingCourseListData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] MySPCourseList:@"" isdisable:@"0" success:^(SPDataListVO *msg)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        self.tableViewStudying.studyingCourseArr = [NSMutableArray arrayWithArray:[MySPCourseDomain objectArrayWithKeyValuesArray:msg.data]];
        
        [self.tableViewStudying.tableView reloadData];
        
    }
    faild:^(NSString *errorMsg)
    {
        
    }];
}

- (void)getMySPEndingCourseListData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] MySPCourseList:@"" isdisable:@"1" success:^(SPDataListVO *msg)
    {
        [[KGHUD sharedHud] hide:self.view];
         
        self.tableViewStudying.endingCourseArr = [NSMutableArray arrayWithArray:[MySPCourseDomain objectArrayWithKeyValuesArray:msg.data]];
        
        [self.tableViewEnding.tableView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
