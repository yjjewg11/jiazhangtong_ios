//
//  SpTeacherDetailViewController.m
//  kindergartenApp
//
//  Created by Mac on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpTeacherDetailViewController.h"
#import "KGHttpService.h"
#import "SPTeacherDomain.h"
#import "SPCourseDomain.h"
#import "MJExtension.h"
#import "SpTeacherDetailLayout.h"
#import "MJRefresh.h"
#import "SpCourseHomeCourseCell.h"
#import "SpTeacherInfoCell.h"
#import "SpTeacherDetailWebViewCell.h"
#import "SPCourseDetailVC.h"

@interface SpTeacherDetailViewController () <UIWebViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView * _collectionView;
    
    NSString * _mappoint;
    
    SPTeacherDetailDomain * _teacherDomain;
    
    NSMutableArray * _courseList;
    
    //用于计算content高度的webview
    UIWebView * _webView;
    
    SpTeacherDetailLayout * _layout;
    
    BOOL _canReqData;
    
    NSInteger _pageNo;
}

@end

@implementation SpTeacherDetailViewController

static NSString *const TeacherInfoCellID = @"teacherinfocoll";
static NSString *const ContentCellID = @"contentcoll";
static NSString *const CourseCellID = @"coursecellcoll";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"教师详情";
    
    _pageNo = 2;
    
    //读取坐标
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    _mappoint = [defu objectForKey:@"map_point"];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //获取老师数据
    [self getTeacherData];
    
    [self initCollectionView];
}

#pragma mark - 请求老师详情
- (void)getTeacherData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getSPTeacherDetail:self.teacheruuid success:^(SPTeacherDetailDomain *teacherDomain)
    {
        _teacherDomain = teacherDomain;
        
        [self getCourseList];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

#pragma mark - 请求课程列表
- (void)getCourseList
{
    if (_mappoint == nil)
    {
        _mappoint = @"";
    }
    
    [[KGHttpService sharedService] getSPCourseList:@"" map_point:@"" type:@"" sort:@"" teacheruuid:_teacherDomain.uuid pageNo:@"" success:^(SPDataListVO *spCourseList)
     {
         _courseList = [NSMutableArray arrayWithArray:[SPCourseDomain objectArrayWithKeyValuesArray:spCourseList.data]];
         
         if (_courseList.count == 0 || _courseList == nil)
         {
             //创建没有数据提示 view
         }
         else
         {
             [self calWebViewCellHeight:_teacherDomain.content];
         }
     }
     faild:^(NSString *errorMsg)
     {
         [self showNoNetView];
     }];
}

#pragma mark - 计算webviewcell内容的高度
- (void)calWebViewCellHeight:(NSString *)content
{
    if (content == nil || [content isEqualToString:@""])
    {
        content = @"暂无内容";
    }
    
    _webView = [[UIWebView alloc] init];
    
    _webView.delegate = self;
    
    NSString * filename = [NSString stringWithFormat:@"Documents/%@:%@.html",self.title,_teacherDomain.uuid];
    
    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    [content writeToFile:filePath atomically:YES encoding:NSUnicodeStringEncoding error:nil];
    
 //   [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:filePath]]];
    
    [_webView loadData:[NSData dataWithContentsOfFile:filePath] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:filePath]];
    
    _webView.scrollView.scrollEnabled = NO;
    
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
    
    _layout.webcellHeight = wb.frame.size.height;
    
    [self hidenLoadView];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - 没有网络连接重试代理
- (void)tryBtnClicked
{
    [self hidenNoNetView];
    
    //获取老师数据
    [self getTeacherData];
    
    [self initCollectionView];
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    SpTeacherDetailLayout *layout = [[SpTeacherDetailLayout alloc] init];
    
    _layout = layout;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SpTeacherInfoCell" bundle:nil] forCellWithReuseIdentifier:TeacherInfoCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SpTeacherDetailWebViewCell" bundle:nil] forCellWithReuseIdentifier:ContentCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SpCourseHomeCourseCell" bundle:nil] forCellWithReuseIdentifier:CourseCellID];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self setupRefresh];
}

#pragma mark - 上拉刷新，下拉加载数据
- (void)setupRefresh
{
    [_collectionView addFooterWithTarget:self action:@selector(footerRereshing) showActivityView:YES];
    _collectionView.footerPullToRefreshText = @"上拉加载更多";
    _collectionView.footerReleaseToRefreshText = @"松开立即加载";
    _collectionView.footerRefreshingText = @"正在加载中...";
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        _collectionView.footerRefreshingText = @"没有更多了";
        [_collectionView footerEndRefreshing];
    });
}

#pragma mark - collection的数据源 & 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2 + _courseList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        SpTeacherInfoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeacherInfoCellID forIndexPath:indexPath];
        
        [cell setData:_teacherDomain];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        SpTeacherDetailWebViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ContentCellID forIndexPath:indexPath];
        
        [cell setData:_teacherDomain.content];
        
        return cell;
    }
    else
    {
        SpCourseHomeCourseCell * courseCell = [collectionView dequeueReusableCellWithReuseIdentifier:CourseCellID forIndexPath:indexPath];
        
        [courseCell setCourseCellData:_courseList[indexPath.row - 2]];
        
        return courseCell;
    }
    
    return nil;
}

#pragma mark - 自动翻页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    if(currentOffset >= maximumOffset)
    {
        if (_canReqData == YES)
        {
            _canReqData = NO;
            
            [[KGHttpService sharedService] getSPCourseList:@"" map_point:@"" type:@"" sort:@"" teacheruuid:_teacherDomain.uuid pageNo:[NSString stringWithFormat:@"%ld",(long)_pageNo] success:^(SPDataListVO *spCourseList)
             {
                 NSMutableArray * marr = [NSMutableArray arrayWithArray:[SPCourseDomain objectArrayWithKeyValuesArray:spCourseList.data]];
                 
                 if (marr.count == 0)
                 {
                    
                 }
                 else
                 {
                     _pageNo++;
                     [_courseList addObjectsFromArray:marr];
                     [_collectionView reloadData];
                     
                     _canReqData = YES;
                 }
                 
             }
             faild:^(NSString *errorMsg)
             {
                 [self showNoNetView];
             }];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 2)
    {
        SPCourseDetailVC * vc = [[SPCourseDetailVC alloc] init];
        
        SPCourseDomain * domain = _courseList[indexPath.row - 2];
        
        vc.uuid = domain.uuid;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
