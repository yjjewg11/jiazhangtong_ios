//
//  SPSchoolDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPSchoolDetailVC.h"
#import "SPBottomItem.h"
#import "ACMacros.h"
#import "SPSchoolCell.h"
#import "SPSchoolDetailTableVC.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "SPDataListVO.h"
#import "MJExtension.h"
#import "SPTeacherDomain.h"
#import "SPCourseDomain.h"
#import "SPCourseDetailVC.h"
#import "KGDateUtil.h"
#import "SpTeacherDetailViewController.h"
#import "PopupView.h"
#import "ShareViewController.h"
#import "InteractViewController.h"
#import "SPShareSaveDomain.h"
#import "MapVC.h"

@interface SPSchoolDetailVC () <UIScrollViewDelegate,SPSchoolDetailTableVCDelegate,UIActionSheetDelegate,SPSchoolCellDelegate>
{
    UIView * _schoolInfoView;
    UIView * _buttonsView;
    UIScrollView * _contentView;
    UIView * _bottomView;
    NSMutableArray * _btns;
    
    PopupView * popupView;
    ShareViewController * shareVC;
    
    SPSchoolDetailTableVC * _contentCourseTableVC;
    SPSchoolDetailTableVC * _contentTeacherTableVC;
    
    UIWebView * _webView;
    
    NSMutableArray * _buttonItems;
    
    BOOL isFavor;
}
@property (strong, nonatomic) SPSchoolCell * cell;

@property (strong, nonatomic) SPSchoolDomain * schoolDomain;

@property (strong, nonatomic) NSArray * courseList;
@property (strong, nonatomic) NSArray * teacherList;

@property (strong, nonatomic) NSString * share_url;
@property (strong, nonatomic) NSString * tels;
@property (strong, nonatomic) NSArray * telsNum;

@end

@implementation SPSchoolDetailVC

- (SPSchoolCell *)cell
{
    if (_cell == nil)
    {
        _cell = [[[NSBundle mainBundle] loadNibNamed:@"SPSchoolCell" owner:nil options:nil] firstObject];
        _cell.delegate = self;
    }
    return _cell;
}

- (SPSchoolDomain *)schoolDomain
{
    if (_schoolDomain == nil)
    {
        _schoolDomain = [[SPSchoolDomain alloc] init];
    }
    return _schoolDomain;
}

- (NSArray *)telsNum
{
    if (_telsNum == nil)
    {
        _telsNum = [NSArray array];
    }
    return _telsNum;
}

- (NSArray *)courseList
{
    if (_courseList == nil)
    {
        _courseList = [NSArray array];
    }
    return _courseList;
}

- (NSArray *)teacherList
{
    if (_teacherList == nil)
    {
        _teacherList = [NSArray array];
    }
    return _teacherList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"学校详情";
    
    //读取坐标
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    _mappoint = [defu objectForKey:@"map_point"];
    
    //创建底部bar
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.frame = CGRectMake(0, APPWINDOWHEIGHT - 48, APPWINDOWWIDTH, 48);
    [self addBtn:_bottomView];
    
    //创建顶部学校信息view
    _schoolInfoView = [[UIView alloc] init];
    _schoolInfoView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, 150);
    [self addInfoCell:_schoolInfoView];
    
    //创建上面三个按钮view
    _buttonsView = [[UIView alloc] init];
    _buttonsView.frame = CGRectMake(0, 0 + 120, APPWINDOWWIDTH, 30);
    [self addSelBtns:_buttonsView];
    
    //创建scrollView
    _contentView = [[UIScrollView alloc] init];
    _contentView.frame = CGRectMake(0, CGRectGetMaxY(_buttonsView.frame) + 1, APPWINDOWWIDTH, APPWINDOWHEIGHT - CGRectGetMaxY(_buttonsView.frame) - 48);
    [self addContent:_contentView];

    //获取数据
    [self getSchoolData];
    
    [self getShareData];
    
    [self getCourseData];
    
    [self getTeacherData];
}

