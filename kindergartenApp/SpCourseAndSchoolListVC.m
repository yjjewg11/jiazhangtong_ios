//
//  SpCourseAndSchoolListVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/30.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseAndSchoolListVC.h"
#import "KGHttpService.h"
#import "SPCourseTypeDomain.h"
#import "KGHUD.h"
#import "SPCourseDomain.h"
#import "SPSchoolDomain.h"
#import "MJExtension.h"
#import "SpCourseAndSchoolListLayout.h"
#import "MXPullDownMenu.h"
#import "MJRefresh.h"
#import "SpCourseHomeCourseCell.h"
#import "SpCourseAndSchoolListSchoolCell.h"

#import "SPCourseDetailVC.h"
#import "SPSchoolDetailVC.h"

#define FinishReqCount 2

@interface SpCourseAndSchoolListVC () <UICollectionViewDataSource,UICollectionViewDelegate,MXPullDownMenuDelegate>
{
    //顶部菜单原始数据
    NSMutableArray * _courseTypesData;
    
    //标记是否第一次进入
    BOOL _isFirshJoin;
    
    //视图
    UICollectionView * _collectionView;
    UISegmentedControl * _segCtrl;
    
    //坐标
    NSString * _mappoint;

    //数据源
    NSMutableArray * _courseListData;
    NSMutableArray * _schoolListData;
    
    MXPullDownMenu * _dropMenu;
    
    //顶部菜单内容数据
    NSArray * _dataOfSort;
    NSMutableArray * _dataOfCourseType;
    
    //控制数据源
    NSInteger _dataSourceType;
    
    //控制顶部菜单索引
    NSInteger _currentTypeDataKeyIndex;
    NSString * _currentSortName;
    
    //自动翻页控制
    BOOL _canReqData;
    NSInteger _pageNo;
    
    NSInteger _schoolPageNo;
}

@end

@implementation SpCourseAndSchoolListVC

static NSString *const CourseCellID = @"coursecellcoll";
static NSString *const SchoolCellID = @"schoolcellcoll";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isFirshJoin = YES;
    _currentSortName = @"智能排序";
    _pageNo = 2;
    _schoolPageNo = 2;
    _canReqData = YES;
    
    //读取坐标
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    _mappoint = [defu objectForKey:@"map_point"];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //创建tabbar 选择按钮
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"课程 ",@"学校",nil];
    _segCtrl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _segCtrl.selectedSegmentIndex = 0;
    _segCtrl.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = _segCtrl;
    [_segCtrl addTarget:self action:@selector(segMentAction:) forControlEvents:UIControlEventValueChanged];
    
    //获取课程分类数据
    [self getCourseTypeData];
    
    //初始化视图
    [self initCollectionView];
}

