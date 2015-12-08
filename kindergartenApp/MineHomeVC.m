//
//  MineHomeVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MineHomeVC.h"
#import "MineHomeChildrenCell.h"
#import "MineHomeLayout.h"

@interface MineHomeVC () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView * _collectionView;
}

@end

@implementation MineHomeVC

static NSString *const StuColl = @"stucoll";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initCollectionView];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    MineHomeLayout * layout = [[MineHomeLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 64) collectionViewLayout:layout];
    
    _collectionView.bounces = NO;
    
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MineHomeChildrenCell" bundle:nil] forCellWithReuseIdentifier:StuColl];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        MineHomeChildrenCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:StuColl forIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

@end
