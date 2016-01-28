//
//  FPHomeVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/13.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeVC.h"
#import "ParallaxHeaderView.h"
#import "FPHomeTopView.h"
#import "FPHomeSonView.h"
#import "FPHomeSelectView.h"
#import "FPHomeBtnCell.h"
#import "FPGifrwarePickerVC.h"
#import "DBNetDaoService.h"
#import "FPMyFamilyPhotoCollectionDomain.h"
#import "FPHomeWarningCell.h"
#import "MBProgressHUD+HM.h"
#import "MJExtension.h"
#import "FPHomeTimeLineCell.h"
#import "FPUploadVC.h"

@interface FPHomeVC () <UITableViewDataSource,UITableViewDelegate,FPHomeSelectViewDelegate>
{
    UITableView * _tableView;
    FPHomeSonView * sonView;
    FPHomeSelectView * selView;
    DBNetDaoService * _service;
    
    FPMyFamilyPhotoCollectionDomain * _myCollectionDomain;
    
    NSMutableArray * _photoDatas;
    NSMutableArray * _timeDatas;
    
    CGFloat warningCellHeight;
    FPHomeWarningCell * _warningCell;
}

@end

@implementation FPHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建服务类
    _service = [[DBNetDaoService alloc] init];
    
    //获取我的家庭相册信息
    [self getMyPhotoCollectionInfo];
    
    _photoDatas = [NSMutableArray array];
    _timeDatas = [NSMutableArray array];
    
    [self createBarItems];
    //注册通知,用户提示用户有新数据需要更新啦
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(showUpDatePhotoDataView:) name:@"canUpDatePhotoData" object:nil];
    
    //用于从数据库获取数据
    [center addObserver:self selector:@selector(loadData) name:@"canLoadData" object:nil];
}

- (void)initTableView
{
    //自定义的headerview
    FPHomeTopView * view = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeTopView" owner:nil options:nil] firstObject];
    [view setData:_myCollectionDomain];
    view.size = CGSizeMake(APPWINDOWWIDTH, 192);
    
    //弄到tableviewheader里面去
    ParallaxHeaderView * headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:view];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableHeaderView:headerView];
    
    
    sonView = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeSonView" owner:nil options:nil] firstObject];
    sonView.origin = CGPointMake(0, -132);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:sonView.bounds];
    sonView.layer.masksToBounds = NO;
    sonView.layer.shadowColor = [UIColor blackColor].CGColor;
    sonView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    sonView.layer.shadowOpacity = 0.5f;
    sonView.layer.shadowPath = shadowPath.CGPath;
    
    [self.view addSubview:sonView];
    [self.view addSubview:_tableView];
}

#pragma mark UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
        sonView.origin = CGPointMake(0, -132);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + _timeDatas.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FPHomeBtnCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeBtnCell" owner:nil options:nil] firstObject];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        _warningCell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeWarningCell" owner:nil options:nil] firstObject];

        return _warningCell;
    }
    else
    {
        static NSString * str = @"time_line_cell";
        
        FPHomeTimeLineCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeTimeLineCell" owner:nil options:nil] firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setDateAndCount:_timeDatas[indexPath.row - 1]];
        
        [cell setImgs:[self queryImgs:indexPath]];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 30;
    }
    else
    {
        return (APPWINDOWWIDTH - 20) + 30 + 10 + 10;
    }
}

#pragma mark - 创建navBar items
- (void)createBarItems
{
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"new_album"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pushToUpLoadVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,27)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"hanbao"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(showSonView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}

- (void)pushToUpLoadVC
{
    sonView.origin = CGPointMake(0, -132);
    selView = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeSelectView" owner:nil options:nil] firstObject];
    selView.delegate = self;
    selView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.3];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[selView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    [self.view addSubview:selView];
}

- (void)showSonView
{
    [UIView animateWithDuration:0.2 animations:^
    {
        if (sonView.origin.y == 0)
            sonView.origin = CGPointMake(0, -132);
        else
            sonView.origin = CGPointMake(0, 0);
    }];
}

- (void)pushToImagePickerVC
{
    FPUploadVC * vc = [[FPUploadVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToCreateGiftwareShopVC
{
    
}

- (void)getPhotoDatas
{
    [_service getTimelinePhotos:_myCollectionDomain.uuid];
}

#pragma mark - 通知 用于提示用户
- (void)showUpDatePhotoDataView:(NSNotification *)noti
{
    NSArray * arr = noti.object;
    
    if (arr.count == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            warningCellHeight = 30;
            _warningCell.warningLbl.text = [NSString stringWithFormat:@"最后一次更新:%@",[NSDate date]];
            [_tableView reloadData];
            NSLog(@"照片数量:%d",_photoDatas.count);
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            warningCellHeight = 30;
            _warningCell.warningLbl.text = @"有新照片上传啦,请下拉刷新看看吧!";
            [_photoDatas addObjectsFromArray:arr];
            [_tableView reloadData];
            NSLog(@"照片数量:%d",_photoDatas.count);
        });
    }
}

#pragma mark - 获取我的相册信息 首页头部显示用
- (void)getMyPhotoCollectionInfo
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getMyPhotoCollection:^(FPMyFamilyPhotoCollectionDomain *domain)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self hidenLoadView];
            _myCollectionDomain = domain;
            [self initTableView];
            [self getPhotoDatas];
        });
    }
    faild:^(NSString *errorMsg)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self hidenLoadView];
            [self showNoNetView];
        });
    }];
}

#pragma mark - 获取数据库照片数据
- (void)loadData
{
    //反过来排
    NSArray * tempArr = [[[_service getListTimeHeadData:_myCollectionDomain.uuid] reverseObjectEnumerator] allObjects];
    
    [_timeDatas addObjectsFromArray:tempArr];
    [_tableView reloadData];
}

- (NSArray *)queryImgs:(NSIndexPath *)indexPath
{
    if ( (indexPath.row-1) < _photoDatas.count)
    {
        return _photoDatas[indexPath.row-1];
    }
    else
    {
        NSString * strs = _timeDatas[indexPath.row - 1];
        
        NSArray * imgs = [_service getListTimePhotoData:[[strs componentsSeparatedByString:@","] firstObject] familyUUID:_myCollectionDomain.uuid];
        
        [_photoDatas addObject:imgs];
        
        return imgs;
    }
}

@end
