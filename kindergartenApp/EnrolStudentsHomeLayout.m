//
//  EnrolStudentsHomeLayout.m
//  kindergartenApp
//
//  Created by Mac on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentsHomeLayout.h"
#import "EnrolStudentsSchoolDomain.h"
#import "KGNSStringUtil.h"

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
    
    if (self.datas.count == 0)
    {
        itemHeight = 204;
    }
    else
    {
        EnrolStudentsSchoolDomain * domain = self.datas[indexPath.row];
        
        if (domain.summary == nil || [domain.summary isEqualToString:@""])
        {
            itemHeight = 85;
        }
        else
        {
            CGFloat padding = 10;
            //计算cell高度
            CGFloat summaryW = (APPWINDOWWIDTH - (10 + 70));
            CGFloat summaryViewHeight = [self heightForString:domain.summary fontSize:14 andWidth:summaryW] - 10;
            
            itemHeight = 85 + padding * 2 + summaryViewHeight;
        }
    }
    
    itemX = 0;
    itemY = _newMaxHeight;
    _newMaxHeight = itemY + itemHeight + 10;
    
    attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    return attrs;
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
    
    for (NSInteger i=0; i<3; i++)
    {
        [mstr appendString:[NSString stringWithFormat:@"%@\r\n",arr[i]]];
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
