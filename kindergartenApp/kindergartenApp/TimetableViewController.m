//
//  TimetableViewController.m
//  kindergartenApp
//
//  Created by You on 15/8/10.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TimetableViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "Masonry.h"
#import "TimetableItemView.h"
#import "KGDateUtil.h"
#import "KGUser.h"
#import "TimetableItemVO.h"

@interface TimetableViewController () <UIScrollViewDelegate> {
    NSMutableArray  * itemViewArray;
    NSInteger totalCount;
    NSInteger lastIndex;//记录scrollview翻动的index
    NSInteger weekIndex;//记录周数 上翻 周数-1  下翻+1
    BOOL      isFirstReq;
    UIScrollView   * contentScrollView;
    NSMutableArray * classuuidMArray; //班级uuid集合
    NSMutableDictionary * allTimetableMDic; //所有班级的课程表集合 key=classuuid value=一周的课程表
    NSString  * beginDataStr;
    NSString  * endDataStr;
    NSInteger   reqIndex; //记录请求的inex
}

@end

@implementation TimetableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"课程表";
    self.view.layer.masksToBounds = YES;
    self.view.clipsToBounds = YES;
    
    lastIndex  = Number_Fifteen;
    totalCount = Number_Thirtyt;
    isFirstReq = YES;
    allTimetableMDic = [[NSMutableDictionary alloc] init];
    
    [self reqTotal];
    [self loadFlowScrollView];
    [self loadRecipesInfoViewToScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//需要请求的次数
- (void)reqTotal {
    NSArray * users = [KGHttpService sharedService].loginRespDomain.list;
    classuuidMArray = [[NSMutableArray alloc] init];
    NSString * tempUUID = nil;
    for(KGUser * user in users) {
        if(!tempUUID || ![user.classuuid isEqualToString:tempUUID]) {
            [classuuidMArray addObject:user.classuuid];
        }
    }
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
    contentScrollView.origin = CGPointZero;
    contentScrollView.contentSize = CGSizeMake(APPWINDOWWIDTH * totalCount, contentScrollView.height);
}

- (void)loadRecipesInfoViewToScrollView {
    itemViewArray = [[NSMutableArray alloc] initWithCapacity:totalCount];
    
    for(NSInteger i=Number_Zero; i<totalCount; i++){
        TimetableItemView * itemView = [[TimetableItemView alloc] initWithFrame:CGRectMake(i*APPWINDOWWIDTH, Number_Zero, APPWINDOWWIDTH, contentScrollView.height)];
        [contentScrollView addSubview:itemView];
        [itemViewArray addObject:itemView];
    }
    
    [contentScrollView setContentOffset:CGPointMake(APPWINDOWWIDTH * (totalCount / Number_Twelve), Number_Zero) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 得到每页宽度
    CGFloat pageWidth = KGSCREEN.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(lastIndex!=currentIndex) {
        [self getQueryDate:currentIndex];
        TimetableItemView * itemView = [itemViewArray objectAtIndex:currentIndex];
        if(!itemView.tableDataSource || [itemView.tableDataSource count]==Number_Zero) {
            
            [self loadRecipesInfoByData:itemView];
        }
        isFirstReq = NO;
        lastIndex = currentIndex;
    }
}


//加载课程表数据
- (void)loadRecipesInfoByData:(TimetableItemView *)itemView {
    [[KGHUD sharedHud] show:self.contentView];
    [[KGHttpService sharedService] getTeachingPlanList:beginDataStr endDate:endDataStr cuid:[classuuidMArray objectAtIndex:reqIndex] success:^(NSArray *teachPlanArray) {
        
        [[KGHUD sharedHud] hide:self.contentView];
        
        if(teachPlanArray && [teachPlanArray count] > Number_Zero) {
            [allTimetableMDic setObject:teachPlanArray forKey:[classuuidMArray objectAtIndex:reqIndex]];
        }
        
        [self responseHandler:itemView];
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        [self responseHandler:itemView];
    }];
}


- (void)getQueryDate:(NSInteger)index {
    if(!isFirstReq) {
        if(index != lastIndex) {
            
            if(lastIndex > index) {
                weekIndex++;
            } else {
                weekIndex--;
            }
            
            NSString * today = [KGDateUtil getDate:Number_Zero];
            NSString * nextWeekDay = [KGDateUtil calculateDay:today date:weekIndex * 7];
            beginDataStr = [KGDateUtil getBeginWeek:nextWeekDay];
            endDataStr = [KGDateUtil getEndWeek:nextWeekDay];
        }
    } else {
        NSString * today = [KGDateUtil getDate:Number_Zero];
        beginDataStr = [KGDateUtil getBeginWeek:today];
        endDataStr = [KGDateUtil getEndWeek:today];
    }
}

//请求之后的处理 需要判断是否还需要再次请求
- (void)responseHandler:(TimetableItemView *)itemView {
    reqIndex++;
    if(reqIndex < [classuuidMArray count]) {
        [self loadRecipesInfoByData:itemView];
    } else {
        
        [itemView loadTimetableData:[self packageItemViewData] date:[NSString stringWithFormat:@"%@~%@", beginDataStr, endDataStr]];
        [allTimetableMDic removeAllObjects];
        reqIndex = Number_Zero;
    }
}

//数据封装
- (NSMutableArray *)packageItemViewData {
    NSMutableArray  * allTimetableMArray = [[NSMutableArray alloc] init];
    TimetableItemVO * itemVO = nil;
    NSArray * users = [KGHttpService sharedService].loginRespDomain.list;
    
    for(KGUser * user in users) {
        itemVO = [[TimetableItemVO alloc] init];
        itemVO.classuuid = user.classuuid;
        itemVO.headUrl   = user.headimg;
        itemVO.timetableMArray = [allTimetableMDic objectForKey:user.classuuid];
        [allTimetableMArray addObject:itemVO];
    }
    
    return allTimetableMArray;
}


@end
