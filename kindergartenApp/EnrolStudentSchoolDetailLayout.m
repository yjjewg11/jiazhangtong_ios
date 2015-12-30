
//
//  EnrolStudentSchoolDetailLayout.m
//  kindergartenApp
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentSchoolDetailLayout.h"
#import "KGNSStringUtil.h"

@interface EnrolStudentSchoolDetailLayout()
{
    CGFloat _newMaxHeight;
}

@property (strong, nonatomic) NSMutableArray *attrsArray;               //存储所有布局属性的数组

@end


@implementation EnrolStudentSchoolDetailLayout

- (NSMutableArray *)commentsCellHeights
{
    if (_commentsCellHeights == nil)
    {
        _commentsCellHeights = [NSMutableArray array];
    }
    return _commentsCellHeights;
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
        
        if (self.domain.summary == nil || [self.domain.summary isEqualToString:@""])
        {
            itemHeight = 85;
        }
        else
        {
            CGFloat padding = 10;
            //计算cell高度
            CGFloat summaryW = (APPWINDOWWIDTH - (10 + 70));
            CGFloat summaryViewHeight = [self heightForString:self.domain.summary fontSize:14 andWidth:summaryW] - 10;
            
            itemHeight = 85 + padding * 2 + summaryViewHeight ;
        }
        
        itemX = 0;
        itemY = _newMaxHeight;
        _newMaxHeight = itemY + itemHeight;
        
        attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        
        return attrs;
    }
    
    else if (indexPath.row == 1)
    {
        itemWidth = KGSCREEN.size.width;
        itemHeight = 54;
        itemX = 0;
        itemY = _newMaxHeight;
        _newMaxHeight = itemY + itemHeight;
        
        attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        
        return attrs;
    }

    else if (indexPath.row >= 2 && self.isCommentCell == NO)
    {
        itemWidth = KGSCREEN.size.width;
        itemHeight = KGSCREEN.size.height - 64 - 54 - 48;
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
            itemHeight = [self.commentsCellHeights[indexPath.row - 2] floatValue] + 100;
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

- (CGFloat) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

- (CGFloat)calSummaryCellHeight:(NSString *)content
{
    CGFloat lblW = KGSCREEN.size.width - 90 - 8;
    
    CGFloat itemHeight = [KGNSStringUtil heightForString:[self formatSummary:content] andWidth:lblW];
    
    return itemHeight;
}

- (NSString *)formatSummary:(NSString *)summary
{
    NSArray * arr = [summary componentsSeparatedByString:@","];
    
    NSMutableString * mstr = [NSMutableString string];
    
    for (NSString * str in arr)
    {
        [mstr appendString:[NSString stringWithFormat:@"%@\r\n",str]];
    }
    
    return mstr;
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
    
    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), -M_PI);
    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
    
    return attr;
}

@end
