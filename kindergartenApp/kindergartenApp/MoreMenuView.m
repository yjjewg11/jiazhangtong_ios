//
//  MoreMenuViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "MoreMenuView.h"
#import "DynamicMenuDomain.h"
#import "UIImageView+WebCache.h"
#import "UIButton+Extension.h"

@interface MoreMenuView () {
    UIView * headView;
    UIView * moreFunView;
    UIView * cancelView;
    NSArray * moreMenuArray;
}

@end

@implementation MoreMenuView

- (void)loadMoreMenu:(NSArray *)menuArray {
    moreMenuArray = menuArray;
    
    [self loadHeadView];
    [self loadMoreFunView];
    [self loadCancelView];
}


//加载头部部分
- (void)loadHeadView {
    headView = [[UIView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, KGSCREEN.size.width, 32)];
    [self addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, CGRectGetWidth(headView.frame), CGRectGetHeight(headView.frame))];
    label.text = @"更多";
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:label];
}

//加载更多功能按钮部分
- (void)loadMoreFunView {
    
    CGFloat itemViewW = KGSCREEN.size.width / Number_Four;
    CGFloat itemViewH = 77;
    CGFloat itemViewY = Number_Zero;
    CGFloat itemImgWH = 45;
    CGFloat itemImgX  = (itemViewW - itemImgWH) / Number_Two;
    CGFloat itemLabelY = itemImgWH + Number_Seven;
    CGFloat itemLabelH = Number_Ten;
    NSInteger col  = Number_Zero;
    NSInteger row  = Number_Zero;
    
    NSInteger totalRow = ([moreMenuArray count] + Number_Four - Number_One) / Number_Four;
    moreFunView = [[UIView alloc] initWithFrame:CGRectMake(Number_Zero, CGRectGetMaxY(headView.frame), KGSCREEN.size.width, totalRow * itemViewH)];
    moreFunView.backgroundColor = [UIColor whiteColor];
    [self addSubview:moreFunView];
    
    for(NSInteger i=Number_Zero; i<[moreMenuArray count]; i++) {
        
        DynamicMenuDomain * domain = [moreMenuArray objectAtIndex:i];
        
        if(col == Number_Four) {
            col = Number_Zero;
            row++;
        }
        
        UIView * itemView = [[UIView alloc] initWithFrame:CGRectMake(col * itemViewW, itemViewY * row, itemViewW, itemViewH)];
        itemView.backgroundColor = [UIColor clearColor];
        [moreFunView addSubview:itemView];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemImgX, Number_Zero, itemImgWH, itemImgWH)];
        [itemView addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:domain.iconUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        
        UILabel * itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(Number_Zero, itemLabelY, itemViewW, itemLabelH)];
        itemLabel.text = domain.name;
        itemLabel.font = [UIFont systemFontOfSize:Number_Ten];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        [itemView addSubview:itemLabel];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(itemView.x, itemView.y, itemView.width, itemView.height + itemLabelH)];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [moreFunView addSubview:btn];
        
        col++;
    }
}

//加载取消部分
- (void)loadCancelView {
    cancelView = [[UIView alloc] initWithFrame:CGRectMake(Number_Zero, CGRectGetMaxY(moreFunView.frame), KGSCREEN.size.width, 32)];
    [self addSubview:cancelView];
    cancelView.backgroundColor = [UIColor whiteColor];
    
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, CGRectGetWidth(cancelView.frame), CGRectGetHeight(cancelView.frame))];
    [cancelBtn setText:@"收起"];
    [cancelBtn setTextColor:[UIColor blackColor] sel:[UIColor blackColor]];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelView addSubview:cancelBtn];
}

- (void)cancelBtnClicked:(UIButton *)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(cancelCallback)]) {
        [_delegate cancelCallback];
    }
}


@end
