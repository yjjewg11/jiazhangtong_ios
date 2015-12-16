//
//  EnrolStudentsHomeLayout.m
//  kindergartenApp
//
//  Created by Mac on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentsHomeLayout.h"

@interface EnrolStudentsHomeLayout()
{
    CGFloat _newMaxHeight;
}

@property (strong, nonatomic) NSMutableArray *attrsArray;         //存储所有布局属性的数组

@end


@implementation EnrolStudentsHomeLayout

- (instancetype)init
{
    if (self = [super init])
    {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    
    return self;
}

- (NSMutableArray *)attrsArray
{
    if (_attrsArray == nil)
    {
        _attrsArray = [[NSMutableArray alloc] init];
        
    }
    return _attrsArray;
}

#pragma mark - 布局所需方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = 0;
    CGFloat itemHeight = 0;
    CGFloat itemX = 0;
    CGFloat itemY = 10;
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    itemWidth = KGSCREEN.size.width;
    
    if ([self.haveSummaryInIndex[indexPath.row] isEqualToString:@"YES"])
    {
        itemHeight = 144 + ([self.cellHeights[indexPath.row] floatValue] - 40);
    }
    else
    {
        itemHeight = 85;
    }
    
    itemX = 0;
    itemY = _newMaxHeight;
    _newMaxHeight = itemY + itemHeight + 10;
    
    attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    return attrs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

#pragma mark - contentSize
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, _newMaxHeight);
}

- (void)prepareLayout
{
    [super prepareLayout];
    //计算所有cell的属性
    _newMaxHeight = 10;
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i=0; i<count; i++)
    {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
    
}


@end
