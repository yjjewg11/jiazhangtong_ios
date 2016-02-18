//
//  FPTimeLineDetailLayout.m
//  kindergartenApp
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPTimeLineDetailLayout.h"

@interface FPTimeLineDetailLayout()
{
    CGFloat _newMaxWidth;
}

@property (strong, nonatomic) NSMutableArray *attrsArray;         //存储所有布局属性的数组

@end

@implementation FPTimeLineDetailLayout

//- (instancetype)init
//{
//    if (self = [super init])
//    {
//        self.scrollDirection = UICollectionViewScrollDirectionVertical;
//    }
//    
//    return self;
//}
//
//- (NSMutableArray *)attrsArray
//{
//    if (_attrsArray == nil)
//    {
//        _attrsArray = [[NSMutableArray alloc] init];
//        
//    }
//    return _attrsArray;
//}
//
//#pragma mark - 布局所需方法
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat itemWidth = APPWINDOWWIDTH;
//    CGFloat itemHeight = APPWINDOWHEIGHT - 64 - 49;
//    CGFloat itemX = 0 + APPWINDOWWIDTH * indexPath.row;
//    CGFloat itemY = 0;
//    
//    _newMaxWidth += itemWidth;
//    
//    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
//    
//    return attrs;
//}
//
//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    return self.attrsArray;
//}
//
//#pragma mark - contentSize
//- (CGSize)collectionViewContentSize
//{
//    return CGSizeMake(_newMaxWidth, 0);
//}
//
//- (void)prepareLayout
//{
//    [super prepareLayout];
//    //计算所有cell的属性
//    _newMaxWidth = 0;
//    [self.attrsArray removeAllObjects];
//    NSInteger count = [self.collectionView numberOfItemsInSection:0];
//    for (NSInteger i=0; i<count; i++)
//    {
//        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        [self.attrsArray addObject:attrs];
//    }
//}

- (instancetype)init
{
    if( self = [super init])
    {
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    //初始化每个cell的尺寸
    self.itemSize = CGSizeMake(APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49);
    //设置水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //设置左右的边距
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //设置间距
    self.minimumLineSpacing = 0;
}

/**
 *  返回所有item的布局属性
 *
 *  @param rect
 *
 *  @return
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    for (UICollectionViewLayoutAttributes *attribute in attributes)
    {
        if (CGRectIntersectsRect(attribute.frame, rect))
        {
            if (visibleRect.origin.x == 0)
            {
                [self.delegate collectionView:self.collectionView layout:self cellCenteredAtIndexPath:attribute.indexPath page:0];
            }else
            {
                // 除法取整 取余数
                div_t x = div(visibleRect.origin.x,visibleRect.size.width);
                if (x.quot > 0 && x.rem > 0)
                {
                    [self.delegate collectionView:self.collectionView layout:self cellCenteredAtIndexPath:attribute.indexPath page:x.quot + 1];
                }
                if (x.quot > 0 && x.rem == 0)
                {
                    [self.delegate collectionView:self.collectionView layout:self cellCenteredAtIndexPath:attribute.indexPath page:x.quot];
                }
            }
        }
    }
    return attributes;
}

/**
 *  用来设置手松开 scrollView停止滚动那一刻的位置
 *
 *  @param proposedContentOffset 本来的位置
 *  @param velocity 滚动速度 矢量
 *
 *  @return
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //计算scrollview最后会停留的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //取出这个范围内的所有属性
    NSArray *arr = [self layoutAttributesForElementsInRect:lastRect];
    
    //遍历所有属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in arr)
    {
        //计算屏幕最中间的x
        CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
        if(ABS(attr.center.x - centerX) < ABS(adjustOffsetX) )
        {
            adjustOffsetX = attr.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}

/**
 *  只要显示的边界发生改变就会调用此方法
 *
 *  @param newBounds
 *
 *  @return
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
