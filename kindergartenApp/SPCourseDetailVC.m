//
//  SPCourseDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPCourseDetailVC.h"
#import "KGHUD.h"
#import "KGHttpService.h"
#import "SPCourseDetailDomain.h"
#import "SPSchoolDomain.h"
#import "ACMacros.h"
#import "SPBottomItem.h"
#import "KGDateUtil.h"
#import "PopupView.h"
#import "ShareViewController.h"
#import "InteractViewController.h"
#import "KGUser.h"
#import "SPCourseDetailWebView.h"
#import "SPCourseDetailVO.h"
#import "SPCourseDetailScrollInfoWebView.h"
#import "MJExtension.h"

@interface SPCourseDetailVC () <UIActionSheetDelegate,SpCourseDetailTableVCDelegate,UIScrollViewDelegate>
{
    PopupView * popupView;
    ShareViewController * shareVC;
    BOOL isFavor;

    SPCourseDetailWebView * _courseDetailView;
    
    SPCourseDetailScrollInfoWebView * _schoolInfoView;
    
    SpCourseDetailTableVC * _tableVC;
    
    UIView * _buttonsView;
    
    NSMutableArray * _redViews;
    NSMutableArray * _btns;
}

@property (strong, nonatomic) NSString * groupuuid;

@property (strong, nonatomic) SPCourseDetailDomain * courseDetailDomain;

@property (strong, nonatomic) NSString * url;

@property (strong, nonatomic) NSMutableArray * buttonItems;

@property (strong, nonatomic) NSString * share_url;

@property (strong, nonatomic) NSString * tels;

@property (strong, nonatomic) NSArray * telsNum;

@property (strong, nonatomic) NSString * obj_url;

@property (strong, nonatomic) NSString * age_min_max;

@property (assign, nonatomic) BOOL reqFlag;
@property (assign, nonatomic) BOOL reqFlagOFComment;

@end

@implementation SPCourseDetailVC

- (NSArray *)telsNum
{
    if (_telsNum == nil)
    {
        _telsNum = [NSArray array];
    }
    return _telsNum;
}

- (NSMutableArray *)buttonItems
{
    if (_buttonItems == nil)
    {
        _buttonItems = [NSMutableArray array];
    }
    return _buttonItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reqFlag = YES;
    self.reqFlagOFComment = YES;
    
    self.title = @"";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //创建底部view
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.frame = CGRectMake(0, APPWINDOWHEIGHT - 48, APPWINDOWWIDTH, 48);
    [self addBtn:_bottomView];
    
    //获取数据
    [self getShareData];
    
    //创建上面三个按钮view
    _buttonsView = [[UIView alloc] init];
    _buttonsView.frame = CGRectMake(0, 64, APPWINDOWWIDTH, 40);
    [self addSelBtns:_buttonsView];
    
    //创建按钮下面红线
    [self createBtnRedView];
    
    
    
    
    //创建课程详情view
    SPCourseDetailWebView * courseDetailView = [[[NSBundle mainBundle] loadNibNamed:@"SPCourseDetailWebView" owner:nil options:nil] firstObject];
    _courseDetailView = courseDetailView;
    courseDetailView.frame = CGRectMake(0, 40 + 64 + 2, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 40 - 48 - 2);
    
    
    
    
    //创建学校简介view
    SPCourseDetailScrollInfoWebView * schoolInfoView = [[[NSBundle mainBundle] loadNibNamed:@"SPCourseDetailScrollInfoWebView" owner:nil options:nil] firstObject];
    _schoolInfoView = schoolInfoView;
    schoolInfoView.frame = CGRectMake(0, 40 + 64 + 2, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 40 - 48 - 2);
    schoolInfoView.hidden = YES;
    
    
    
    
    //创建家长评论view
    //tableview显示完
    SpCourseDetailTableVC * tableVC = [[SpCourseDetailTableVC alloc] init];
    _tableVC = tableVC;
    tableVC.tableFrame = CGRectMake(0, 40 + 64 + 2, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 40 - 48 - 2);
    tableVC.tableView.hidden = YES;
    
    //请求课程详情
    [self getDetailData];
}


