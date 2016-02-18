//
//  FPTimeLineDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPTimeLineDetailVC.h"
#import "DBNetDaoService.h"
#import "MBProgressHUD+HM.h"
#import "FPTimeLineDetailLayout.h"
#import "FPTimeLineDetailCell.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@interface FPTimeLineDetailVC () <UICollectionViewDataSource,UICollectionViewDelegate,FPTimeLineDetailLayoutDelegate>
{
    DBNetDaoService * _service;
    NSMutableArray * _imgDatas;
    NSInteger _pageNo;
    UICollectionView * _collectionView;
    CGFloat imageViewHeight;
    NSInteger _selectPicNum;
}

@end

@implementation FPTimeLineDetailVC

static NSString *const PicID = @"camaracoll";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [[self.daytimeStr componentsSeparatedByString:@","] firstObject];
    _service = [DBNetDaoService defaulService];
    _imgDatas = [NSMutableArray array];
    _pageNo = 1;
    _selectPicNum = 0;
    
    //创建视图
    [self initView];
    
    //从数据库获取数据
    [self getInitData];
    
    //创建编辑按钮
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"modification"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pushToModifyVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)pushToModifyVC
{
    
}

#pragma mark - 获取数据
- (void)getInitData
{
    NSArray * arr = [_service queryPicDetailByDate:[[self.daytimeStr componentsSeparatedByString:@","] firstObject] pageNo:[NSString stringWithFormat:@"1"] familyUUID:self.familyUUID];
    if (arr)
    {
        [_imgDatas addObjectsFromArray:arr];
        [self.view addSubview:_collectionView];
    }
    else
    {
        [MBProgressHUD showError:@"获取相册数据失败,请重试!"];
    }
}

#pragma mark - 创建视图
- (void)initView
{
    FPTimeLineDetailLayout * layout = [[FPTimeLineDetailLayout alloc] init];
    layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"FPTimeLineDetailCell" bundle:nil] forCellWithReuseIdentifier:PicID];
    
}

#pragma mark - collectionView D&D
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPTimeLineDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PicID forIndexPath:indexPath];
    
    [cell setData:_imgDatas[indexPath.row]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgDatas.count;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page
{
    _selectPicNum = page;
}

@end
