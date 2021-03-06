//
//  SpCourseHomeFuncCell.m
//  kindergartenApp
//
//  Created by Mac on 16/1/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "SpCourseHomeFuncCell.h"
#import "SpCourseItem.h"
#import "SPCourseTypeDomain.h"
#define ItemHeight 64
#define ItemWidth  45


@interface SpCourseHomeFuncCell()
{
    __weak IBOutlet UIScrollView *scrollView;
    
}

@end

@implementation SpCourseHomeFuncCell

- (IBAction)btnClick:(id)sender
{
    [self.delegate pushToHotCourseVC];
}

#pragma mark - 设置数据
- (void)setData:(NSMutableArray *)datas
{
    scrollView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(KGSCREEN.size.width, 0);
    scrollView.pagingEnabled = YES;
    
    CGFloat margin4 = (KGSCREEN.size.width - (4 * (ItemWidth))) / 5;
    
    //-1是因为最后一个是查看全部，不用显示上去
    for (NSInteger i=0; i<datas.count-1; i++)
    {
        SpCourseItem * item = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseItem" owner:nil options:nil] firstObject];
        
        SPCourseTypeDomain * domain = datas[i];
        [item setDatas:domain];
        
        item.courseBtn.tag = i;
        [item.courseBtn addTarget:self action:@selector(courseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat itemY = 0;
        CGFloat itemX = 0;
        
        if (i<4)
        {
            itemX = margin4 + (margin4 * i) + ItemWidth * i;
        }
        else
        {
            itemX = margin4 + (margin4 * (i - 4)) + ItemWidth * (i - 4);
            itemY = 64 + 10;
        }
        
        item.frame = CGRectMake(itemX, itemY, ItemWidth, ItemHeight);
        
        [scrollView addSubview:item];
    }
}

- (void)courseBtnClick:(UIButton *)btn
{
    [self.delegate pushToVC:btn];
}


@end
