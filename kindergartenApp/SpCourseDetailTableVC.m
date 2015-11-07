//
//  SpCourseDetailTableVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseDetailTableVC.h"
#import "SPCouseInfoCell.h"
#import "SPTextCell.h"
#import "SPCommentDomain.h"
#import "SPPresentsComment.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "StudentInfoHeaderView.h"
#import "SPSchoolTextCell.h"
#import "SPTextCellOfCourse.h"
#import "MJRefresh.h"

@interface SpCourseDetailTableVC () <UIWebViewDelegate>
{
    SPCouseInfoCell * _courseInfoCell;
    SPTextCell * _courseTextCell;
    SPSchoolTextCell * _schoolTextCell;
}

@property (strong, nonatomic) NSMutableArray * commentsCells;

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) NSString * groupuuid;

@end

@implementation SpCourseDetailTableVC

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
    }
    return self;
}

- (NSMutableArray *)commentsCells
{
    if (_commentsCells == nil)
    {
        _commentsCells = [NSMutableArray array];
    }
    return _commentsCells;
}

- (NSArray *)presentsComments
{
    if (_presentsComments == nil)
    {
        _presentsComments = [NSArray array];
    }
    return _presentsComments;
}

- (SPCourseDetailDomain *)courseDetailDomain
{
    if (_courseDetailDomain == nil)
    {
        _courseDetailDomain = [[SPCourseDetailDomain alloc] init];
    }
    return _courseDetailDomain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRefresh];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.frame = self.tableFrame;
    self.tableView.hidden = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;

        case 1:
            return 1;

        case 2:
        {
            if (self.presentsComments.count == 0)
            {
                return 1;
            }
            
            if (self.presentsComments.count > 3)
            {
                return 4;
            }
            else
            {
                return self.presentsComments.count;
            }
        }

        case 3:
            return 1;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SPCouseInfoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"SPCouseInfoCell" owner:self options:nil] firstObject];
        
        _courseInfoCell = cell;
        
        cell.domain = self.courseDetailDomain;
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        SPTextCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"SPTextCell" owner:self options:nil] firstObject];
        
        _courseTextCell = cell;
        
        [cell setContext:self.courseDetailDomain.context withTableVC:self];
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        if (self.presentsComments.count == 0)
        {
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            
            cell.textLabel.text = @"暂无家长评论";
            
            return cell;
        }
        if (indexPath.row == 3)
        {
            UITableViewCell * cell = [[UITableViewCell alloc] init];
            
            cell.textLabel.text = @"查看更多家长评价";
            
            return cell;
        }
        else
        {
            SPPresentsComment * cell = [[SPPresentsComment alloc] init];
            
            cell.domain = self.presentsComments[indexPath.row];
            
            [self.commentsCells addObject:cell];
            
            return cell;
        }
        
    }
    else if (indexPath.section == 3)
    {
        SPSchoolTextCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"SPSchoolTextCell" owner:self options:nil] firstObject];
        
        _schoolTextCell = cell;
        
        [cell setContext:self.schoolDomain.groupDescription withTableVC:self];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return _courseInfoCell.rowHeight;
    }
    
    if (indexPath.section == 1)
    {
        return self.courseRowHeight + 35;
    }

    if (indexPath.section == 2)
    {
        if (self.presentsComments.count == 0)
        {
            return 44;
        }
        else
        {
            SPPresentsComment * commentCell = self.commentsCells[indexPath.row];
            
            return commentCell.rowHeight;
        }
    }

    if (indexPath.section == 3)
    {
        return self.schollRowHeight;
    }
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            
        }
    }
}

#pragma mark - 表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
        StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
        view.titleLabel.text = @"课程详细信息";
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    else if (section == 2)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
        StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
        view.titleLabel.text = @"家长评价";
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    else if (section == 3)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
        StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
        view.titleLabel.text = @"学校介绍";
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2 || section == 3)
    {
        return Cell_Height2;
    }
    else
    {
        return 0.1;
    }
}

#pragma mark - 上拉刷新，下拉加载数据
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉加载学校介绍";
    self.tableView.footerReleaseToRefreshText = @"松开立即加载";
    self.tableView.footerRefreshingText = @"正在加载学校介绍中...";
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    [self getSchoolData];
    
}

#pragma mark - 请求学校详情
- (void)getSchoolData
{
    [[KGHttpService sharedService] getSPCourseDetailSchoolInfo:self.courseDetailDomain.groupuuid success:^(SPSchoolDomain *spSchoolDetail)
    {
        self.schoolDomain = spSchoolDetail;
        
        [self getContextHeight:self.schoolDomain.groupDescription type:@"school"]; //高度出来了
        
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.tableView onlyMsg:errorMsg];
    }];
}

- (void)getContextHeight:(NSString *)context type:(NSString *)type
{
    _webView = [[UIWebView alloc] init];
    
    _webView.delegate = self;
    
    NSString * filename = [NSString stringWithFormat:@"Documents/%@-%@.html",type,self.uuid];
    
    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    [context writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:filePath]]];
    
    _webView.alpha = 0;
    
    [self.view addSubview:_webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)wb
{
    CGRect frame = wb.frame;
    frame.size.width = APPWINDOWWIDTH;
    frame.size.height = 1;
    
    wb.frame = frame;
    
    frame.size.height = wb.scrollView.contentSize.height;
    
    wb.frame = frame;
    
    self.schollRowHeight = wb.frame.size.height;

    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:3];
    
    NSArray * arr = [NSArray arrayWithObject:ip];
    
    [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationRight];
    
    [self.tableView footerEndRefreshing];
    
    [self.tableView addFooterWithTarget:self action:@selector(haveNoDataWarning)];
    self.tableView.footerPullToRefreshText = @"";
    self.tableView.footerReleaseToRefreshText = @"没有更多了";
    self.tableView.footerRefreshingText = @"没有更多了...";
}

- (void)haveNoDataWarning
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [self.tableView footerEndRefreshing];
    });
}


@end
