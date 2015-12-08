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

@interface DiscorveryVC () <UICollectionViewDataSource,UICollectionViewDelegate,DiscorveryTypeCellDelegate>
{
    UICollectionView * _collectionView;
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
    
    //请求每日推荐
    
    //请求热门精选
    
    [self initCollectionView];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - coll数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        DiscorveryTypeCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:TypeColl forIndexPath:indexPath];
        
        cell.delegate = self;
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        TuiJianCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:TuiJianColl forIndexPath:indexPath];
        
        return cell;
    }
    else if (indexPath.row == 2)
    {
        NoDataView * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:Nodata forIndexPath:indexPath];
        
        return cell;
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
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    DiscorveryHomeLayout *layout = [[DiscorveryHomeLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 44) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DiscorveryTypeCell" bundle:nil] forCellWithReuseIdentifier:TypeColl
     ];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"TuiJianCell" bundle:nil] forCellWithReuseIdentifier:TuiJianColl
     ];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NoDataView" bundle:nil] forCellWithReuseIdentifier:Nodata
     ];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
}
@end
