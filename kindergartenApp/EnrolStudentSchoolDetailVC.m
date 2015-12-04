//
//  EnrolStudentSchoolDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentSchoolDetailVC.h"
#import "MJRefresh.h"
#import "KGHttpService.h"
#import "EnrolStudentSchoolDetailDomain.h"
#import "MJExtension.h"
#import "EnrolStudentSchoolDetailLayout.h"
#import "EnrolStudentsSchoolCell.h"
#import "EnrolStudentsSchoolDomain.h"
#import "EnrolStudentButtonCell.h"
#import "EnrolStudentWebViewCell.h"
#import "EnrolStudentSchoolCommentDomain.h"
#import "KGNSStringUtil.h"
#import "EnrolStudentCommentCell.h"
#import "KGHUD.h"
#import "NoDataView.h"
#import "EnrolStudentSchoolDetailFullScreenLayout.h"

#define DataSource_ZhaoSheng 0
#define DataSource_JianJie 1
#define DataSource_PingLun 2

@interface EnrolStudentSchoolDetailVC () <UICollectionViewDelegate,UICollectionViewDataSource,EnrolStudentButtonCellDelegate,EnrolStudentWebViewCellDelegate>
{
    UICollectionView * _collectionView;
    
    NSString * _mappoint;
    
    EnrolStudentDataVO * _voData;
    
    EnrolStudentSchoolDetailDomain * _domainData;
    
    EnrolStudentsSchoolDomain * _schoolDomain;
    
    EnrolStudentSchoolDetailLayout * _oriLayout;
    
    EnrolStudentSchoolDetailFullScreenLayout * _newLayout;
    
    NSInteger _dataSourceType;
    
    NSMutableArray * _commentsData;
    NSMutableArray * _dataHeights;
    
    BOOL _haveCommentData;
    BOOL _haveSummary;
    
    CGFloat _yPoint;
    
    EnrolStudentWebViewCell * _webCell;
}

@end

@implementation EnrolStudentSchoolDetailVC

static NSString *const CommentCellID = @"commentcellcoll";
static NSString *const ButtonCellID = @"btncellcoll";
static NSString *const WebCellID = @"webcellcoll";
static NSString *const SchoolCellID = @"schoolcellcoll";
static NSString *const NoDataCell = @"nodata";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"学校详情";
    
    _haveCommentData = NO;
    
    //设置手势
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [self.view addGestureRecognizer:recognizer];
    
    //读取坐标
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    _mappoint = [defu objectForKey:@"map_point"];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //创建底部按钮
    
    
    //请求学校详情
    [self getSchoolDetailData];
    
    [self initCollectionView];
}

#pragma mark - 手势触发方法
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [_collectionView setCollectionViewLayout:_oriLayout animated:YES];
        
        _webCell.webView.userInteractionEnabled = NO;
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        if (_newLayout == nil)
        {
            EnrolStudentSchoolDetailFullScreenLayout * newLayout = [[EnrolStudentSchoolDetailFullScreenLayout alloc] init];
            
            _newLayout = newLayout;
            
            _newLayout.haveSummary = _haveSummary;
            
            if (_dataSourceType == DataSource_PingLun)
            {
                _newLayout.isCommentCell = YES;
                
                _newLayout.commentsCellHeights = _dataHeights;
            }
            else
            {
                _newLayout.isCommentCell = NO;

            }
        }
        
        [_collectionView setCollectionViewLayout:_newLayout animated:YES];
        
        _webCell.webView.userInteractionEnabled = YES;
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"swipe left");
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"swipe right");
    }
}

- (void)pullDownTopView
{
    [_collectionView setCollectionViewLayout:_oriLayout animated:YES];
    
    _webCell.webView.userInteractionEnabled = NO;
}

