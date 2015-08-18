//
//  HomeViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "HomeViewController.h"
#import "ImageCollectionView.h"
#import "Masonry.h"
#import "IntroductionViewController.h"
#import "UIView+Extension.h"
#import "RegViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "AnnouncementListViewController.h"
#import "InteractViewController.h"
#import "TeacherJudgeViewController.h"
#import "SpecialtyCoursesViewController.h"
#import "GiftwareArticlesViewController.h"
#import "StudentSignRecordViewController.h"
#import "RecipesViewController.h"
#import "MoreMenuView.h"
#import "PopupView.h"
#import "RecipesListViewController.h"
#import "TimetableViewController.h"
#import "UIColor+Extension.h"
#import "UIButton+Extension.h"
#import "ItemTitleButton.h"
#import "BrowseURLViewController.h"

#import "BaiduMobAdInterstitial.h"
#import "BaiduMobAdDelegateProtocol.h"
#import "BaiduMobAdView.h"

@interface HomeViewController () <ImageCollectionViewDelegate, UIGestureRecognizerDelegate,BaiduMobAdViewDelegate> {
    
    IBOutlet UIScrollView * scrollView;
    IBOutlet UIView * photosView;
    IBOutlet UIView * funiView;
    
    IBOutlet UIView * moreView;
    IBOutlet UIImageView * moreImageView;
    PopupView * popupView;
    UIView    * groupListView;
    ItemTitleButton  * titleBtn;
    NSArray   * groupDataArray;
    CGFloat     groupViewHeight;
    
    BaiduMobAdView * sharedAdView;
}

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self requestGroupDate];
//    if(!groupListView) {
//        [self loadGroupListView];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(self.view.width, funiView.y + funiView.height + Number_Ten);
    
    [self loadPhotoView];
}