#pragma mark - 添加底部按钮
- (void)addBtn:(UIView *)view
{
    _buttonItems = [NSMutableArray array];
    
    int totalloc = 4;
    CGFloat spcoursew = 80;
    CGFloat spcourseh = 48;
    CGFloat margin = (App_Frame_Width - totalloc * spcoursew) / (totalloc + 1);

    NSArray * imageName = @[@"newshoucang1",@"newfenxiang-1",@"newhudong",@"newzixun"];
    NSArray * titleName = @[@"收藏",@"分享",@"互动",@"咨询"];
    
    for (NSInteger i = 0; i < 4; i++)
    {
        NSInteger row = (NSInteger)(i / totalloc);  //行号
        NSInteger loc = i % totalloc;               //列号
        
        SPBottomItem * item = [[[NSBundle mainBundle] loadNibNamed:@"SPBottomItem" owner:nil options:nil] firstObject];
        
        [item setPic:imageName[i] Title:titleName[i]];
        
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

- (void)bottomBtnClicked:(UIButton *)btn
{
    switch (btn.tag) {
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
        case 2: //互动
        {
            InteractViewController * baseVC = [[InteractViewController alloc] init];
            baseVC.groupuuid = self.groupuuid;
            baseVC.dataScourseType = 1;
            
            if(baseVC)
            {
                [self.navigationController pushViewController:baseVC animated:YES];
            }
            
            break;
        }
            
        case 3:           //电话
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
       NSString * uuid = self.groupuuid;
       
       //调用接口保存用户信息
       [[KGHttpService sharedService] saveTelUserDatas:uuid type:@"81" success:^(NSString *msg)
        {
            
        }
        faild:^(NSString *errorMsg)
        {
            NSLog(@"保存咨询信息失败");
        }];
       
    });
    
    NSString *callString = [NSString stringWithFormat:@"tel://%@",self.telsNum[buttonIndex-1]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callString]];
}

