//
//  DiscorveryHomeLayout.m
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "DiscorveryHomeLayout.h"

@interface DiscorveryHomeLayout()
{
    CGFloat _newMaxHeight;
}

@property (strong, nonatomic) NSMutableArray *attrsArray;         //存储所有布局属性的数组

@end


@implementation DiscorveryHomeLayout

- (NSMutableArray *)havePicArr
{
    if (_havePicArr == nil)
    {
        _havePicArr = [NSMutableArray array];
    }
    return _havePicArr;
}

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
    CGFloat itemY = 0;
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        itemWidth = KGSCREEN.size.width;
        itemHeight = 120;
        itemX = 0;
        itemY = 0;
        _newMaxHeight = itemY + itemHeight;
        
        attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        
        return attrs;
    }
    
    else if (indexPath.row == 1)
    {
        itemWidth = KGSCREEN.size.width;
        itemHeight = 120;
        itemX = 0;
        itemY = _newMaxHeight;
        _newMaxHeight = itemY + itemHeight;
        
        attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        
        return attrs;
    }
    
    else if (indexPath.row >= 2)
    {
        itemWidth = KGSCREEN.size.width;
        
        if (self.havePicArr.count == 0 || self.havePicArr == nil)
        {
            itemHeight = 204; //nodataview;
        }
        else
        {
            if ([self.havePicArr[indexPath.row - 2] boolValue] == YES)
            {
                itemHeight = 215;
            }
            else
            {
                itemHeight = 125;
            }
        }
        itemX = 0;
        itemY = _newMaxHeight;
        _newMaxHeight = itemY + itemHeight;
        
        attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        
        return attrs;
    }
    
    return nil;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

#pragma mark - contentSize
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, _newMaxHeight + 40);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    //计算所有cell的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i=0; i<count; i++)
    {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
    
}


@end
