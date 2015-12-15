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
}

@end

@implementation MineHomeChildrenCell

- (NSMutableArray *)studentArr
{
    if (_studentArr == nil)
    {
        _studentArr = [NSMutableArray array];
    }
    return _studentArr;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithHexCode:@"#FF6666"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, KGSCREEN.size.width, 170)];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor clearColor];
}

- (void)setUpStudentsItem:(NSMutableArray *)studentArr
{
    self.studentArr = studentArr;
    // 91 112
    CGFloat padding = 0;
    
    if (self.studentArr.count == 0)
    {
        MineHomeStudentHeadItem * item = [[[NSBundle mainBundle] loadNibNamed:@"MineHomeStudentHeadItem" owner:nil options:nil] firstObject];
        
        [item.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [item setCenter:_scrollView.center];
        
        [_scrollView setContentSize:CGSizeMake(KGSCREEN.size.width, 0)];
        
        [_scrollView addSubview:item];
        
        _scrollView.scrollEnabled = NO;
        
        return;
    }
    if (self.studentArr.count <= 3)
    {
        padding=  (KGSCREEN.size.width - (91 * self.studentArr.count) ) / (self.studentArr.count + 1);
        _scrollView.scrollEnabled = NO;
    }
    else
    {
        padding = ((KGSCREEN.size.width - (91 * 3) ) / (3 + 1) ) + 20;
        _scrollView.scrollEnabled = YES;
    }
    
    for (NSInteger i=0; i<self.studentArr.count; i++)
    {
        MineHomeStudentHeadItem * item = [[[NSBundle mainBundle] loadNibNamed:@"MineHomeStudentHeadItem" owner:nil options:nil] firstObject];
        
        item.btn.tag = i;
        
        [item.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        KGUser * user = self.studentArr[i];
        
        [item setData:user];
        
        [item setOrigin:CGPointMake((padding + 91) * i + padding ,0)];
        
        [_scrollView addSubview:item];
        
        [_scrollView setContentSize:CGSizeMake((padding + 91) * self.studentArr.count + padding + padding, 0)];
    }
    
    [self addSubview:_scrollView];
}

- (void)btnClicked:(UIButton *)btn
{
    if (self.studentArr.count == 0)
    {
        [self.delegate pushToAddStudentInfo];
    }
    else
    {
        [self.delegate pushToEditStudentInfo:btn];
    }
}

@end