#pragma mark - 收藏相关
//保存收藏
- (void)saveFavorites:(UIButton *)button
{
    [[KGHUD sharedHud] show:self.view];
    
    FavoritesDomain * domain = [[FavoritesDomain alloc] init];
    domain.title = self.schoolDomain.brand_name;
    domain.type  = 81;
    domain.reluuid = self.schoolDomain.uuid;
    domain.createtime = [KGDateUtil presentTime];
    button.enabled = NO;
    
    [[KGHttpService sharedService] saveFavorites:domain success:^(NSString *msgStr)
    {
        ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang2"];
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
    
    [[KGHttpService sharedService] delFavorites:self.groupuuid success:^(NSString *msgStr)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        button.selected = !button.selected;
        button.enabled = YES;
        ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang1"];
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
        shareVC.view.frame = CGRectMake(Number_Zero,  KGSCREEN.size.height-height, KGSCREEN.size.width, height);
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


#pragma mark - 创建顶部schoolinfo
- (void)addInfoCell:(UIView *)view
{
    CGFloat padding = (APPWINDOWWIDTH - 320) / 2;
    
    [self.cell setOrigin:CGPointMake(padding, 0)];
    
    //设置数据
    [self.view addSubview:_schoolInfoView];
}

#pragma mark - 创建上面3个选择按钮
- (void)addSelBtns:(UIView *)view
{
    NSArray * titlts = @[@"课程",@"师资",@"简介"];
    _btns = [NSMutableArray array];
    
    for (NSInteger i=0; i<3; i++)
    {
        MyButton * btn = [[MyButton alloc] initWithFrame:CGRectMake(i * (APPWINDOWWIDTH / 3), 0, (APPWINDOWWIDTH / 3), 30)];
        
        [btn setTitle:titlts[i] forState:UIControlStateNormal];
        [btn setTitle:titlts[i] forState:UIControlStateSelected];
        
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        [btn setBackgroundImage:[UIImage imageNamed:@"btnbeijing"] forState:UIControlStateSelected];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(selBtn:) forControlEvents:UIControlEventTouchDown];
        
        [_btns addObject:btn];
        
        [_buttonsView addSubview:btn];
    }
    
    ((UIButton *)_btns[0]).selected = YES;
    
    [self.view addSubview:_buttonsView];
}

- (void)selBtn:(UIButton *)btn
{
    btn.selected = YES;
    
    for (NSInteger i=0; i<_btns.count; i++)
    {
        if (btn.tag == i)
        {
            ((UIButton *)_btns[i]).selected = YES;
        }
        else
        {
            ((UIButton *)_btns[i]).selected = NO;
        }
    }
    
    [_contentView setContentOffset:CGPointMake(btn.tag * APPWINDOWWIDTH, 0) animated:NO];
    
}

#pragma mark - 创建scroll中子控件
- (void)addContent:(UIScrollView *)scrollView
{
    _contentView.contentSize = CGSizeMake(APPWINDOWWIDTH * 3 , 0);
    
    _contentView.delegate = self;
    
    _contentView.pagingEnabled = YES;
    
    _contentView.showsHorizontalScrollIndicator = NO;
    
    //第一个
    _contentCourseTableVC = [[SPSchoolDetailTableVC alloc] init];
    
    _contentCourseTableVC.tableRect = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - CGRectGetMaxY(_buttonsView.frame) - 48);
    
    _contentCourseTableVC.groupuuid = self.groupuuid;
    
    _contentCourseTableVC.mappoint = self.mappoint;
    
    _contentCourseTableVC.dataSourceType = 0; //课程类型
    
    _contentCourseTableVC.delegate = self;
    
    //第二个
    _contentTeacherTableVC = [[SPSchoolDetailTableVC alloc] init];
    
    _contentTeacherTableVC.groupuuid = self.groupuuid;
    
    _contentTeacherTableVC.dataSourceType = 1; //教师类型
    
    _contentTeacherTableVC.delegate = self;
    
    _contentTeacherTableVC.tableRect = CGRectMake(APPWINDOWWIDTH, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - CGRectGetMaxY(_buttonsView.frame) - 48);
    
    //第三个
    _webView = [[UIWebView alloc] init];
    
    _webView.frame = CGRectMake(APPWINDOWWIDTH * 2, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - CGRectGetMaxY(_buttonsView.frame) - 48);
    
    //添加
    [_contentView addSubview:_contentCourseTableVC.tableView];
    [_contentView addSubview:_contentTeacherTableVC.tableView];
    [_contentView addSubview:_webView];
    
    
    [self.view addSubview:_contentView];
}

#pragma mark - 获取分享收藏信息
- (void)getShareData
{
    [[KGHttpService sharedService] getSPSchoolExtraFun:self.groupuuid success:^(SPShareSaveDomain *shareSaveDomain)
    {
        isFavor = shareSaveDomain.isFavor;
        self.share_url = shareSaveDomain.share_url;
        NSDictionary * dict = shareSaveDomain.data;
        self.tels = [dict objectForKey:@"link_tel"];
        if(!isFavor)
        {
            ((SPBottomItem *)_buttonItems[0]).btn.selected = YES;
            ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang2"];
        }
    }
    faild:^(NSString *errorMsg)
    {
        
    }];
}


#pragma mark - 请求课程列表数据
- (void)getCourseData
{
    [[KGHUD sharedHud] show:self.view];
    
    if (self.mappoint == nil)
    {
        self.mappoint = @"";
    }
    
    [[KGHttpService sharedService] getSPCourseList:self.groupuuid map_point:self.mappoint type:@"" sort:@"" teacheruuid:@"" pageNo:@"" success:^(SPDataListVO *spCourseList)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        NSMutableArray * marr = [NSMutableArray array];
        
        for (NSDictionary *dict in spCourseList.data)
        {
            SPCourseDomain * domain = [SPCourseDomain objectWithKeyValues:dict];
            
            [marr addObject:domain];
        }
        
        _contentCourseTableVC.courseList = marr;
        self.courseList = marr;
    
        //数据请求完毕
        [_contentCourseTableVC.tableView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 请求教师列表数据
- (void)getTeacherData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPTeacherList:self.groupuuid pageNo:@"" success:^(SPDataListVO *dataListVo)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        NSMutableArray * marr = [NSMutableArray array];
        
        for (NSDictionary *dict in dataListVo.data)
        {
            SPTeacherDomain * domain = [SPTeacherDomain objectWithKeyValues:dict];
            
            [marr addObject:domain];
        }
        
        _contentTeacherTableVC.teacherList = marr;
        self.teacherList = marr;
        
        //数据请求完毕
        [_contentTeacherTableVC.tableView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 请求学校详情
- (void)getSchoolData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseDetailSchoolInfo:self.groupuuid success:^(SPSchoolDomain *spSchoolDetail)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        self.schoolDomain = spSchoolDetail;
        
        [self.cell setData:self.schoolDomain];
        
        [_schoolInfoView addSubview:self.cell];

        [_webView loadHTMLString:spSchoolDetail.groupDescription baseURL:nil];
        
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}


#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x / APPWINDOWWIDTH);
    
    for (NSInteger i = 0 ; i<_btns.count; i++)
    {
        if (i == index)
        {
            ((MyButton *)_btns[i]).selected = YES;
        }
        else
        {
            ((MyButton *)_btns[i]).selected = NO;
        }
        
    }
}

#pragma mark - 导航跳转代理
- (void)pushToDetailVC:(SPSchoolDetailTableVC *)schoolDetailVC dataSourceType:(DataSourseType)type selIndexPath:(NSIndexPath *)indexPath
{
    if (type == 0)  //跳转到课程详情
    {
        SpCourseDetailVC * detailVC = [[SpCourseDetailVC alloc] init];
        
        SPCourseDomain * domain = self.courseList[indexPath.row];
        
        detailVC.uuid = domain.uuid;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (type == 1)  //跳转到教师详情
    {
        SpTeacherDetailViewController * detailVC = [[SpTeacherDetailViewController alloc] init];
        
        SPTeacherDomain * domain = self.teacherList[indexPath.row];
        
        detailVC.teacheruuid = domain.uuid;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)pushToMapVC:(SPSchoolDomain *)domain
{
    MapVC * vc = [[MapVC alloc] init];
    
    vc.map_point = domain.map_point;
    
    vc.locationName = domain.address;
    
    vc.schoolName = domain.brand_name;
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end


#pragma mark - 实现自定义Button
@implementation MyButton

//图片高亮会调用这个方法
- (void)setHighlighted:(BOOL)highlighted
{
    //取消点击效果
}

@end


