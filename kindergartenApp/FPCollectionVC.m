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

@interface FPCollectionVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    int _pageNo;
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
    
    [self creatCollectionView];
    
}

-(void)getData{
    NSString * pageStr = [NSString stringWithFormat:@"%d",_pageNo];
    
    [[KGHttpService sharedService] getCollegePhotoListWithPageNo:pageStr success:^(FPCollegeListDomin *domin) {
        _dataArr = [NSMutableArray arrayWithArray:domin.data];
        
    } faild:^(NSString *errorMsg) {
        [MBProgressHUD showError:@"加载错误"];
    }];
    
    
}
-(void)creatCollectionView
{
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
    static NSString * CellIdentifier = @"collectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float quter = (self.view.frame.size.width - 5) / 4 - 9;
    
    return CGSizeMake(quter, quter);
}



//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


@end
