//
//  SPTeacherDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPTeacherDetailVC.h"
#import "SPTeacherCell.h"
#import "KGHUD.h"
#import "KGHttpService.h"
#import "StudentInfoHeaderView.h"
#import "SpCourseVC.h"
#import "PromptView.h"
#import <CoreLocation/CoreLocation.h>
#import "SPCourseDomain.h"
#import "MJExtension.h"

@interface SPTeacherDetailVC () <UIWebViewDelegate,CLLocationManagerDelegate>
{
    UIView * _teacherInfoView;
    UIWebView * _webView;
    UIView * _infoHeaderView;
    UIView * _tableHeaderView;
    
    UIView * _warningView;
    
    UIScrollView *_scrollView;
}

@property (strong, nonatomic) SpCourseVC * tableVC;

@property (strong, nonatomic) NSString * mappoint;

@property (strong, nonatomic) SPTeacherDetailDomain * detailDomain;

@property (strong, nonatomic) NSArray * courseList;

@property (assign, nonatomic) CGFloat contentHeight;

@end

@implementation SPTeacherDetailVC

- (SpCourseVC *)tableVC
{
    if (_tableVC == nil)
    {
        _tableVC = [[SpCourseVC alloc] init];
        CGFloat tableX = Number_Zero;
        CGFloat tableY = _webView.frame.size.height + _teacherInfoView.frame.size.height + 30;
        CGFloat tableW = APPWINDOWWIDTH;
        CGFloat tableH = Row_Height * self.courseList.count + Cell_Height3 + Cell_Height2;
        _tableVC.tableFrame = CGRectMake(tableX, tableY, tableW, tableH);
    }
    return _tableVC;
}

- (NSArray * )courseList
{
    if (_courseList == nil)
    {
        _courseList = [NSArray array];
    }
    return _courseList;
}

- (SPTeacherDetailDomain *)detailDomain
{
    if (_detailDomain == nil)
    {
        _detailDomain = [[SPTeacherDetailDomain alloc] init];
    }
    return _detailDomain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"教师详情";
    
    //创建scrollview
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT);
    [self.view addSubview:_scrollView];
    
    //创建顶部学校信息view
    _teacherInfoView = [[UIView alloc] init];
    _teacherInfoView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, 150);
    [self addInfoCell:_teacherInfoView];
    
    //创建webview头view
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
    StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
    view.titleLabel.text = @"简介";
    view.backgroundColor = [UIColor whiteColor];
    [view setOrigin:CGPointMake(0,100+20)];
    [_scrollView addSubview:view];
    
    //请求老师详情
    [self getTeacherDetail];
    
}

- (void)setUpWebView
{
    [self getContextHeight:self.detailDomain.content type:@"teacherDetail"];
}

#pragma mark - 请求老师详情
- (void)getTeacherDetail
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPTeacherDetail:self.domain.uuid success:^(SPTeacherDetailDomain *teacherDomain)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        self.detailDomain = teacherDomain;
        
        [self setUpWebView];
        
        //请求课程列表
        [self getCourseList];
        
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 请求课程列表
- (void)getCourseList
{
    [[KGHUD sharedHud] show:self.view];
    
    if (self.mappoint == nil)
    {
        self.mappoint = @"";
    }
    
    [[KGHttpService sharedService] getSPCourseList:@"" map_point:@"" type:@"" sort:@"" teacheruuid:self.domain.uuid pageNo:@"" success:^(SPDataListVO *spCourseList)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        NSMutableArray * marr = [NSMutableArray array];
        
        for (NSDictionary * dict in spCourseList.data)
        {
            SPCourseDomain * model = [SPCourseDomain objectWithKeyValues:dict];
            [marr addObject:model];
        }
        
        self.courseList = marr;
        if (self.courseList.count == 0 || self.courseList == nil)
        {
            [self setUpWarningView];
        }
        else
        {
            [self setUpTableView];
            
            dispatch_async(dispatch_get_main_queue(), ^
            {
                self.contentHeight = CGRectGetMaxY(self.tableVC.tableView.frame);
                _scrollView.contentSize = CGSizeMake(0, self.contentHeight);
            });

            [_tableVC.tableView reloadData];
        }
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 创建没有数据提示view
- (void)setUpWarningView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
    StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
    view.titleLabel.text = @"教授课程";
    view.backgroundColor = [UIColor whiteColor];
    [view setOrigin:CGPointMake(0,_webView.frame.size.height + _teacherInfoView.frame.size.height)];
    [_scrollView addSubview:view];
    
    _warningView = [[[NSBundle mainBundle] loadNibNamed:@"PromptView" owner:nil options:nil] firstObject];
    
    [_warningView setOrigin:CGPointMake(0, 44 + _webView.frame.size.height + _teacherInfoView.frame.size.height)];
    
    [_scrollView addSubview:_warningView];
}

#pragma mark - 创建tableview
- (void)setUpTableView
{
    self.tableVC.courseListArr = self.courseList;
    
    self.tableVC.dataSourceType = 0;
    
    self.tableVC.showHeaderView = YES;
    
    [_scrollView addSubview:self.tableVC.tableView];
}

#pragma mark - 创建顶部teacherinfo
- (void)addInfoCell:(UIView *)view
{
    SPTeacherCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"SPTeacherCell" owner:nil options:nil] firstObject];
    
    CGFloat padding = (APPWINDOWWIDTH - 320) / 2;
    
    [cell setOrigin:CGPointMake(padding, 0)];
    
    //设置数据
    [cell setTeacherCellData:self.domain];
    
    [_teacherInfoView addSubview:cell];
    
    [_scrollView addSubview:_teacherInfoView];
}

- (void)getContextHeight:(NSString *)context type:(NSString *)type
{
    if (context == nil || [context isEqualToString:@""])
    {
        context = @"暂无内容";
    }
    
    _webView = [[UIWebView alloc] init];
    
    _webView.delegate = self;
    
    NSString * filename = [NSString stringWithFormat:@"Documents/%@-%@.html",type,self.domain.uuid];
    
    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    [context writeToFile:filePath atomically:YES encoding:NSUnicodeStringEncoding error:nil];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:filePath]]];
    
    _webView.scrollView.scrollEnabled = NO;
    
    [_scrollView addSubview:_webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)wb
{
    CGRect frame = wb.frame;
    
    frame.size.width = APPWINDOWWIDTH;
    
    frame.size.height = 1;
    
    wb.frame = frame;
    
    frame.size.height = wb.scrollView.contentSize.height;
    
    wb.frame = frame;
    
    _webView.frame = CGRectMake(0,100 + 44 + 20, APPWINDOWWIDTH, wb.frame.size.height + 15);

}

@end
