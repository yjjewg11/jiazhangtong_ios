//
//  FPMyFamilyAlbum.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/2/29.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPMyFamilyAlbum.h"
#import "UIFamilyPhotoViewLayout.h"
#import "KGBaseDomain.h"
#import "FPMyFamilyPhotoCollectionDomain.h"
#import "KGHttpService.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+HM.h"
#import "FPFamilyListCollectionViewCell.h"
@interface FPMyFamilyAlbum ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * dataArr;



@end

@implementation FPMyFamilyAlbum

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatData];
    [self creatCollectionView];
    
}

-(void)creatData{
    
   [[KGHttpService sharedService] getMyFamilyPhoto:^(FPMyFamilyPhotoListColletion *domain) {
       self.dataArr = [NSMutableArray arrayWithArray:domain.list];
       
   } faild:^(NSString *errorMsg) {
       [MBProgressHUD showError:errorMsg];
   }];
}
//创建collectionView

-(void)creatCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    
    self.collectionView.frame = self.view.frame;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FPFamilyListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
}
#pragma mark - collectionView D&D

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPat
{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPat];
    return cell;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((APPWINDOWWIDTH - 20) / 2 - 10, (APPWINDOWWIDTH - 20) / 2 - 10);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
