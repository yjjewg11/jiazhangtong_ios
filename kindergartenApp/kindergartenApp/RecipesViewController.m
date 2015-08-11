//
//  RecipesViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "RecipesViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "RecipesDomain.h"
#import "KGDateUtil.h"
#import "RecipesCollectionViewCell.h"
#import "TestCollectionViewCell.h"

#define recipesCollectionCellIden  @"recipesCollectionCellIden"

@interface RecipesViewController () <UICollectionViewDataSource,UICollectionViewDelegate> {
    
    IBOutlet UICollectionView * recipesCollectionView;
    NSMutableArray * dataSource; //数据源 key  只是存储了日期
    NSInteger lastRow;
    NSString * lastDateStr;
    BOOL isFirstReq;
}

@end

@implementation RecipesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"每日食谱";
    
    isFirstReq = YES;
    lastRow = -1;
    
    [self initDataSource];
    [self initCollectionView];
    [self collectionViewScrollToRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)initDataSource {
    dataSource = [[NSMutableArray alloc] init];
    [dataSource addObject:[[RecipesDomain alloc] init]];
    [dataSource addObject:[[RecipesDomain alloc] init]];
    [dataSource addObject:[[RecipesDomain alloc] init]];
}


//初始化collectionview
- (void)initCollectionView
{
    CGSize itemSize = CGSizeMake(CGRectGetWidth(KGSCREEN), CGRectGetHeight(KGSCREEN));
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = Number_Zero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  //横向滚动
    layout.itemSize = itemSize;
    
    [recipesCollectionView setCollectionViewLayout:layout];
    recipesCollectionView.backgroundColor = [UIColor clearColor];
    recipesCollectionView.dataSource = self;
    recipesCollectionView.delegate = self;
    recipesCollectionView.pagingEnabled = YES;
    [recipesCollectionView setShowsHorizontalScrollIndicator:NO];
    [recipesCollectionView registerNib:[UINib nibWithNibName:@"RecipesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:recipesCollectionCellIden];
}


#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [dataSource count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifierCell = recipesCollectionCellIden;
    RecipesCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    [self getQueryDate:indexPath.row];
    [cell loadRecipesInfoByData:lastDateStr];
    
    return cell;
}

//collectionView Scroll to right
- (void)collectionViewScrollToRight
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[dataSource count]-Number_One inSection:Number_Zero];
    
    [recipesCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}


- (void)getQueryDate:(NSInteger)index {
    if(!isFirstReq) {
        if(index != lastRow) {
            lastDateStr = [KGDateUtil nextOrPreyDay:lastDateStr date:lastRow-index];
        }
    } else {
        lastDateStr = [KGDateUtil getDate:Number_Two];
    }
    
    lastRow = index;
    NSLog(@"lastDate:%@, lastRow:%ld", lastDateStr, (long)lastRow);
    
    if(index == Number_Zero) {
        [dataSource insertObject:[[RecipesDomain alloc] init] atIndex:Number_Zero];
        [recipesCollectionView reloadData];
    }
}


@end
