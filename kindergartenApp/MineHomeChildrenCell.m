//
//  MineHomeChildrenCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MineHomeChildrenCell.h"
#import "UIColor+flat.h"
#import "KGHttpService.h"
#import "MineHomeStudentHeadItem.h"

@interface MineHomeChildrenCell()
{
    UIScrollView * _scrollView;
    
    NSArray * _studentMArray;
}



@end

@implementation MineHomeChildrenCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithHexCode:@"#FF6666"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    _studentMArray = [KGHttpService sharedService].loginRespDomain.list;
    
    if (_studentMArray.count != 0)
    {
        [self setUpStudentsItem];
    }
}

- (void)setUpStudentsItem
{
    // 91 112
    CGFloat padding = 0;
    
    if (_studentMArray.count <= 3)
    {
        padding=  (KGSCREEN.size.width - (91 * _studentMArray.count) ) / (_studentMArray.count + 1);
    }
    else
    {
        padding = ((KGSCREEN.size.width - (91 * 3) ) / (3 + 1) ) + 20;
    }
    
    for (NSInteger i=0; i<_studentMArray.count; i++)
    {
        MineHomeStudentHeadItem * item = [[[NSBundle mainBundle] loadNibNamed:@"MineHomeStudentHeadItem" owner:nil options:nil] firstObject];
        
        item.btn.tag = i;
        
        [item.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        KGUser * user = _studentMArray[i];
        
        [item setData:user];
        
        [item setOrigin:CGPointMake((padding + 91) * i + padding ,0)];
        
        [_scrollView addSubview:item];
        
        [_scrollView setContentSize:CGSizeMake((padding + 91) * _studentMArray.count + padding + padding, 0)];
    }
    
    [self addSubview:_scrollView];
}

- (void)btnClicked:(UIButton *)btn
{
    [self.delegate pushToEditStudentInfo:btn];
}

@end
