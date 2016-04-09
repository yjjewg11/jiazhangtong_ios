//
//  FPCollectionVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/2/26.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPCollectionVC.h"
#import "KGHttpService.h"
#import "MBProgressHUD+HM.h"
#import "UIImageView+WebCache.h"
#import "FPTimeLineDetailVC.h"
@interface FPCollectionVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    int _pageNo;
    PageInfoDomain * pageInfo;
    UITableViewController * reFreshView;
    NSMutableArray * dataSource;
    
}

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation FPCollectionVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    _pageNo = 1;
    self.dataArr = [NSMutableArray array];
    
    [self getData];
    
  
    
}
- (void)initPageInfo
{
    if(!pageInfo)
    {
        pageInfo = [[PageInfoDomain alloc] initPageInfo:1 size:20];
    }
}
-(void)getData{
    
       [self showLoadView];

    
    [[KGHttpService sharedService] getCollegePhotoListWithPageNo:pageInfo.pageNo success:^(FPCollegeListDomin *domin) {
        [self hidenLoadView];
        pageInfo.pageNo++;
        
        _dataArr = [NSMutableArray arrayWithArray:domin.data];
        
          [self creatCollectionView];
    } faild:^(NSString *errorMsg) {
        
        [self hidenLoadView];
        NSLog(@"exception:%@", errorMsg);
        [MBProgressHUD showError:errorMsg];
    }];
    
    
}
-(void)creatCollectionView
{
    
    if(self.collectionView!=nil){
        [self.collectionView reloadData];
        return ;
    }
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];

    self.collectionView.frame = self.view.frame;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class]     forCellWithReuseIdentifier:@"collectionViewCell"];
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - collectionView D&D

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataArr.count == 0) {
        [MBProgressHUD showError:@"没有数据"];
    }
    return _dataArr.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    @try{
        
        
        static NSString * CellIdentifier = @"collectionViewCell";
        
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSLog(@"indexPath.row:%d", indexPath.row);

        if(_dataArr.count<indexPath.row)return cell;
        NSMutableDictionary * data=_dataArr[indexPath.row];
      
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
        
//        [cell setRestorationIdentifier:[data objectForKey:@"uuid"]];
//       
        NSString *path=[data objectForKey:@"path"];
        [imgView sd_setImageWithURL:[NSURL URLWithString:path ] placeholderImage:[UIImage imageNamed:@"waitImageDown"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {}];
        
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        [cell.contentView addSubview:imgView];
        return cell;
        
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }

    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float quter = (self.view.frame.size.width - 5) / 4 - 9;
    
    return CGSizeMake(quter, quter);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"click=%@",[cell restorationIdentifier]);
  
    cell.backgroundColor = [UIColor whiteColor];
    
    
    
    FPTimeLineDetailVC * vc = [[FPTimeLineDetailVC alloc] init];
    
    //传递点击的日期过去
//    vc.daytimeStr = _timeDatas[indexPath.row - 1];
//    vc.familyUUID = [FPHomeVC getFamily_uuid];
    
    [vc setFpPhotoNormalDomainArrByDic:_dataArr];
    vc.selectIndex=indexPath.row;

    [self.navigationController pushViewController:vc animated:YES];
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


@end
