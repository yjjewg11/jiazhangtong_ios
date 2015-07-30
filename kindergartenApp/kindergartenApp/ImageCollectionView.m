//
//  ImageCollectionView.m
//  testcollectionview
//
//  Created by ios2 on 14-9-25.
//  Copyright (c) 2014年 yhr. All rights reserved.
//

#import "ImageCollectionView.h"
#import "UIImageView+WebCache.h"
#import "KGHUD.h"
#import "ImageCollectionViewCell.h"
#import "Masonry.h"

#define tableViewCellIden  @"Cell"


@implementation ImageCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//开始初始化
-(void)showImageCollectionView
{
    
    [self initCollectionView];
    [self initPageControl];
}


//初始化整个collectionview
-(void)initCollectionView
{
    CGRect frame = {{0,0}, {CGRectGetWidth(KGSCREEN), CGRectGetHeight(self.frame)}};
    CGSize itemSize = frame.size;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = Number_Zero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  //横向滚动
    layout.itemSize = itemSize;
    myCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    myCollectionView.backgroundColor = [UIColor clearColor];
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    myCollectionView.pagingEnabled = YES;
    
    [myCollectionView setShowsHorizontalScrollIndicator:NO];
    [myCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self addSubview:myCollectionView];
}

//初始化翻页控件
- (void)initPageControl{
    CGFloat width = self.dataSource.count*20;
    CGFloat x     = (CGRectGetWidth(KGSCREEN) - width)/2;
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(x, self.height-30, width, 30);
    pageControl.numberOfPages = self.dataSource.count;  //指定页面个数
    pageControl.currentPage = 0;                        //指定pagecontroll的值，默认选中的小白点（第一个）
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.hidesForSinglePage = YES;


    [pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged];
    [self addSubview:pageControl];
    [self bringSubviewToFront:pageControl];
}



//翻页 控件点击
-(void)pageControlClicked:(UIPageControl *)sender{
    NSInteger page = pageControl.currentPage;//获取当前pagecontroll的值
    [myCollectionView setContentOffset:CGPointMake(self.frame.size.width * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    
}


#pragma mark - UICollectionViewDelegate methods

//选择某一图片
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self._delegate singleTapEvent:((FuniAttachment *)[self.dataSource objectAtIndex:indexPath.row]).relType];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == myCollectionView){
        CGPoint offset = scrollView.contentOffset;
        pageControl.currentPage = offset.x / (self.bounds.size.width); //计算当前的页码
    }
}



#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = tableViewCellIden;
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    
    //设置图片
    [[KGHUD sharedHud] show:cell];
//    FuniAttachment * atach = (FuniAttachment *)[self.dataSource objectAtIndex:indexPath.row];
//    NSString * photoPath = [FuniNSStringUtil formatImagePath:atach.path size:String_IndexDownImgSize];
    NSString * photoPath = [self.dataSource objectAtIndex:indexPath.row];
    __weak ImageCollectionViewCell * __cell = cell;

    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:photoPath] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[KGHUD sharedHud] hide:__cell];
    }];
    
    //使图片充满view
    cell.imgView.frame = CGRectMake(0, 0, CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame));
    cell.imgView.contentMode = UIViewContentModeScaleToFill;

    return cell;
}

@end
