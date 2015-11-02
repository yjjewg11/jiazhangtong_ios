//
//  SpecialtyCoursesViewController.m
//  kindergartenApp
//
//  Created by OxfordLing on 15/10/19.
//  Tel:18080246336
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpecialtyCoursesViewController.h"
#import "AFNetworking.h"
#import "SDCycleScrollView.h"
#import "KGHttpService.h"
#import "KGHttpUrl.h"
#import "SpCourseItem.h"
#import "ACMacros.h"
#import "SpCourseVC.h"
#import "SPCourseSchoolVC.h"
#import "KGHUD.h"


@interface SpecialtyCoursesViewController () <SDCycleScrollViewDelegate>
{
    __weak IBOutlet UIView *adScrollView;
    __weak IBOutlet UIView *courseView;
    __weak IBOutlet UIScrollView *contentScrollView;
}

@property (strong, nonatomic) NSArray * adPictures;

@property (strong, nonatomic) NSArray * spCourseDomains;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * spCourseViewHeight;

@property (strong, nonatomic) SpCourseVC * tableVC;

@property (strong, nonatomic) NSArray * hotSpCourses;

@property (strong, nonatomic) NSMutableArray * spCourseDatakeys;

@property (assign, nonatomic) NSInteger reqIndex;

@end

@implementation SpecialtyCoursesViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    contentScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.tableVC.tableView.frame));
}

- (NSMutableArray *)spCourseDatakeys
{
    if(_spCourseDatakeys == nil)
    {
        _spCourseDatakeys = [NSMutableArray array];
    }
    return _spCourseDatakeys;
}

- (SpCourseVC * )tableVC
{
    if (_tableVC == nil)
    {
        _tableVC = [[SpCourseVC alloc] init];
        CGFloat tableX = Number_Zero;
        CGFloat tableY = CGRectGetMaxY(courseView.frame) + self.spCourseViewHeight.constant - Number_Ten;
        CGFloat tableW = App_Frame_Width;
        CGFloat tableH = Row_Height * 10 + Cell_Height3;
        _tableVC.tableFrame = CGRectMake(tableX, tableY, tableW, tableH);
        _tableVC.showHeaderView = YES;
    }
    return _tableVC;
}

- (NSArray * )adPictures
{
    if (_adPictures == nil)
    {
        _adPictures = [NSArray array];
    }
    return _adPictures;
}

- (NSArray * )spCourseDomains
{
    if (_spCourseDomains == nil)
    {
        _spCourseDomains = [NSArray array];
    }
    return _spCourseDomains;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"特长课程";
    
    for (UIView *v in self.view.subviews)
    {
        v.hidden = YES;
    }
    
    [self loadAdPicts];
    
    [self loadSPCourse];
    
    [self setUpAdScroll];//创建滚动广告
    
    [self setUpSPCoursesTable];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //试一试
}

#pragma mark - 创建图片轮播器
- (void)setUpAdScroll
{
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:adScrollView.frame imageURLStringsGroup:self.adPictures];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.delegate = self;
    cycleScrollView2.dotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.placeholderImage = [UIImage imageNamed:@"placeholder"];
    [adScrollView addSubview:cycleScrollView2];
}

#pragma mark - 从接口加载广告内容
- (void)loadAdPicts
{
    self.adPictures = @[
                        @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                        @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                        @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                        ];
}

#pragma mark - 加载特长课程分类
- (void)loadSPCourse
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseType:^(NSArray *spCourseTypeArr)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        self.spCourseDomains = spCourseTypeArr;
        [self setUpSPCourses];
        
        [self responseHandler];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
        [self responseHandler];
    }];
}

//请求之后的处理 需要判断是否还需要再次请求
- (void)responseHandler {
    self.reqIndex++;
    if(self.spCourseDomains.count == 0)
    {
        [self loadSPCourse];
    }
    else
    {
        for (UIView *v in self.view.subviews)
        {
            v.hidden = NO;
        }
        self.reqIndex = Number_Zero;
    }
}

#pragma mark - 根据特长课程创建图标显示
- (void)setUpSPCourses
{
    int totalloc = 4;
    CGFloat spcoursew = 53;
    CGFloat spcourseh = 71;
    CGFloat margin = (App_Frame_Width - totalloc * spcoursew) / (totalloc + 1);
    CGFloat lastH = 0;
    
    for (NSInteger i = 0; i < self.spCourseDomains.count; i++)
    {
        NSInteger row = (NSInteger)(i / totalloc);  //行号
        NSInteger loc = i % totalloc;               //列号
        
        SpCourseItem * item = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseItem" owner:nil options:nil] firstObject];
        
        SPCourseTypeDomain * domain = self.spCourseDomains[i];
        [item setDatas:domain];
        
        [self.spCourseDatakeys addObject:@(domain.datakey)];
        
        item.courseBtn.tag = i;
        [item.courseBtn addTarget:self action:@selector(courseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat itemX = margin + (margin + spcoursew) * loc;
        CGFloat itemY =  (margin + spcourseh) * row;
        CGFloat itemH = item.frame.size.height;
        CGFloat itemW = item.frame.size.width;
        
        item.frame = CGRectMake(itemX, itemY, itemW, itemH);
        lastH = CGRectGetMaxY(item.frame);
        [courseView addSubview:item];
    }
    
    self.spCourseViewHeight.constant = Number_Ten + lastH;
}

#pragma mark - 选择课程按钮点击
- (void)courseBtnClick:(UIButton * )btn
{
    SPCourseTypeDomain * domain = self.spCourseDomains[btn.tag];
    
    SPCourseSchoolVC * courseSchoolVC = [[SPCourseSchoolVC alloc] init];
    
    NSMutableArray *marr = [NSMutableArray array];
    NSInteger clickedIndex = 0;
    for (NSInteger i=0;i<self.spCourseDomains.count;i++)
    {
        SPCourseTypeDomain *d = self.spCourseDomains[i];
        if ([d.datavalue isEqualToString:domain.datavalue])
        {
            clickedIndex = i;
        }
        [marr addObject:d.datavalue];
    }
    
    [marr exchangeObjectAtIndex:0 withObjectAtIndex:clickedIndex];
    [self.spCourseDatakeys exchangeObjectAtIndex:0 withObjectAtIndex:clickedIndex];
    
    courseSchoolVC.courseNameList = marr;
    courseSchoolVC.firstJoinSelType = domain.datavalue;
    courseSchoolVC.firstJoinSelDatakey = domain.datakey;
    courseSchoolVC.courseDatakeys = self.spCourseDatakeys;
    
    [self.navigationController pushViewController:courseSchoolVC animated:YES];
    
}

- (void)setUpSPCoursesTable
{
    [contentScrollView addSubview:self.tableVC.tableView];
}

@end
