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
    RecipesInfoView * lastSelItemView;
    NSInteger   reqIndex; //记录请求的inex
    NSMutableArray *  allRecipesMArray; //所有食谱
    NSArray        *  groupArray;
}

@end

@implementation RecipesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"每日食谱";
    self.view.layer.masksToBounds = YES;
    self.view.clipsToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.keyBoardController.isShowKeyBoard = YES;
    self.keyboardTopType = EmojiAndTextMode;
    
    lastIndex  = Number_Fourteen;
    totalCount = Number_Thirtyt;
    isFirstReq = YES;
    groupArray = [KGHttpService sharedService].loginRespDomain.group_list;
    allRecipesMArray = [NSMutableArray new];
    
    [self loadFlowScrollView];
    [self loadRecipesInfoViewToScrollView];
    
    lastSelItemView = [itemViewArray objectAtIndex:lastIndex];
    [self getQueryDate:lastIndex];
    [self loadRecipesInfoByData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadFlowScrollView {
    contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.delegate = self;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.clipsToBounds = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:contentScrollView];
    contentScrollView.size = CGSizeMake(APPWINDOWWIDTH, APPWINDOWHEIGHT- APPWINDOWTOPHEIGHTIOS7);
    contentScrollView.origin = CGPointMake(0, 0);
    contentScrollView.contentSize = CGSizeMake(APPWINDOWWIDTH * totalCount, contentScrollView.height);
}

- (void)loadRecipesInfoViewToScrollView {
    itemViewArray = [[NSMutableArray alloc] initWithCapacity:totalCount];
    
    for(NSInteger i=Number_Zero; i<totalCount; i++){
        RecipesInfoView * itemView = [[RecipesInfoView alloc] initWithFrame:CGRectMake(i*APPWINDOWWIDTH, 0, APPWINDOWWIDTH, contentScrollView.height)];
        [contentScrollView addSubview:itemView];
        [itemViewArray addObject:itemView];
    }
    [contentScrollView setContentOffset:CGPointMake(APPWINDOWWIDTH * lastIndex, Number_Zero) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 得到每页宽度
    CGFloat pageWidth = KGSCREEN.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(lastIndex!=currentIndex) {
        lastSelItemView = [itemViewArray objectAtIndex:currentIndex];
        [self getQueryDate:currentIndex];
        if(!lastSelItemView.allRecipesArray || [lastSelItemView.allRecipesArray count]==Number_Zero) {
            [self loadRecipesInfoByData];
        }
        
        lastIndex = currentIndex;
    }
}


//加载食谱数据
- (void)loadRecipesInfoByData {
    
    if(groupArray && [groupArray count] > Number_Zero) {
        
        [[KGHUD sharedHud] show:self.contentView];
        isFirstReq = NO;
        GroupDomain * groupDmain = [groupArray objectAtIndex:reqIndex];
        
        [[KGHttpService sharedService] getRecipesList:groupDmain.uuid beginDate:lastDateStr endDate:nil success:^(NSArray *recipesArray) {
            
            [[KGHUD sharedHud] hide:self.contentView];
            
            RecipesDomain * tempDomain = [[RecipesDomain alloc] init];
            if(recipesArray && [recipesArray count]>Number_Zero) {
                tempDomain = [recipesArray objectAtIndex:Number_Zero];
                tempDomain.isReqSuccessData = YES;
            }
            tempDomain.plandate = lastDateStr;
            
            [allRecipesMArray addObject:tempDomain];
            [self responseHandler];
            
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
    
}


- (void)getQueryDate:(NSInteger)index {
    if(!isFirstReq) {
        if(index != lastIndex) {
            lastDateStr = [KGDateUtil calculateDay:lastDateStr date:lastIndex-index];
        }
    } else {
        lastDateStr = [KGDateUtil getDate:Number_Zero];
    }
}

//请求之后的处理 需要判断是否还需要再次请求
- (void)responseHandler {
    reqIndex++;
    if(reqIndex < [groupArray count]) {
        [self loadRecipesInfoByData];
    } else {
        [lastSelItemView loadRecipesData:allRecipesMArray];
        [allRecipesMArray removeAllObjects];
        reqIndex = Number_Zero;
    }
}

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain {
    [lastSelItemView resetTopicReplyContent:domain topicInteraction:self.topicInteractionDomain];
}


@end