#pragma mark - 创建上面3个选择按钮
- (void)addSelBtns:(UIView *)view
{
    NSArray * titlts = @[@"课程详情",@"学校简介",@"家长评价"];
    _btns = [NSMutableArray array];
    
    for (NSInteger i=0; i<3; i++)
    {
        MyButtonThree * btn = [[MyButtonThree alloc] initWithFrame:CGRectMake(i * (APPWINDOWWIDTH / 3), 0, (APPWINDOWWIDTH / 3), 40)];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [btn setTitle:titlts[i] forState:UIControlStateNormal];
        [btn setTitle:titlts[i] forState:UIControlStateSelected];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(selBtn:) forControlEvents:UIControlEventTouchDown];
        
        //创建btn之间的分割线
        if (i!=2)
        {
            UIView * sepView = [[UIView alloc] init];
            sepView.frame = CGRectMake(btn.frame.size.width - 1, 10, 1, 20);
            sepView.backgroundColor = [UIColor lightGrayColor];
            [btn addSubview:sepView];
        }
        [_btns addObject:btn];
        
        [_buttonsView addSubview:btn];
    }
    
    ((UIButton *)_btns[0]).selected = YES;

    [self.view addSubview:_buttonsView];
}

#pragma mark - 创建按钮下面红色view
- (void)createBtnRedView
{
    _redViews = [NSMutableArray array];
    
    for (NSInteger i=0;i<_btns.count;i++)
    {
        //创建btn底部的红线
        UIView * redView = [[UIView alloc] init];
        redView.frame = CGRectMake(i * (APPWINDOWWIDTH / 3), 64+41, (APPWINDOWWIDTH / 3), 1);
        redView.backgroundColor = [UIColor redColor];
        
        redView.hidden = YES;
        
        [_redViews addObject:redView];
        
        [self.view addSubview:redView];
    }
    
    ((UIView *)_redViews[0]).hidden = NO;
}

#pragma mark - 选择按钮显示效果
- (void)selBtn:(UIButton *)btn
{
    if (btn.tag == 0)
    {
        _schoolInfoView.hidden = YES;
        _tableVC.tableView.hidden = YES;
        _courseDetailView.hidden = NO;
    }
    else if (btn.tag == 1)
    {
        [self getSchoolData];
        _courseDetailView.hidden = YES;
        _tableVC.tableView.hidden = YES;
        _schoolInfoView.hidden = NO;
    }
    else if (btn.tag == 2)
    {
        [self getCommentsData];
        _tableVC.tableView.hidden = NO;
        _courseDetailView.hidden = YES;
        _schoolInfoView.hidden = YES;
    }
    
    btn.selected = YES;
    
    for (NSInteger i=0; i<_btns.count; i++)
    {
        if (btn.tag == i)
        {
            ((UIButton *)_btns[i]).selected = YES;
            ((UIView *)_redViews[i]).hidden = NO;
        }
        else
        {
            ((UIButton *)_btns[i]).selected = NO;
            ((UIView *)_redViews[i]).hidden = YES;
        }
    }
}

#pragma mark - 请求课程详情
- (void)getDetailData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseDetail:self.uuid success:^(SPCourseDetailVO *vo)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        self.courseDetailDomain = [SPCourseDetailDomain objectWithKeyValues:vo.data];
    
        //设置数据
        [_courseDetailView setData:vo];
        [self.view addSubview:_courseDetailView];
        
        self.groupuuid = self.courseDetailDomain.groupuuid;

        [self responseHandler];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 请求学校介绍url