#pragma mark - 请求数据 - 首次进入
- (void)getSchoolDetailData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getZhaoShengSchoolDetail:self.groupuuid mappoint:_mappoint success:^(EnrolStudentDataVO *vo)
    {
        [self hidenLoadView];
        _voData = vo;
        _domainData = [EnrolStudentSchoolDetailDomain objectWithKeyValues:vo.data];
        _schoolDomain = [EnrolStudentsSchoolDomain objectWithKeyValues:vo.data];
        _schoolDomain.distance = vo.distance;
        
        if (_schoolDomain.summary == nil || [_schoolDomain.summary isEqualToString:@""])
        {
            _haveSummary = NO;
        }
        else
        {
            _haveSummary = YES;
        }
        
        _oriLayout.haveSummary = _haveSummary;
        
        [self.view addSubview:_collectionView];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

#pragma mark - 请求评论
- (void)getCommentData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseComment:self.groupuuid pageNo:@"" success:^(SPCommentVO *commentVO)
    {
        _commentsData = [NSMutableArray arrayWithArray:[EnrolStudentSchoolCommentDomain objectArrayWithKeyValuesArray:commentVO.data]];
        if (_commentsData.count == 0)
        {
            _haveCommentData = NO;
            
            [[KGHUD sharedHud] hide:self.view];
            
            [_collectionView reloadData];
        }
        else
        {
            _haveCommentData = YES;
            //计算所有数据的行高
            [self calCommentsDataHeight];
            
            [[KGHUD sharedHud] hide:self.view];
            
            [_collectionView reloadData];
        }

    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 计算评论内容的高度
- (void)calCommentsDataHeight
{
    if (_dataHeights == nil)
    {
        _dataHeights = [NSMutableArray array];
    }
    
    for (EnrolStudentSchoolCommentDomain * domain in _commentsData)
    {
        CGFloat height = [KGNSStringUtil heightForString:domain.content andWidth:KGSCREEN.size.width - 20];
        
        [_dataHeights addObject:@(height)];
    }
    
    //给布局传递
    _oriLayout.commentsCellHeights = _dataHeights;
}

#pragma mark - coll datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataSourceType == DataSource_ZhaoSheng || _dataSourceType == DataSource_JianJie)
    {
        return 3;
    }
    else if (_dataSourceType == DataSource_PingLun)
    {
        if (_haveCommentData == YES)
        {
            return 2 + _commentsData.count;
        }
        else
        {
            return 3;
        }
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        EnrolStudentsSchoolCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SchoolCellID forIndexPath:indexPath];
        
        [cell setData:_schoolDomain];
        
        return cell;
    }
    
    else if (indexPath.row == 1)
    {
        EnrolStudentButtonCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ButtonCellID forIndexPath:indexPath];
        
        cell.delegate = self;
        
        return cell;
    }
    else
    {
        
        EnrolStudentWebViewCell * webcell = [collectionView dequeueReusableCellWithReuseIdentifier:WebCellID forIndexPath:indexPath];
        
        webcell.delegate = self;
        
        _webCell = webcell;
        
        
        if (_dataSourceType == DataSource_ZhaoSheng)
        {
            [webcell setData:_voData.recruit_url];
            
            return webcell;
        }
        else if (_dataSourceType == DataSource_JianJie)
        {
            
            [webcell setData:_voData.obj_url];
            
            return webcell;
        }
        else if (_dataSourceType == DataSource_PingLun)
        {
            if (_haveCommentData == YES)
            {
                EnrolStudentCommentCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CommentCellID forIndexPath:indexPath];
                
                [cell setData:_commentsData[indexPath.row - 2]];
                
                return cell;
            }
            
            else
            {
                NoDataView * nodata = [collectionView dequeueReusableCellWithReuseIdentifier:NoDataCell forIndexPath:indexPath];
                
                return nodata;
            }
        }
    }
    
    return nil;
}

#pragma mark - 按钮点击事件 - 切换数据源
- (void)funcBtnClick:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 0:
        {
            [[KGHUD sharedHud] hide:self.view];
            _dataSourceType = DataSource_ZhaoSheng;
            _oriLayout.isCommentCell = NO;
            
            [_collectionView reloadData];
        }
            break;
        case 1:
        {
            [[KGHUD sharedHud] hide:self.view];
            _dataSourceType = DataSource_JianJie;
            _oriLayout.isCommentCell = NO;
            
            [_collectionView reloadData];
        }
            break;
            
        case 2:
        {
            _dataSourceType = DataSource_PingLun;
            _collectionView.bounces = YES;
            _oriLayout.isCommentCell = YES;
            if (_commentsData == nil)
            {
                [self getCommentData];
            }
            else
            {
                [_collectionView reloadData];
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    EnrolStudentSchoolDetailLayout *layout = [[EnrolStudentSchoolDetailLayout alloc] init];
    
    _oriLayout = layout;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 64) collectionViewLayout:layout];
    
//    _collectionView.userInteractionEnabled = NO;
    
    _collectionView.bounces = NO;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentsSchoolCell" bundle:nil] forCellWithReuseIdentifier:SchoolCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentButtonCell" bundle:nil] forCellWithReuseIdentifier:ButtonCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentWebViewCell" bundle:nil] forCellWithReuseIdentifier:WebCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentCommentCell" bundle:nil] forCellWithReuseIdentifier:CommentCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NoDataView" bundle:nil] forCellWithReuseIdentifier:NoDataCell];
    
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

@end
