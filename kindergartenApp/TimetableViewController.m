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
#import "MJExtension.h"
#import "MySPCourseDomain.h"
#import "SPTimetableDomain.h"
#import "MySPCourseDetailVC.h"
#import "SPCourseDetailDomain.h"

@interface TimetableViewController () <UIScrollViewDelegate,TimetableItemViewDelegate>
{
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
    NSInteger   reqIndex; //记录请求的index
    TimetableItemView * lastSelItemView; //当前选中的view
}

@property (strong, nonatomic) NSMutableArray * studyingCourseArr;

@property (assign, nonatomic) NSInteger pageNo;

@end

@implementation TimetableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNo = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"课程表";
    self.view.layer.masksToBounds = YES;
    self.view.clipsToBounds = YES;
    
    self.keyBoardController.isShowKeyBoard = YES;
    self.keyboardTopType = EmojiAndTextMode;
    
    lastIndex  = Number_Fourteen;
    totalCount = Number_Thirtyt;
    isFirstReq = YES;
    allTimetableMDic = [[NSMutableDictionary alloc] init];
    
    [self reqTotal];
    [self loadFlowScrollView];
    [self loadRecipesInfoViewToScrollView];
    
    lastSelItemView = [itemViewArray objectAtIndex:lastIndex];
    [self getQueryDate:lastIndex];
    
    for (UIView *v in self.view.subviews)
    {
        v.hidden = YES;
    }
    
    //加载数据
    [self loadRecipesInfoByData];
    //加载特长课程表数据
    [self loadSPInfoDatas];
    
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
        
        itemView.delegate = self;
        
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
        [self getQueryDate:currentIndex];
        lastSelItemView = [itemViewArray objectAtIndex:currentIndex];
        if(!lastSelItemView.tableDataSource || [lastSelItemView.tableDataSource count]==Number_Zero) {
            [self loadRecipesInfoByData];    //翻页的时候重新请求数据
            [self loadSPInfoDatas];          //翻页的时候重新请求数据
        }
        
        lastIndex = currentIndex;
    }
}

#pragma mark - 加载幼儿园课程表数据
- (void)loadRecipesInfoByData {
    
    if([classuuidMArray count] > Number_Zero) {
        [[KGHUD sharedHud] show:self.view];
        isFirstReq = NO;
        
        //获取课程表数据
        [[KGHttpService sharedService] getTeachingPlanList:beginDataStr endDate:endDataStr cuid:[classuuidMArray objectAtIndex:reqIndex] success:^(NSArray *teachPlanArray) {
            
            [[KGHUD sharedHud] hide:self.view];
            
            if(teachPlanArray && [teachPlanArray count] > Number_Zero) {
                [allTimetableMDic setObject:teachPlanArray forKey:[classuuidMArray objectAtIndex:reqIndex]];
            }
            [self responseHandler];
            
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
            [self responseHandler];
        }];
    } else {
        [[KGHUD sharedHud] hide:self.view];
    }
}

#pragma mark - 加载特长班课程表数据
- (void)loadSPInfoDatas
{
    [[KGHttpService sharedService] getSPTeachingPlanList:^(NSArray *spTeachPlanArray)
    {
        //加载数据到表表格中
        [lastSelItemView loadSPTimetableData:spTeachPlanArray];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
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
- (void)responseHandler {
    reqIndex++;
    if(reqIndex < [classuuidMArray count]) {
        [self loadRecipesInfoByData];
    } else {
        for (UIView *v in self.view.subviews){
            v.hidden = NO;
        }
        [lastSelItemView loadTimetableData:allTimetableMDic date:[NSString stringWithFormat:@"%@~%@", beginDataStr, endDataStr]];
        [allTimetableMDic removeAllObjects];
        reqIndex = Number_Zero;
    }
}

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain {
    [lastSelItemView resetTopicReplyContent:domain topicInteraction:self.topicInteractionDomain];
}

#pragma mark - 请求正在学学习数据
- (void)getMySPStudyingCourseListData:(MySPCourseDomain *)domain
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPSchoolInfoTimeTableUrl:domain.groupuuid success:^(NSString *vo)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        domain.logo = vo;
        
        MySPCourseDetailVC * vc = [[MySPCourseDetailVC alloc] init];
        
        vc.domain = domain;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

- (void)pushVCWithClassuuid:(MySPCourseDomain *)domain
{
    [self getMySPStudyingCourseListData:domain];
}

@end