- (void)loadNavTitle {
    titleBtn = [[ItemTitleButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [titleBtn setImage:@"xiajiantou" selImg:@"sjiantou"];
    // 设置图片和文字
    [titleBtn setTitle:@"首页"
                 forState:UIControlStateNormal];
    // 监听标题点击
    [titleBtn addTarget:self
                    action:@selector(titleFunBtnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
}

- (void)titleFunBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    CGFloat y = 64;
    if(!sender.selected) {
        y -= groupViewHeight;
        titleBtn.selected = NO;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        groupListView.y = y;
    }];
}

//加载机构下拉列表
- (void)loadGroupListView {
    if(groupDataArray && [groupDataArray count]>Number_Zero) {
        
        groupViewHeight = [groupDataArray count] * Cell_Height2;
        if (!groupListView) {
            groupListView = [[UIView alloc] initWithFrame:CGRectMake(Number_Zero, 64-groupViewHeight, KGSCREEN.size.width, groupViewHeight)];
            groupListView.backgroundColor = KGColorFrom16(0xE64662);
            [self.view addSubview:groupListView];
        }else{
            [groupListView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        GroupDomain *         domain = nil;
        UILabel     * groupNameLabel = nil;
        UILabel     *    spliteLabel = nil;
        UIButton    *            btn = nil;
        CGFloat   y = Number_Zero;
        
        for(NSInteger i=Number_Zero; i<[groupDataArray count]; i++) {
            
            domain = [groupDataArray objectAtIndex:i];
            y = Number_Fifteen + (i*Cell_Height2);
            
            groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(Number_Zero, y, KGSCREEN.size.width, Number_Fifteen)];
            groupNameLabel.font = [UIFont systemFontOfSize:Number_Fifteen];
            groupNameLabel.text = domain.company_name;
            groupNameLabel.textColor = [UIColor whiteColor];
            groupNameLabel.textAlignment = NSTextAlignmentCenter;
            [groupListView addSubview:groupNameLabel];
            
            btn = [[UIButton alloc] initWithFrame:CGRectMake(Number_Zero, y, KGSCREEN.size.width, Cell_Height2)];
            btn.targetObj = domain;
            [btn addTarget:self action:@selector(didSelectedGroupList:) forControlEvents:UIControlEventTouchUpInside];
            [groupListView addSubview:btn];
            
            if(i < [groupDataArray count]-Number_One) {
                spliteLabel = [[UILabel alloc] initWithFrame:CGRectMake(Number_Zero, CGRectGetMaxY(groupNameLabel.frame) + Number_Fifteen, KGSCREEN.size.width, 0.5)];
                spliteLabel.backgroundColor = [UIColor whiteColor];
                [groupListView addSubview:spliteLabel];
            }
        }
    }
}


//选择机构
- (void)didSelectedGroupList:(UIButton *)sender {
    
    GroupDomain * domain = (GroupDomain *)sender.targetObj;
    [titleBtn setText:domain.company_name];
    [KGHttpService sharedService].groupDomain = domain;

    [self titleFunBtnClicked:titleBtn];
    
}

- (void)requestGroupDate {
    [[KGHttpService sharedService] getGroupList:^(NSArray *groupArray) {
        
        groupDataArray = groupArray;
        [self loadNavTitle];
        [self loadGroupListView];
    } faild:^(NSString *errorMsg) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadPhotoView {
    
    sharedAdView = [[BaiduMobAdView alloc] init];
    sharedAdView.AdType = BaiduMobAdViewTypeBanner;
    sharedAdView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, photosView.height);
    sharedAdView.delegate = self;
    [photosView addSubview:sharedAdView];
    [sharedAdView start];
}

- (void)viewWillAppear:(BOOL)animated{
    if (sharedAdView) {
        [sharedAdView start];
    }
}


#pragma mark - 百度广告代理方法
- (NSString *)publisherId{
    return @"e7fccb77";
}

- (BOOL)enableLocation{
    return NO;
}

- (void)willDisplayAd:(BaiduMobAdView *)adview{
    sharedAdView.hidden = NO;
    CGRect f = sharedAdView.frame;
    f.origin.x = -APPWINDOWWIDTH;
    sharedAdView.frame = f;
    [UIView beginAnimations:nil context:nil];
    f.origin.x = 0;
    sharedAdView.frame = f;
    [UIView commitAnimations];
}

- (void)failedDisplayAd:(BaiduMobFailReason)reason{
    NSLog(@"广告加载失败");
}

//人群属性接口
/**
 *  - 关键词数组
 */
-(NSArray*) keywords{
    NSArray* keywords = [NSArray arrayWithObjects:@"测试",@"关键词", nil];
    return keywords;
}

/**
 *  - 用户性别
 */
-(BaiduMobAdUserGender) userGender{
    return BaiduMobAdMale;
}

/**
 *  - 用户生日
 */
-(NSDate*) userBirthday{
    NSDate* birthday = [NSDate dateWithTimeIntervalSince1970:0];
    return birthday;
}

/**
 *  - 用户城市
 */
-(NSString*) userCity{
    return @"上海";
}


/**
 *  - 用户邮编
 */
-(NSString*) userPostalCode{
    return @"435200";
}


/**
 *  - 用户职业
 */
-(NSString*) userWork{
    return @"家长";
}

/**
 *  - 用户最高教育学历
 *  - 学历输入数字，范围为0-6
 *  - 0表示小学，1表示初中，2表示中专/高中，3表示专科
 *  - 4表示本科，5表示硕士，6表示博士
 */
-(NSInteger) userEducation{
    return  2;
}

/**
 *  - 用户收入
 *  - 收入输入数字,以元为单位
 */
-(NSInteger) userSalary{
    return 10000;
}

/**
 *  - 用户爱好
 */
-(NSArray*) userHobbies{
    NSArray* hobbies = [NSArray arrayWithObjects:@"学习",@"学生",@"爱好", nil];
    return hobbies;
}

/**
 *  - 其他自定义字段
 */
-(NSDictionary*) userOtherAttributes{
    NSMutableDictionary* other = [[NSMutableDictionary alloc] init];
    [other setValue:@"测试" forKey:@"测试"];
    return other;
}

#pragma ImageCollectionViewDelegate

//单击回调
-(void)singleTapEvent:(NSString *)pType {
    
}



- (IBAction)funBtnClicked:(UIButton *)sender {
    BaseViewController * baseVC = nil;
    switch (sender.tag) {
        case 10:
            baseVC = [[InteractViewController alloc] init];
            break;
        case 11:
            baseVC = [[IntroductionViewController alloc] init];
            break;
        case 12:
            baseVC = [[AnnouncementListViewController alloc] init];
            break;
        case 13:
            baseVC = [[StudentSignRecordViewController alloc] init];
            break;
        case 14:
            baseVC = [[TimetableViewController alloc] init];
            break;
        case 15:
            baseVC = [[RecipesListViewController alloc] init];
            break;
        case 16:
            baseVC = [[GiftwareArticlesViewController alloc] init];
            break;
        case 17:
            baseVC = [[SpecialtyCoursesViewController alloc] init];
            break;
        case 18:
            baseVC = [[TeacherJudgeViewController alloc] init];
            break;
        case 19:
            [self loadMoreFunMenu:sender];
            break;
        default:
            break;
    }
    
    if(baseVC) {
        [self.navigationController pushViewController:baseVC animated:YES];
    }
}


- (void)loadMoreFunMenu:(UIButton *)sender {
    
    if(!popupView) {
        popupView = [[PopupView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, KGSCREEN.size.width, KGSCREEN.size.height)];
        popupView.alpha = Number_Zero;
        
        NSArray * moreMenuArray = [KGHttpService sharedService].dynamicMenuArray;
        NSInteger totalRow = ([moreMenuArray count] + Number_Four - Number_One) / Number_Four;
        CGFloat moreViewH = (totalRow * 77) + 64;
        CGFloat moreViewY = KGSCREEN.size.height - moreViewH;
        MoreMenuView * moreVC = [[MoreMenuView alloc] initWithFrame:CGRectMake(Number_Zero, moreViewY, KGSCREEN.size.width, moreViewH)];
        [popupView addSubview:moreVC];
        [moreVC loadMoreMenu:moreMenuArray];
        moreVC.MoreMenuBlock = ^(DynamicMenuDomain * domain){
            [self didSelectedMoreMenuItem:domain];
        };

        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:popupView];
    }
    
    [UIView viewAnimate:^{
        popupView.alpha = Number_One;
    } time:Number_AnimationTime_Five];
    
}


- (void)popupCallback {
    [UIView viewAnimate:^{
        popupView.alpha = Number_Zero;
    } time:Number_AnimationTime_Five];
}

- (void)didSelectedMoreMenuItem:(DynamicMenuDomain *)domain {
    [self popupCallback];
    
    if(domain) {
        BrowseURLViewController * vc = [[BrowseURLViewController alloc] init];
        vc.title = domain.name;
        vc.url = domain.url;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
