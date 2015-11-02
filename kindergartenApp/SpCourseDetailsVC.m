//
//  SpCourseDetailsVC.m
//  kindergartenApp
//
//  Created by Mac on 15/10/29.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpCourseDetailsVC.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "SPCourseDetailDomain.h"
#import "KGNSStringUtil.h"
#import "SDCycleScrollView.h"
#import "SPSchoolDomain.h"
#import "SPMoreCommentVC.h"

@interface SpCourseDetailsVC () <SDCycleScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *lastView;

@property (weak, nonatomic) IBOutlet UILabel * courseNameLbl;//课程名称
@property (weak, nonatomic) IBOutlet UIView * starView;      //评分view
@property (weak, nonatomic) IBOutlet UILabel * courseInfo;   //具体课程
@property (weak, nonatomic) IBOutlet UILabel * location;     //上课地点
@property (weak, nonatomic) IBOutlet UILabel * courseTime;   //上课时间
@property (weak, nonatomic) IBOutlet UILabel * coursePrice;  //收费价格
@property (weak, nonatomic) IBOutlet UILabel * countPrice;   //优惠价格
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseDetailViewHeightConstraint; //课程详细信息 view 高
@property (weak, nonatomic) IBOutlet UILabel *courseDetailLbl;                             //课程详细信息lbl
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parentsCommentsViewConstraint;    //家长评价view高度


//评论1 start
@property (weak, nonatomic) IBOutlet UILabel * commentOneTel;
@property (weak, nonatomic) IBOutlet UIView * commentOneStar;
@property (weak, nonatomic) IBOutlet UILabel * commentOneLbl;
@property (weak, nonatomic) IBOutlet UILabel * commentOneDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * commentOneLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * commentOneViewHeight;
//评论1 end

//评论2 start
@property (weak, nonatomic) IBOutlet UILabel * commentTwoTel;
@property (weak, nonatomic) IBOutlet UIView * commentTwoStar;
@property (weak, nonatomic) IBOutlet UILabel * commentTwoLbl;
@property (weak, nonatomic) IBOutlet UILabel * commentTwoDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * commentTwoLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * commentTwoViewHeight;
//评论2 end

//评论3 start
@property (weak, nonatomic) IBOutlet UILabel * commentThreeTel;
@property (weak, nonatomic) IBOutlet UIView * commentThreeStar;
@property (weak, nonatomic) IBOutlet UILabel * commentThreeLbl;
@property (weak, nonatomic) IBOutlet UILabel * commentThreeDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * commentThreeLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * commentThreeViewHeight;
//评论3 end

@property (weak, nonatomic) IBOutlet UILabel * schoolInfoLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * schoolInfoLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * schoolInfoViewHeight;



@property (weak, nonatomic) IBOutlet UILabel *lblCourseDiscountFees;
@property (weak, nonatomic) IBOutlet UIView *adScrollView;

@property (weak, nonatomic) IBOutlet UILabel *lblCourseFees;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseMainViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *moreCommitBtn;

//datas
@property (strong, nonatomic) NSArray * adPictures;
@property (strong, nonatomic) SPCourseDetailDomain *domain;
@property (strong, nonatomic) SPSchoolDomain *schoolDomain;

@end

@implementation SpCourseDetailsVC

- (NSArray *)adPictures
{
    if (_adPictures == nil)
    {
        _adPictures = [NSArray array];
    }
    return _adPictures;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"课程详情";
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self loadAdPicts];
    [self setUpAdScroll];
    [self.moreCommitBtn addTarget:self action:@selector(aaa:) forControlEvents:UIControlEventTouchDown];
    
    [self.view bringSubviewToFront:self.moreCommitBtn];
    
    for (UIView *v in self.view.subviews)
    {
        v.hidden = YES;
    }

}

- (void)aaa:(UIButton *)btn
{
    NSLog(@"dawdwa");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getCourseDetail];
    
    [self getSchoolInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.lastView.frame) + Number_Twenty);
}

- (void)getCourseDetail
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseDetail:self.uuid success:^(SPCourseDetailDomain *spCourseDetail)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        self.domain = spCourseDetail;
        
        [self setUpCourseDetail];
        
        [self responseHandlerOfCourse];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