- (void)getSchoolData
{
    if (self.reqFlag)
    {
        [[KGHUD sharedHud] show:self.view];
        
        [[KGHttpService sharedService] getSPSchoolInfoShareUrl:self.courseDetailDomain.groupuuid success:^(NSString *url)
         {
             [[KGHUD sharedHud] hide:self.view];
             
             self.url = url;
             //设置数据
             [_schoolInfoView setData:url];
             [self.view addSubview:_schoolInfoView];
             
             self.reqFlag = NO;
             
             [self responseHandlerOfSchool];
        }
        faild:^(NSString *errorMsg)
        {
             [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
        }];
    }
}

#pragma mark - 请求评论列表
- (void)getCommentsData
{
    if (self.reqFlagOFComment == YES)
    {
        [[KGHUD sharedHud] show:self.view];
        
        [[KGHttpService sharedService] getSPCourseComment:self.uuid pageNo:@"1" success:^(SPCommentVO *commentVO)
        {
            [[KGHUD sharedHud] hide:self.view];
            self.reqFlagOFComment = NO;
            
            _tableVC.uuid = self.uuid;
            
            _tableVC.presentsComments = [NSMutableArray arrayWithArray:[SPCommentDomain objectArrayWithKeyValuesArray:commentVO.data]];
            
            [self.view addSubview:_tableVC.tableView];
        }
        faild:^(NSString *errorMsg)
        {
            [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
        }];
    }
    
}

//请求之后的处理 需要判断是否还需要再次请求
- (void)responseHandlerOfSchool
{
    if (self.url == nil)
    {
        [self getSchoolData];
    }
    else
    {
        
    }
}

- (void)responseHandler
{
    if(self.courseDetailDomain == nil)
    {
        [self getDetailData];
    }
    else
    {
        
    }
}

#pragma mark - 添加底部按钮
- (void)addBtn:(UIView *)view
{
    _buttonItems = [NSMutableArray array];
    
    int totalloc = 4;
    CGFloat spcoursew = 80;
    CGFloat spcourseh = 48;
    CGFloat margin = (App_Frame_Width - totalloc * spcoursew) / (totalloc + 1);
    
    
    NSArray * imageName = @[@"shoucang1",@"fenxiang",@"hudongbtn",@"zixunbtn"];
    NSArray * titleName = @[@"收藏",@"分享",@"互动",@"咨询"];
    
    for (NSInteger i = 0; i < 4; i++)
    {
        NSInteger row = (NSInteger)(i / totalloc);  //行号
        NSInteger loc = i % totalloc;               //列号
        
        SPBottomItem * item = [[[NSBundle mainBundle] loadNibNamed:@"SPBottomItem" owner:nil options:nil] firstObject];
        
        [item setPic:imageName[i] Title:titleName[i]];
        
        if (i == 3)
        {
            item.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zixunbeijing"]];
        }
        
        item.btn.tag = i;
        
        [item.btn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat itemX = margin + (margin + spcoursew) * loc;
        CGFloat itemY =  (margin + spcourseh) * row;
        CGFloat itemH = item.frame.size.height;
        CGFloat itemW = item.frame.size.width;
        
        item.frame = CGRectMake(itemX, itemY, itemW, itemH);
        
        [_buttonItems addObject:item];
        
        [_bottomView addSubview:item];
    }
    
    [self.view addSubview:_bottomView];
    
    [self.view bringSubviewToFront:_bottomView];

}

#pragma mark - 下面按钮点击
- (void)bottomBtnClicked:(UIButton *)btn
{
    
    switch (btn.tag)
    {
        case 0:            //收藏
        {
            if (btn.selected == YES)
            {
                [self delFavorites:btn];
            }
            else
            {
                [self saveFavorites:btn];
            }
            break;
        }

        case 1:            //分享
        {
            [self shareClicked];
            break;
        }
        case 2:            //互动
        {
            InteractViewController * baseVC = [[InteractViewController alloc] init];
            baseVC.courseuuid = self.uuid;
            baseVC.dataScourseType = 1;
            
            if(baseVC)
            {
                [self.navigationController pushViewController:baseVC animated:YES];
            }
            
            break;
        }
        case 3:            //电话
        {
            self.tels = [self.tels stringByReplacingOccurrencesOfString:@"/" withString:@","];
            
            self.telsNum = [self.tels componentsSeparatedByString:@","];
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"为您查询到如下联系号码" delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            
            for (NSString * str in self.telsNum)
            {
                [sheet addButtonWithTitle:str];
            }
            
            [sheet showInView:self.view];
            
            break;
        }
    }
    
}

#pragma mark - actionsheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    
    NSString *callString = [NSString stringWithFormat:@"tel://%@",self.telsNum[buttonIndex-1]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSString * uuid = self.uuid;
        
        //调用接口保存用户信息
        [[KGHttpService sharedService] saveTelUserDatas:uuid type:@"82" success:^(NSString *msg)
        {
            
        }
        faild:^(NSString *errorMsg)
        {
            NSLog(@"保存咨询信息失败");
        }];
        
    });
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callString]];
}

