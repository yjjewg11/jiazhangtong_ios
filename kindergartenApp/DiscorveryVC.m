//
//  DiscorveryVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "DiscorveryVC.h"
#import "MJRefresh.h"
#import "KGHttpService.h"
#import "MJExtension.h"
#import "DiscorveryHomeLayout.h"
#import "DiscorveryTypeCell.h"
#import "TuiJianCell.h"
#import "NoDataView.h"
#import "GiftwareArticlesViewController.h"
#import "YouHuiVC.h"
#import "KGHUD.h"
#import "DiscorveryMeiRiTuiJianDomain.h"
#import "DiscorveryNewNumberDomain.h"

#import "DiscorveryJingXuanCell.h"

@interface DiscorveryVC () <UICollectionViewDataSource,UICollectionViewDelegate,DiscorveryTypeCellDelegate>
{
    UICollectionView * _collectionView;
    
    DiscorveryMeiRiTuiJianDomain * _tuijianDomain;
    
    NSMutableArray * _remenjingxuanData;
    
    DiscorveryNewNumberDomain * _numberDomain;
    
    DiscorveryHomeLayout * _layOut;
    
    NSMutableArray * _haveReMenJingXuanPic;
}

@end

@implementation DiscorveryVC

static NSString *const TypeColl = @"typecoll";
static NSString *const TuiJianColl= @"tuijiancoll";
static NSString *const TopicColl = @"topiccoll";
static NSString *const Nodata = @"nodata";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发现";
    
    //请求最新数据条数显示 红点
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    _numberDomain = [[DiscorveryNewNumberDomain alloc] init];
    _numberDomain.today_goodArticle = [[defu objectForKey:@"jingpingwenzhangnum"] integerValue];
    _numberDomain.today_snsTopic = [[defu objectForKey:@"huatinum"] integerValue];
    _numberDomain.today_pxbenefit = [[defu objectForKey:@"youhuihuodongnum"] integerValue];
    _numberDomain.today_unreadPushMsg = [[defu objectForKey:@"xiaoxinum"] integerValue];
    
    //请求每日推荐
    [self getTuiJianData];
    
    [self initCollectionView];
}

#pragma mark - 请求每日推荐
- (void)getTuiJianData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getMeiRiTuiJian:^(DiscorveryMeiRiTuiJianDomain *mgr)
    {
        _tuijianDomain = mgr;
        
        //请求热门精选
        [self getReMenJingXuan];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

#pragma mark - 请求判断是否可以点击进入话题详情
- (void)getCanJoinTopicWeb
{
    
}

#pragma mark - 请求热门精选
- (void)getReMenJingXuan
{
    [[KGHttpService sharedService] getReMenJingXuan:@"1" success:^(NSArray *remenjingxuanarr)
    {
        [self hidenLoadView];
        
        _remenjingxuanData = [NSMutableArray arrayWithArray:remenjingxuanarr];
        
        [self calCellHavePic];
        
        [self.view addSubview:_collectionView];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

#pragma mark - 创建是否有图片的判断数组
- (void)calCellHavePic
{
    _haveReMenJingXuanPic = [NSMutableArray array];
    
    for (DiscorveryReMenJingXuanDomain * d in _remenjingxuanData)
    {
        if (d.imgList.count == 0)
        {
            [_haveReMenJingXuanPic addObject:@(NO)];
        }
        else
        {
            [_haveReMenJingXuanPic addObject:@(YES)];
        }
    }
    
    //把数组交给layout
    _layOut.havePicArr = _haveReMenJingXuanPic;
}

#pragma mark - coll数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_remenjingxuanData.count == 0 || _remenjingxuanData == nil)
    {
        return 3;
    }
    else
    {
        return 2 + _remenjingxuanData.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        DiscorveryTypeCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:TypeColl forIndexPath:indexPath];
        
        cell.delegate = self;
        
        [cell setData:_numberDomain];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        TuiJianCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:TuiJianColl forIndexPath:indexPath];
        
        [cell setData:_tuijianDomain];
        
        return cell;
    }
    else if (indexPath.row >= 2)
    {
        if (_remenjingxuanData.count == 0 || _remenjingxuanData == nil)
        {
            NoDataView * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:Nodata forIndexPath:indexPath];
            
            return cell;
        }
        else
        {
            DiscorveryJingXuanCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:TopicColl forIndexPath:indexPath];
            
            [cell setData:_remenjingxuanData[indexPath.row - 2]];
            
            return cell;
        }
    }
    
    return nil;
}

#pragma mark - 界面跳转代理
- (void)pushToVC:(UIButton *)btn
{
    BaseViewController * baseVC = nil;
    switch (btn.tag)
    {
        case 0:
        {
            baseVC = [[GiftwareArticlesViewController alloc] init];
        }
            break;
        case 1:
        {
            [[KGHUD sharedHud] show:_collectionView onlyMsg:@"建设中..."];
        }
            break;
        case 2:
        {
            baseVC = [[YouHuiVC alloc] init];
        }
            break;
        default:
            break;
    }
    
    if(baseVC)
    {
        [self.navigationController pushViewController:baseVC animated:YES];
    }
}

#pragma mark - 点击跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    DiscorveryHomeLayout *layout = [[DiscorveryHomeLayout alloc] init];
    
    _layOut = layout;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 44 - 70) collectionViewLayout:layout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DiscorveryTypeCell" bundle:nil] forCellWithReuseIdentifier:TypeColl
     ];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"TuiJianCell" bundle:nil] forCellWithReuseIdentifier:TuiJianColl
     ];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NoDataView" bundle:nil] forCellWithReuseIdentifier:Nodata
     ];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DiscorveryJingXuanCell" bundle:nil] forCellWithReuseIdentifier:TopicColl
     ];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
}
@end