- (void)getSchoolInfo
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseDetailSchoolInfo:self.groupuuid success:^(SPSchoolDomain *spSchoolDetail)
    {
        [[KGHUD sharedHud] hide:self.view];
         
        self.schoolDomain = spSchoolDetail;
        
        [self setUpDetailSchoolInfo];
        
        [self responseHandlerOfSchool];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

- (void)responseHandlerOfCourse
{
    if(self.domain == nil)
    {
        [self getCourseDetail];
    }
    else
    {
        for (UIView *v in self.view.subviews)
        {
            v.hidden = NO;
        }
    }
}

- (void)responseHandlerOfSchool
{
    if(self.schoolDomain == nil)
    {
        [self getSchoolInfo];
    }
    else
    {
        for (UIView *v in self.view.subviews)
        {
            v.hidden = NO;
        }
    }
}


- (void)setUpDetailSchoolInfo
{
    if (self.schoolDomain.description == nil)
    {
        self.schoolDomain.description = @"暂无信息";
    }
    
    self.schoolInfoLbl.text = self.schoolDomain.description;
    
    float textSize = [KGNSStringUtil heightForString:self.courseDetailLbl.text andWidth:APPWINDOWWIDTH - 20];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
       self.schoolInfoViewHeight.constant = [NSNumber numberWithFloat:textSize].floatValue + Number_Sixty;
    });
}

- (void)setUpCourseDetail
{
    self.groupuuid = self.domain.groupuuid;
    
    self.courseNameLbl.text = self.domain.title;
    
    NSInteger intCount = (NSInteger)(self.domain.ct_stars / 10);
    
    NSInteger halfCount = self.domain.ct_stars - intCount;
    
    [self setUpStarts:intCount halfCount:halfCount];
    
    self.courseInfo.text = self.domain.subtype;
    
    if (self.domain.fees == 0)
    {
        self.coursePrice.hidden = YES;
        self.lblCourseFees.hidden = YES;
        
        //调整view高度
        self.courseMainViewHeight.constant = self.courseMainViewHeight.constant - 25;
    }
    if (self.domain.discountfees == 0)
    {
        self.countPrice.hidden = YES;
        self.lblCourseDiscountFees.hidden = YES;
        
        //调整view高度
        self.courseMainViewHeight.constant = self.courseMainViewHeight.constant - 25;
    }
    
    self.coursePrice.text = [NSString stringWithFormat:@"%.2lf元",self.domain.fees];
    
    self.countPrice.text = [NSString stringWithFormat:@"%.2lf元",self.domain.discountfees];
    
    self.courseTime.text = self.domain.schedule;
    
    if (self.domain.content == nil)
    {
        self.domain.content = @"暂无信息";
    }
    
    self.courseDetailLbl.text = self.domain.content;
    
    float textSize = [KGNSStringUtil heightForString:self.courseDetailLbl.text andWidth:APPWINDOWWIDTH - 20];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        self.courseDetailViewHeightConstraint.constant = [NSNumber numberWithFloat:textSize].floatValue + Number_Sixty;
    });
}

- (void)setUpStarts:(NSInteger)intCount halfCount:(NSInteger)halfCount
{
    for (NSInteger i = 0; i<intCount; i++)
    {
        if(i == intCount)
        {
            if (halfCount >= 5)
            {
                UIButton *starBtn = self.starView.subviews[i];
                starBtn.imageView.image = [UIImage imageNamed:@"bankexing"];
                break;
            }
            
            else
            {
                break;
            }
        }
        UIButton *starBtn = self.starView.subviews[i];
        starBtn.imageView.image = [UIImage imageNamed:@"xing"];
    }
}

#pragma mark - 创建图片轮播器
- (void)setUpAdScroll
{
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:self.adScrollView.frame imageURLStringsGroup:self.adPictures];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.delegate = self;
    cycleScrollView2.dotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.placeholderImage = [UIImage imageNamed:@"placeholder"];
    [self.adScrollView bringSubviewToFront:cycleScrollView2];
    [self.adScrollView addSubview:cycleScrollView2];
}

- (IBAction)moreCommitBtnClick:(id)sender
{
    NSLog(@"dawdwa");
    
    SPMoreCommentVC *vc = [[SPMoreCommentVC alloc] init];
    
    vc.ext_uuid = self.domain.uuid;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 从加载广告内容
- (void)loadAdPicts
{
    self.adPictures = @[
                        @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                        @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                        @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                        ];
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return ![view isKindOfClass:[UIButton class]];
}

@end
