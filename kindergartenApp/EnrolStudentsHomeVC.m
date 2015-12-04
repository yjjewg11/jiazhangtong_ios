//
//  EnrolStudentsHomeVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentsHomeVC.h"
#import "KGHttpService.h"
#import "MJRefresh.h"
#import "EnrolStudentsHomeLayout.h"
#import "EnrolStudentSchoolDetailVC.h"
#import "EnrolStudentsSchoolCell.h"
#import "EnrolStudentsSchoolDomain.h"

@interface EnrolStudentsHomeVC () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView * _collectionView;
    UIView * _buttonsView;
    NSMutableArray * _btns;
    NSMutableArray * _redViews;
    NSString * _mappoint;
    
    NSString * _currentSortName;
    NSInteger _currentPageNo;
    
    NSMutableArray * _schoolListDataOfIntelligent;
    NSMutableArray * _schoolListDataOfAppraise;
    NSMutableArray * _schoolListDataOfDistance;
    
    BOOL _canReqData;
    
    NSInteger _pageNoOfIntelligent;
    NSInteger _pageNoOfAppraise;
    NSInteger _pageNoOfDistance;
    
    EnrolStudentsHomeLayout * _layout;
}


@end

@implementation EnrolStudentsHomeVC

static NSString *const SchoolCellID = @"schoolcellcoll";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"招生";
    
    _canReqData = YES;
    _pageNoOfIntelligent = 2;
    _pageNoOfDistance = 2;
    _pageNoOfAppraise = 2;
    _currentPageNo = 1;
    
    _currentSortName = @"intelligent";
    
    //读取坐标
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    _mappoint = [defu objectForKey:@"map_point"];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //创建上面三个按钮view
    _buttonsView = [[UIView alloc] init];
    _buttonsView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, 40);
    [self addSelBtns:_buttonsView];
    [self createBtnRedView];
    
    //请求学校列表
    [self getSchoolList];
    
    [self initCollectionView];
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    EnrolStudentsHomeLayout *layout = [[EnrolStudentsHomeLayout alloc] init];
    
    _layout = layout;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 42, KGSCREEN.size.width, KGSCREEN.size.height - 64 - 42) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentsSchoolCell" bundle:nil] forCellWithReuseIdentifier:SchoolCellID];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self setupRefresh];
}

#pragma mark - 判断现在列表中哪些元素没有summary 字段
- (void)haveSummaryAtIndex
{
    _layout.haveSummaryInIndex = [NSMutableArray array];
    
    if ([_currentSortName isEqualToString:@"intelligent"])
    {
        for (EnrolStudentsSchoolDomain * d in _schoolListDataOfIntelligent)
        {
            [_layout.haveSummaryInIndex addObject:([d.summary isEqualToString:@""]?@"YES":@"NO")];
        }
    }
    else if ([_currentSortName isEqualToString:@"distance"])
    {
        for (EnrolStudentsSchoolDomain * d in _schoolListDataOfDistance)
        {
            [_layout.haveSummaryInIndex addObject:([d.summary isEqualToString:@""]?@"YES":@"NO")];
        }
    }
    else
    {
        for (EnrolStudentsSchoolDomain * d in _schoolListDataOfAppraise)
        {
            [_layout.haveSummaryInIndex addObject:([d.summary isEqualToString:@""]?@"YES":@"NO")];
        }
    }
}

#pragma mark - 获取学校列表数据 - 首次进入
- (void)getSchoolList
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getAllSchoolList:@"" pageNo:@"" mappoint:_mappoint sort:_currentSortName success:^(NSArray *listArr)
    {
        _schoolListDataOfIntelligent = [NSMutableArray arrayWithArray:listArr];
        
        [self hidenLoadView];
        
        [self haveSummaryAtIndex];
        
        [self.view addSubview:_collectionView];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

//点击上面按钮调用的
- (void)getSchoolLists
{
    [self showLoadView];
    _collectionView.hidden = YES;
    
    [[KGHttpService sharedService] getAllSchoolList:@"" pageNo:@"" mappoint:_mappoint sort:_currentSortName success:^(NSArray *listArr)
     {
         if ([_currentSortName isEqualToString:@"intelligent"])
         {
             _schoolListDataOfIntelligent = [NSMutableArray arrayWithArray:listArr];
         }
         else if ([_currentSortName isEqualToString:@"appraise"])
         {
             _schoolListDataOfAppraise = [NSMutableArray arrayWithArray:listArr];
         }
         else
         {
             _schoolListDataOfDistance = [NSMutableArray arrayWithArray:listArr];
         }
         
         [self haveSummaryAtIndex];
         
         [self hidenLoadView];
         
         _collectionView.hidden = NO;
         [_collectionView reloadData];
     }
     faild:^(NSString *errorMsg)
     {
         [self showNoNetView];
     }];
}

#pragma mark - 创建上面3个选择按钮
- (void)addSelBtns:(UIView *)view
{
    NSArray * titlts = @[@"智能排序",@"评价最高",@"离我最近"];
    _btns = [NSMutableArray array];
    
    for (NSInteger i=0; i<3; i++)
    {
        MyButtonFore * btn = [[MyButtonFore alloc] initWithFrame:CGRectMake(i * (APPWINDOWWIDTH / 3), 0, (APPWINDOWWIDTH / 3), 40)];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [btn setTitle:titlts[i] forState:UIControlStateNormal];
        [btn setTitle:titlts[i] forState:UIControlStateSelected];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(selBtn:) forControlEvents:UIControlEventTouchDown];
        
        //创建btn之间的分割线
        if (i!=2)
        {
            UIView * sepView = [[UIView alloc] init];
            sepView.frame = CGRectMake(btn.frame.size.width - 1, 10, 1, 20);
            sepView.backgroundColor = [UIColor lightGrayColor];
            [btn addSubview:sepView];
        }
        [_btns addObject:btn];
        
        [_buttonsView addSubview:btn];
    }
    
    ((UIButton *)_btns[0]).selected = YES;
    
    [self.view addSubview:_buttonsView];
}