#pragma mark - 获取课程分类数据 首次进入调用的
- (void)getCourseTypeData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getSPCourseType:^(NSArray *spCourseTypeArr)
    {
        //交换首次进入位置
        _courseTypesData = [NSMutableArray arrayWithArray:spCourseTypeArr];
        
        SPCourseTypeDomain * domain = [[SPCourseTypeDomain alloc] init];
        domain.datavalue = @"查看全部";
        domain.datakey = -1;
        [_courseTypesData addObject:domain];
        
        [_courseTypesData exchangeObjectAtIndex:0 withObjectAtIndex:self.firstJoinIndex];
        
        //创建下拉菜单
        [self setUpListBtns];
        
        //获取列表数据
        [self getDataList];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

#pragma mark - 获取列表数据
- (void)getDataList
{
    _dropMenu.hidden = YES;
    
    SPCourseTypeDomain * domain = _courseTypesData[0];
    
    [[KGHttpService sharedService] getSPCourseList:@"" map_point:_mappoint type:[self boxPara:domain.datakey] sort:[self getSortValueWithName:_currentSortName] teacheruuid:@"" pageNo:@"" success:^(SPDataListVO *spCourseList)
     {
         _courseListData = [NSMutableArray arrayWithArray:[SPCourseDomain objectArrayWithKeyValuesArray:spCourseList.data]];
         
         [self hidenLoadView];
         
         _dropMenu.hidden = NO;
         
         [self.view addSubview:_collectionView];
     }
     faild:^(NSString *errorMsg)
     {
         [self showNoNetView];
     }];
}

//顶部按钮点击的网络请求
- (void)getSchoolList
{
    _collectionView.hidden = YES;
    [self showLoadView];
    _dropMenu.hidden = YES;

    [[KGHttpService sharedService] getSPSchoolList:_mappoint pageNo:@"" sort:[self getSortValueWithName:_currentSortName] success:^(SPDataListVO *spSchoolList)
    {
        _schoolListData = [NSMutableArray arrayWithArray:[SPSchoolDomain objectArrayWithKeyValuesArray:spSchoolList.data]];
        
        [self hidenLoadView];
        
        _dropMenu.hidden = NO;
        
        [_collectionView reloadData];

        _collectionView.hidden = NO;
        
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

- (void)getCourseList
{
    _collectionView.hidden = YES;
    _dropMenu.hidden = YES;
    
    [self showLoadView];
    
    SPCourseTypeDomain * domain = _courseTypesData[_currentTypeDataKeyIndex];
    
    [[KGHttpService sharedService] getSPCourseList:@"" map_point:_mappoint type:[self boxPara:domain.datakey] sort:[self getSortValueWithName:_currentSortName] teacheruuid:@"" pageNo:@"" success:^(SPDataListVO *spCourseList)
     {
         _courseListData = nil;
         
         _courseListData = [NSMutableArray arrayWithArray:[SPCourseDomain objectArrayWithKeyValuesArray:spCourseList.data]];
         
         _dropMenu.hidden = NO;
         [self hidenLoadView];
         
         [_collectionView reloadData];
         
         _collectionView.hidden = NO;
     }
     faild:^(NSString *errorMsg)
     {
         [self showNoNetView];
     }];
}

#pragma mark - 没有网络连接重试代理
- (void)tryBtnClicked
{
    [self hidenNoNetView];
    
    if (_isFirshJoin == YES)
    {
        [self getCourseTypeData];
        //初始化视图
        [self initCollectionView];
    }
    else
    {
        if (_dataSourceType == 0)
        {
            [self getCourseList];
        }
        else if (_dataSourceType == 1)
        {
            [self getSchoolList];
        }
    }
}

#pragma mark - 顶部tabbar按钮选择
- (void)segMentAction:(UISegmentedControl *)seg
{
    _pageNo = 2;
    _canReqData = YES;
    _isFirshJoin = NO;
    
    NSInteger index = seg.selectedSegmentIndex;
    
    switch (index)
    {
        case 0:
        {
            _dataSourceType = 0;
            [self getCourseList];
            break;
        }
        case 1:
        {
            _dataSourceType = 1;
            [self getSchoolList];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    SpCourseAndSchoolListLayout *layout = [[SpCourseAndSchoolListLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 36, KGSCREEN.size.width, KGSCREEN.size.height - 64 - 36) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SpCourseHomeCourseCell" bundle:nil] forCellWithReuseIdentifier:CourseCellID];

    [_collectionView registerNib:[UINib nibWithNibName:@"SpCourseAndSchoolListSchoolCell" bundle:nil] forCellWithReuseIdentifier:SchoolCellID];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self setupRefresh];
}

#pragma mark - collection的数据源 & 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataSourceType == 0)
    {
        return _courseListData.count;
    }
    else if (_dataSourceType == 1)
    {
        return _schoolListData.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceType == 0)
    {
        SpCourseHomeCourseCell * coursecell = [collectionView dequeueReusableCellWithReuseIdentifier:CourseCellID forIndexPath:indexPath];
        
        [coursecell setCourseCellData:_courseListData[indexPath.row]];
        
        return coursecell;
    }
    else if (_dataSourceType == 1)
    {
        SpCourseAndSchoolListSchoolCell * schoolcell = [collectionView dequeueReusableCellWithReuseIdentifier:SchoolCellID forIndexPath:indexPath];
        
        [schoolcell setData:_schoolListData[indexPath.row]];
        
        return schoolcell;
    }
    
    return nil;
}


#pragma mark - 排序字符串转请求参数
- (NSString *)getSortValueWithName:(NSString *)sortName
{
    if([sortName isEqualToString:@"智能排序"])
    {
        return @"intelligent";
    }
    else if ([sortName isEqualToString:@"评价最高"])
    {
        return @"appraise";
    }
    else if ([sortName isEqualToString:@"距离最近"])
    {
        return @"distance";
    }
    else
    {
        return @"";
    }
}



#pragma mark - 创建顶部下拉菜单
- (void)setUpListBtns
{
    NSArray *testArray;
    
    _dataOfCourseType = [NSMutableArray array];
    
    for (SPCourseTypeDomain * d in _courseTypesData)
    {
        [_dataOfCourseType addObject:d.datavalue];
    }
    
    _dataOfSort = @[@"智能排序",@"评价最高",@"距离最近"];
    testArray = @[_dataOfCourseType, _dataOfSort];
    _dropMenu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor blackColor]];
    _dropMenu.delegate = self;
    _dropMenu.frame = CGRectMake(0,0, APPWINDOWWIDTH, _dropMenu.frame.size.height);
    
    [self.view addSubview:_dropMenu];
}

#pragma mark - MXPullDownMenuDelegate
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    _pageNo = 2;
    _canReqData = YES;
    _isFirshJoin = NO;
    
    if (column == 0)
    {
        _currentTypeDataKeyIndex = row;
    }
    else if (column == 1)
    {
        _currentSortName = _dataOfSort[row];
    }
    
    if (_dataSourceType == 0)
    {
        [self getCourseList];
    }
    else if (_dataSourceType == 1)
    {
        [self getSchoolList];
    }
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
            
            if (_dataSourceType == 0)
            {
                SPCourseTypeDomain * domain = _courseTypesData[_currentTypeDataKeyIndex];
                
                [[KGHttpService sharedService] getSPCourseList:@"" map_point:_mappoint type:[self boxPara:domain.datakey] sort:[self getSortValueWithName:_currentSortName] teacheruuid:@"" pageNo:[self boxPara:_pageNo] success:^(SPDataListVO *spCourseList)
                 {
                     NSMutableArray * marr = [NSMutableArray arrayWithArray:[SPCourseDomain objectArrayWithKeyValuesArray:spCourseList.data]];
                     
                     if (marr.count == 0 || marr == nil)
                     {
                         
                     }
                     else
                     {
                         _pageNo++;
                         [_courseListData addObjectsFromArray:marr];
                         [_collectionView reloadData];
                         
                         _canReqData = YES;
                     }
                 }
                 faild:^(NSString *errorMsg)
                 {
                     [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
                 }];
            }
            else if (_dataSourceType == 1)
            {
                [[KGHttpService sharedService] getSPSchoolList:_mappoint pageNo:[self boxPara:_schoolPageNo] sort:[self getSortValueWithName:_currentSortName] success:^(SPDataListVO *spSchoolList)
                 {
                     NSMutableArray * marr = [NSMutableArray arrayWithArray:[SPSchoolDomain objectArrayWithKeyValuesArray:spSchoolList.data]];
                     
                     if (marr.count == 0)
                     {
                        
                     }
                     else
                     {
                         _schoolPageNo++;
                         [_schoolListData addObjectsFromArray:marr];
                         [_collectionView reloadData];
                         
                         _canReqData = YES;
                     }
                 }
                 faild:^(NSString *errorMsg)
                 {
                     [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
                 }];
            }
            
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceType == 0)
    {
        SPCourseDetailVC * detailVC = [[SPCourseDetailVC alloc] init];
        
        SPCourseDomain * d = _courseListData[indexPath.row];
        
        detailVC.uuid = d.uuid;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (_dataSourceType == 1)
    {
        SPSchoolDetailVC * detailVC = [[SPSchoolDetailVC alloc] init];
        
        SPSchoolDomain * d = _schoolListData[indexPath.row];
        
        detailVC.groupuuid = d.uuid;
        
        detailVC.mappoint = _mappoint;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
}


#pragma mark - 包装请求参数
- (NSString *)boxPara:(NSInteger)para
{
    if (para == -1)
    {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%ld",(long)para];
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
