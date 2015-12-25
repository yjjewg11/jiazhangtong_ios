//
//  EnrolStudentHomeVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/24.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentHomeVC.h"
#import "KGHttpService.h"
#import "EnrolStudentsHomeLayout.h"
#import "MXPullDownMenu.h"
#import "MJRefresh.h"
#import "EnrolStudentsSchoolCell.h"
#import "NoDataView.h"
#import "EnrolStudentSchoolDetailVC.h"
#import "EnrolStudentsSchoolDomain.h"
#import "MBProgressHUD+HM.h"

@interface EnrolStudentHomeVC () <UICollectionViewDataSource,UICollectionViewDelegate,MXPullDownMenuDelegate>
{
    UICollectionView * _collectionView;
    
    NSString * _mappoint;
    
    NSMutableArray * dataSource;
    
    EnrolStudentsHomeLayout * _layout;
    
    MXPullDownMenu * _dropMenu;
    
    NSInteger _pageNo;
    
    NSString * _currentSortName;
}

@end

@implementation EnrolStudentHomeVC

static NSString *const SchoolCellID = @"schoolcellcoll";
static NSString *const NoDataID = @"nodatacoll";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"宝宝入学";
    
    _pageNo = 2;
    
    _currentSortName = @"intelligent";
    
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    _mappoint = [defu objectForKey:@"map_point"];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //请求学校列表
    [self getSchoolList];
    
    [self initCollectionView];
}

#pragma mark - 获取学校列表数据 - 首次进入
- (void)getSchoolList
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getAllSchoolList:@"" pageNo:@"" mappoint:_mappoint sort:@"intelligent" success:^(NSArray *listArr)
     {
         dataSource = [NSMutableArray arrayWithArray:listArr];
         
         [self hidenLoadView];
         
         _layout.datas = [NSMutableArray arrayWithArray:dataSource];
    
         //创建下拉菜单
         [self setUpListBtns];
         
         [self.view addSubview:_collectionView];
         
         [_collectionView reloadData];
     }
     faild:^(NSString *errorMsg)
     {
         [self hidenLoadView];
         [self showNoNetView];
     }];
}

- (void)tryBtnClicked
{
    [self hidenNoNetView];
    
    [self getSchoolList];
    
    [self initCollectionView];
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    EnrolStudentsHomeLayout *layout = [[EnrolStudentsHomeLayout alloc] init];
    
    _layout = layout;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 35, KGSCREEN.size.width, KGSCREEN.size.height - 64 - 35) collectionViewLayout:layout];
    
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentsSchoolCell" bundle:nil] forCellWithReuseIdentifier:SchoolCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NoDataView" bundle:nil] forCellWithReuseIdentifier:NoDataID];
    
    _collectionView.dataSource = self;
    
    _collectionView.delegate = self;
    
    [self setupRefresh];
}

#pragma mark - 创建顶部下拉菜单
- (void)setUpListBtns
{
    NSArray *testArray;
    
    NSArray * cityArr = @[@"成都市"];
    
    NSArray * dataOfSort = @[@"智能排序",@"评价最高",@"距离最近"];
    
    testArray = @[cityArr, dataOfSort];
    
    _dropMenu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor blackColor]];
    _dropMenu.delegate = self;
    _dropMenu.frame = CGRectMake(0,0, APPWINDOWWIDTH, _dropMenu.frame.size.height);
    
    [self.view addSubview:_dropMenu];
}

#pragma mark - 上拉刷新，下拉加载数据
- (void)setupRefresh
{
    [_collectionView addFooterWithTarget:self action:@selector(footerRereshing) showActivityView:YES];
    _collectionView.footerPullToRefreshText = @"上拉加载更多";
    _collectionView.footerReleaseToRefreshText = @"松开立即加载";
    _collectionView.footerRefreshingText = @"正在加载中...";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (dataSource.count == 0)
    {
        return 1;
    }
    else
    {
        return dataSource.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource.count == 0)
    {
        NoDataView * nodata = [collectionView dequeueReusableCellWithReuseIdentifier:NoDataID forIndexPath:indexPath];
        
        return nodata;
    }
    else
    {
        EnrolStudentsSchoolCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SchoolCellID forIndexPath:indexPath];
        
        cell.summaryCount = 3;
        
        [cell setData:dataSource[indexPath.row]];
        
        return cell;
    }
}

#pragma mark - MXPullDownMenuDelegate
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    _pageNo = 2;
    
    if (column == 1)
    {
        if (row == 0)
        {
            _currentSortName = @"intelligent";
            [self getSchoolListBySort:@"intelligent"];
        }
        else if (row == 1)
        {
            _currentSortName = @"appraise";
            [self getSchoolListBySort:@"appraise"];
        }
        else if (row == 2)
        {
            _currentSortName = @"distance";
            [self getSchoolListBySort:@"distance"];
        }
    }
}

#pragma mark - 获取学校列表数据
- (void)getSchoolListBySort:(NSString *)sort
{
    [dataSource removeAllObjects];
    dataSource = nil;
    
    [_layout.datas removeAllObjects];
    
    _collectionView.hidden = YES;
    [self showLoadView];
    
    [[KGHttpService sharedService] getAllSchoolList:@"" pageNo:@"" mappoint:_mappoint sort:sort success:^(NSArray *listArr)
     {
         dataSource = [NSMutableArray arrayWithArray:listArr];
         
         _layout.datas = [NSMutableArray arrayWithArray:listArr];
         
         [self hidenLoadView];
         
         _collectionView.hidden = NO;
         
         [_collectionView reloadData];
     }
     faild:^(NSString *errorMsg)
     {
         [self hidenLoadView];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
         {
             [MBProgressHUD showError:errorMsg];
         });
     }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EnrolStudentSchoolDetailVC * vc = [[EnrolStudentSchoolDetailVC alloc] init];
    
    vc.groupuuid = ((EnrolStudentsSchoolDomain *)dataSource[indexPath.row]).uuid;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)footerRereshing
{
    [[KGHttpService sharedService] getAllSchoolList:@"" pageNo:[NSString stringWithFormat:@"%ld",(long)_pageNo] mappoint:_mappoint sort:_currentSortName success:^(NSArray *listArr)
     {
         if (listArr.count == 0)
         {
             _collectionView.footerRefreshingText = @"没有更多了";
             [_collectionView footerEndRefreshing];
         }
         else
         {
             _pageNo ++;
             
             [dataSource addObjectsFromArray:listArr];
             
             [_layout.datas addObjectsFromArray:listArr];
             
             [_collectionView footerEndRefreshing];
             
             [_collectionView reloadData];
         }
     }
     faild:^(NSString *errorMsg)
     {
         [MBProgressHUD showError:errorMsg];
         [_collectionView footerEndRefreshing];
     }];
}

@end
