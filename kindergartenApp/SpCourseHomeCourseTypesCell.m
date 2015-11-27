//
//  SpCourseHomeCourseTypesCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/26.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseHomeCourseTypesCell.h"
#import "SpCourseItem.h"
#define ItemHeight 64
#define ItemWidth  45

#import "SPCourseTypeDomain.h"

@interface SpCourseHomeCourseTypesCell() <UIScrollViewDelegate>
{
    __weak IBOutlet UIScrollView *scrollView;
    
    __weak IBOutlet UIPageControl *pageCtrl;
}


@end

@implementation SpCourseHomeCourseTypesCell

- (void)awakeFromNib
{
    scrollView.delegate = self;
}

#pragma mark - scrollview代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    if (scrollView1.contentOffset.x == 0)
    {
        pageCtrl.currentPage = 0;
    }
    else if(scrollView1.contentOffset.x == KGSCREEN.size.width)
    {
        pageCtrl.currentPage = 1;
    }
}

#pragma mark - 设置数据
- (void)setData:(NSMutableArray *)datas
{
    scrollView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(KGSCREEN.size.width * 2, 0);
    scrollView.pagingEnabled = YES;
    
    CGFloat margin4 = (KGSCREEN.size.width - (4 * (ItemWidth))) / 5;
    CGFloat margin3 = (KGSCREEN.size.width - (3 * (ItemWidth))) / 4;
    
    //-1是因为最后一个是查看全部，不用显示上去
    for (NSInteger i=0; i<datas.count-1; i++)
    {
        SpCourseItem * item = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseItem" owner:nil options:nil] firstObject];
        
        SPCourseTypeDomain * domain = datas[i];
        [item setDatas:domain];
        
        item.courseBtn.tag = i;
        [item.courseBtn addTarget:self action:@selector(courseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat itemX = 0;
        if (i<=3)
        {
            itemX = margin4 + (margin4 * i) + ItemWidth * i;
        }
        else
        {
            itemX = margin3 + margin3 + (margin4 * i) + ItemWidth * i;
        }
        
        CGFloat itemY = 0;
        
        item.frame = CGRectMake(itemX, itemY, ItemWidth, ItemHeight);
        
        [scrollView addSubview:item];
    }
}

- (void)courseBtnClick:(UIButton *)btn
{
    [self.delegate pushToVC:btn];
}


- (IBAction)hotCourseMoreBtn:(UIButton *)sender
{
    [self.delegate pushToHotCourseVC];
}

@end