#pragma mark - 收藏相关
//保存收藏
- (void)saveFavorites:(UIButton *)button
{
    [[KGHUD sharedHud] show:self.view];
    
    FavoritesDomain * domain = [[FavoritesDomain alloc] init];
    domain.title = self.courseDetailDomain.title;
    domain.type  = Topic_PXKC;
    domain.reluuid = self.uuid;
    domain.createtime = [KGDateUtil presentTime];
    button.enabled = NO;
    
    [[KGHttpService sharedService] saveFavorites:domain success:^(NSString *msgStr)
    {
        ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"shoucang2"];
        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
        button.selected = !button.selected;
        button.enabled = YES;
    }
    faild:^(NSString *errorMsg)
    {
        button.selected = !button.selected;
        button.enabled = YES;
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

//取消收藏
- (void)delFavorites:(UIButton *)button
{
    [[KGHUD sharedHud] show:self.view];
    button.enabled = NO;
    
    [[KGHttpService sharedService] delFavorites:self.uuid success:^(NSString *msgStr)
    {
        button.selected = !button.selected;
        button.enabled = YES;
        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
        ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"shoucang1"];
    }
    failed:^(NSString *errorMsg)
    {
        button.enabled = YES;
        button.selected = !button.selected;
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 分享相关
//分享
- (void)shareClicked
{
    if(!popupView)
    {
        popupView = [[PopupView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, KGSCREEN.size.width, KGSCREEN.size.height)];
        popupView.alpha = Number_Zero;

        CGFloat height = 140;
        shareVC = [[ShareViewController alloc] init];
        shareVC.view.frame = CGRectMake(Number_Zero,  KGSCREEN.size.height - height, KGSCREEN.size.width, height);
        [popupView addSubview:shareVC.view];
        [self.view addSubview:popupView];
        [self addChildViewController:shareVC];
    }

    AnnouncementDomain * domain = [[AnnouncementDomain alloc] init];
    
    domain.share_url = self.share_url;
    domain.isFavor = isFavor;
    
    shareVC.announcementDomain = domain;

    [UIView viewAnimate:^
    {
        popupView.alpha = Number_One;
    }
    time:Number_AnimationTime_Five];
}

#pragma mark - 获取分享收藏信息
- (void)getShareData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseExtraFun:self.uuid success:^(SPShareSaveDomain *shareSaveDomain)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        isFavor = shareSaveDomain.isFavor;
        self.share_url = shareSaveDomain.share_url;
        self.tels = shareSaveDomain.link_tel;
        if(!isFavor)
        {
            ((SPBottomItem *)_buttonItems[0]).btn.selected = YES;
            ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"shoucang2"];
        }
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

@end

#pragma mark - 实现自定义Button
@implementation MyButtonThree

//图片高亮会调用这个方法
- (void)setHighlighted:(BOOL)highlighted
{
    //取消点击效果
}

@end
