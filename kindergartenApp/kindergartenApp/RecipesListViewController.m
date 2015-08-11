//
//  RecipesListViewController.m
//  kindergartenApp
//
//  Created by You on 15/8/7.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "RecipesListViewController.h"
#import "RecipesInfoView.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "KGDateUtil.h"
#import "UIView+Extension.h"
#import "Masonry.h"

@interface RecipesListViewController () <UIScrollViewDelegate> {
    RecipesInfoView * recipesInfoView;
    NSString * lastDateStr;
    NSMutableArray  * itemViewArray;
    NSInteger totalCount;
    NSInteger lastIndex;
    BOOL      isFirstReq;
    UIScrollView * contentScrollView;
}

@end

@implementation RecipesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"每日食谱";
    
    totalCount = Number_Thirtyt;
    isFirstReq = YES;
    
    [self loadFlowScrollView];
    [self loadRecipesInfoViewToScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadFlowScrollView {
    contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.backgroundColor = [UIColor brownColor];
    contentScrollView.delegate = self;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.clipsToBounds = NO;
    contentScrollView.showsHorizontalScrollIndicator = YES;
    contentScrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:contentScrollView];
    
    [contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)loadRecipesInfoViewToScrollView {
    itemViewArray = [[NSMutableArray alloc] initWithCapacity:totalCount];
    
    for(NSInteger i=Number_Zero; i<totalCount; i++){
        RecipesInfoView * itemView = [[RecipesInfoView alloc] initWithFrame:CGRectMake(i*KGSCREEN.size.width, Number_Zero, KGSCREEN.size.width, KGSCREEN.size.height - 64)];
        [contentScrollView addSubview:itemView];
        [itemViewArray addObject:itemView];
    }
    
    contentScrollView.contentSize = CGSizeMake(KGSCREEN.size.width * totalCount, self.contentView.height);
    [contentScrollView setContentOffset:CGPointMake(KGSCREEN.size.width * (totalCount-Number_One), Number_Zero) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 得到每页宽度
    CGFloat pageWidth = KGSCREEN.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(lastIndex!=currentIndex) {
        RecipesInfoView * itemView = [itemViewArray objectAtIndex:currentIndex];
        if(!itemView.recipesDomain) {
            [self getQueryDate:currentIndex];
            [self loadRecipesInfoByData:itemView];
        }
        isFirstReq = NO;
        lastIndex = currentIndex;
    }
}


//加载食谱数据
- (void)loadRecipesInfoByData:(RecipesInfoView *)recInfoView {
    [[KGHUD sharedHud] show:self.contentView];
    
    [[KGHttpService sharedService] getRecipesList:lastDateStr endDate:nil success:^(NSArray *recipesArray) {
        
        [[KGHUD sharedHud] hide:self.contentView];
        
        RecipesDomain * tempDomain = [[RecipesDomain alloc] init];
        tempDomain.plandate = lastDateStr;
        if(recipesArray && [recipesArray count]>Number_Zero) {
            tempDomain = [recipesArray objectAtIndex:Number_Zero];
            tempDomain.isReqSuccessData = YES;
        }
        
        [recInfoView loadRecipesData:tempDomain];
        
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}


- (void)getQueryDate:(NSInteger)index {
    if(!isFirstReq) {
        if(index != lastIndex) {
            lastDateStr = [KGDateUtil nextOrPreyDay:lastDateStr date:lastIndex-index];
        }
    } else {
        lastDateStr = [KGDateUtil getDate:Number_Zero];
    }
}


@end