#pragma mark - 创建按钮下面红色view
- (void)createBtnRedView
{
    _redViews = [NSMutableArray array];
    
    for (NSInteger i=0;i<_btns.count;i++)
    {
        //创建btn底部的红线
        UIView * redView = [[UIView alloc] init];
        redView.frame = CGRectMake(i * (APPWINDOWWIDTH / 3), 41, (APPWINDOWWIDTH / 3), 1);
        redView.backgroundColor = [UIColor redColor];
        
        redView.hidden = YES;
        
        [_redViews addObject:redView];
        
        [self.view addSubview:redView];
    }
    
    ((UIView *)_redViews[0]).hidden = NO;
}

#pragma mark - 上面按钮点击
- (void)selBtn:(UIButton *)btn
{
    if (btn.tag == 0)
    {
        _currentSortName = @"intelligent";

        if (_currentSortName == nil)
        {
            [self getSchoolLists];
        }
        else
        {
            [_collectionView reloadData];
        }
    }
    else if (btn.tag == 1)
    {
        _currentSortName = @"appraise";

        if (_schoolListDataOfAppraise == nil)
        {
            [self getSchoolLists];
        }
        else
        {
            [_collectionView reloadData];
        }
    }
    else
    {
        _currentSortName = @"distance";

        if (_schoolListDataOfDistance == nil)
        {
            [self getSchoolLists];
        }
        else
        {
            [_collectionView reloadData];
        }
        
    }
    
    btn.selected = YES;
    
    for (NSInteger i=0; i<_btns.count; i++)
    {
        if (btn.tag == i)
        {
            ((UIButton *)_btns[i]).selected = YES;
            ((UIView *)_redViews[i]).hidden = NO;
        }
        else
        {
            ((UIButton *)_btns[i]).selected = NO;
            ((UIView *)_redViews[i]).hidden = YES;
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_currentSortName isEqualToString:@"intelligent"])
    {
        return _schoolListDataOfIntelligent.count;
    }
    else if ([_currentSortName isEqualToString:@"appraise"])
    {
        return _schoolListDataOfAppraise.count;
    }
    else
    {
        return _schoolListDataOfDistance.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EnrolStudentsSchoolCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SchoolCellID forIndexPath:indexPath];
    
    if ([_currentSortName isEqualToString:@"intelligent"])
    {
        [cell setData:_schoolListDataOfIntelligent[indexPath.row]];
    }
    else if ([_currentSortName isEqualToString:@"distance"])
    {
        [cell setData:_schoolListDataOfDistance[indexPath.row]];
    }
    else
    {
        [cell setData:_schoolListDataOfAppraise[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - 没有网络连接重试代理
- (void)tryBtnClicked
{
    [self hidenNoNetView];
    
    //请求学校列表
    [self getSchoolList];
    
    [self initCollectionView];
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
            
            NSInteger _pageNo = 0;
            
            if ([_currentSortName isEqualToString:@"intelligent"])
            {
                _pageNo = _pageNoOfIntelligent;
            }
            else if ([_currentSortName isEqualToString:@"distance"])
            {
                _pageNo = _pageNoOfDistance;
            }
            else
            {
                _pageNo = _pageNoOfAppraise;
            }
            
            [[KGHttpService sharedService] getAllSchoolList:@"" pageNo:[NSString stringWithFormat:@"%ld",(long)_pageNo] mappoint:_mappoint sort:_currentSortName success:^(NSArray *listArr)
             {
                 NSMutableArray * marr = [NSMutableArray arrayWithArray:listArr];
                 
                 if (marr.count == 0)
                 {
                     
                 }
                 else
                 {
                     if ([_currentSortName isEqualToString:@"intelligent"])
                     {
                         _pageNoOfIntelligent++;
                         [_schoolListDataOfIntelligent addObjectsFromArray:marr];
                     }
                     else if ([_currentSortName isEqualToString:@"distance"])
                     {
                         _pageNoOfDistance++;
                         [_schoolListDataOfDistance addObjectsFromArray:marr];
                     }
                     else
                     {
                         _pageNoOfAppraise++;
                         [_schoolListDataOfAppraise addObjectsFromArray:marr];
                     }
                     
                     [self haveSummaryAtIndex];
                     
                     [_collectionView reloadData];
                     
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                     {
                         _canReqData = YES;
                     });
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
    EnrolStudentSchoolDetailVC * vc = [[EnrolStudentSchoolDetailVC alloc] init];
    
    if ([_currentSortName isEqualToString:@"intelligent"])
    {
        vc.groupuuid = ((EnrolStudentsSchoolDomain *)_schoolListDataOfIntelligent[indexPath.row]).uuid;
    }
    else if ([_currentSortName isEqualToString:@"distance"])
    {
        vc.groupuuid = ((EnrolStudentsSchoolDomain *)_schoolListDataOfDistance[indexPath.row]).uuid;
    }
    else
    {
        vc.groupuuid = ((EnrolStudentsSchoolDomain *)_schoolListDataOfAppraise[indexPath.row]).uuid;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark - 实现自定义Button
@implementation MyButtonFore

//图片高亮会调用这个方法
- (void)setHighlighted:(BOOL)highlighted
{
    //取消点击效果
}

@end