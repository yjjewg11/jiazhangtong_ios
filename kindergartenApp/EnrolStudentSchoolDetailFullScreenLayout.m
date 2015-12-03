//
//  EnrolStudentSchoolDetailFullScreenLayout.m
//  kindergartenApp
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentSchoolDetailFullScreenLayout.h"

@interface EnrolStudentSchoolDetailFullScreenLayout()
{
    CGFloat _newMaxHeight;
}

@property (strong, nonatomic) NSMutableArray *attrsArray;               //存储所有布局属性的数组

@end

@implementation EnrolStudentSchoolDetailFullScreenLayout

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
        itemHeight = 0;
        itemX = 0;
        itemY = -100;
//        _newMaxHeight = itemY + itemHeight;
        
        attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        attrs.alpha = 0;
        
        
        return attrs;
    }
    
    else if (indexPath.row == 1)
    {
        itemWidth = KGSCREEN.size.width;
        itemHeight = 54;
        itemX = 0;
        itemY = 0;
        _newMaxHeight = itemY + itemHeight;
        
        attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        
        return attrs;
    }
    
    else if (indexPath.row >= 2 && self.isCommentCell == NO)
    {
        itemWidth = KGSCREEN.size.width;
        itemHeight = KGSCREEN.size.height - 64 - 54;
        itemX = 0;
        itemY = _newMaxHeight;
        _newMaxHeight = itemY + itemHeight;
        
        attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        
        return attrs;
    }
    
    else if (indexPath.row >= 2 && self.isCommentCell == YES)
    {
        if (self.commentsCellHeights.count != 0)
        {
            itemWidth = KGSCREEN.size.width;
            itemHeight = [self.commentsCellHeights[indexPath.row - 2] floatValue];
            itemX = 0;
            itemY = _newMaxHeight;
            _newMaxHeight = itemY + itemHeight;
            
            attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
            
            return attrs;
        }
        else
        {
            itemWidth = KGSCREEN.size.width;
            itemHeight = 204;
            itemX = 0;
            itemY = _newMaxHeight;
            _newMaxHeight = itemY + itemHeight;
            
            attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
            
            return attrs;
        }
        
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
    return CGSizeMake(0, _newMaxHeight);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    //计算所有cell的属性
    _newMaxHeight = 0;
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i=0; i<count; i++)
    {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
    
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.1, 0.1), M_2_PI);
    
//    attr.transform = CGAffineTransformMakeTranslation(0, 140);
    
//    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
    
    return attr;
}

@end
