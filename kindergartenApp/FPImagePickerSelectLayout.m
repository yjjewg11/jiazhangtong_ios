//
//  FPImagePickerSelectLayout.m
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPImagePickerSelectLayout.h"

@interface FPImagePickerSelectLayout()

{
    CGFloat _newMaxHeight;
}

@property (strong, nonatomic) NSMutableArray *attrsArray;         //存储所有布局属性的数组

@end


@implementation FPImagePickerSelectLayout

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
    CGFloat padding = 10;
    CGFloat itemWidth = (APPWINDOWWIDTH - 4 * padding) / 3;
    CGFloat itemHeight = itemWidth;
    CGFloat itemX = padding + (padding + itemWidth) * (indexPath.row % 3);//0-2
    
//    CGFloat itemY = padding + (padding + itemWidth) * (indexPath.row / 3);
//    
     CGFloat itemY = padding +_newMaxHeight;//
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    _newMaxHeight = itemY + itemHeight;
    
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
       NSInteger numberOfSections = self.collectionView.numberOfSections;
    for (NSInteger k=0; k<numberOfSections; k++){
        NSInteger count = [self.collectionView numberOfItemsInSection:k];
         _newMaxHeight =_newMaxHeight+50;
        
        for (NSInteger i=0; i<count; i++)
        {
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:k]];
            
            [self.attrsArray addObject:attrs];
        }

        
    }
   }

@end
