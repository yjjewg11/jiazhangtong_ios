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

@interface SPCourseDetailVC () <UIWebViewDelegate,UIActionSheetDelegate>
{
    PopupView * popupView;
    ShareViewController * shareVC;
    BOOL isFavor;
}

@property (strong, nonatomic) NSString * groupuuid;

@property (strong, nonatomic) SPCourseDetailDomain * courseDetailDomain;

@property (strong, nonatomic) UIWebView * webview;

@property (strong, nonatomic) SpCourseDetailTableVC *tableVC;

@property (strong, nonatomic) UIView * bottomView;

@property (strong, nonatomic) NSMutableArray * buttonItems;

@property (strong, nonatomic) NSString * share_url;

@property (strong, nonatomic) NSString * tels;

@property (strong, nonatomic) NSArray * telsNum;

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

- (SpCourseDetailTableVC *)tableVC
{
    if (_tableVC == nil)
    {
        _tableVC = [[SpCourseDetailTableVC alloc] init];
        _tableVC.tableView.frame = CGRectMake(0, 64, APPWINDOWWIDTH, APPWINDOWHEIGHT-64-48);
    }
    return _tableVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"课程详情";

    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.frame = CGRectMake(0, APPWINDOWHEIGHT - 48, APPWINDOWWIDTH, 48);
    
    [self addBtn:_bottomView];
    
    [self getShareData];
    
    [self getDetailData];
//    [self setupScrollView];
//    [self setupCourseInfoView];
    self.tableVC.tableView.hidden = YES;
    [self.view addSubview:self.tableVC.tableView];
}

#pragma mark - 请求课程详情
- (void)getDetailData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseDetail:self.uuid success:^(SPCourseDetailDomain *spCourseDetail)
    {
        self.courseDetailDomain = spCourseDetail;
        
        self.tableVC.courseDetailDomain = spCourseDetail;
        
        [self getContextHeight:self.courseDetailDomain.context type:@"course"];
        
        self.groupuuid = self.courseDetailDomain.groupuuid;
        
        [self.tableVC.tableView reloadData];

        [self responseHandler];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

//#pragma mark - 请求评论列表
//- (void)getCommentsData
//{
//    [[KGHUD sharedHud] show:self.tableVC.tableView];
//    
//    [[KGHttpService sharedService] getSPCourseComment:self.uuid pageNo:@"" success:^(SPCommentVO *commentVO)
//    {
//        [[KGHUD sharedHud] hide:self.tableVC.tableView];
//        
//        self.tableVC.presentsComments = commentVO.data;
//        
////        [self responseHandler];
//    }
//    faild:^(NSString *errorMsg)
//    {
//        [[KGHUD sharedHud] show:self.tableVC.tableView onlyMsg:errorMsg];
//    }];
//}

//请求之后的处理 需要判断是否还需要再次请求
- (void)responseHandler
{
    if(self.courseDetailDomain == nil)
    {
        [self getDetailData];
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
            [[KGHUD sharedHud] hide:self.view];
            self.tableVC.tableView.hidden = NO;
        });
    }
}

- (void)getContextHeight:(NSString *)context type:(NSString *)type
{
    _webview = [[UIWebView alloc] init];
    
    _webview.delegate = self;
    
    NSString * filename = [NSString stringWithFormat:@"Documents/%@-%@.html",type,self.uuid];
    
    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
        
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    [context writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:filePath]]];
    
    _webview.alpha = 0;

    [self.view addSubview:_webview];
}

- (void)webViewDidFinishLoad:(UIWebView *)wb
{
    CGRect frame = wb.frame;
    frame.size.width = APPWINDOWWIDTH;
    frame.size.height = 1;

    wb.frame = frame;
    
    frame.size.height = wb.scrollView.contentSize.height;

    wb.frame = frame;
    
    self.tableVC.courseRowHeight = wb.frame.size.height;

    [self.tableVC.tableView reloadData];

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
            BaseViewController * baseVC = [[InteractViewController alloc] init];
            if(baseVC)
            {
                [self.navigationController pushViewController:baseVC animated:YES];
            }
            
            break;
        }
        case 3:            //电话
        {
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
    [[KGHttpService sharedService] getSPCourseExtraFun:self.uuid success:^(SPShareSaveDomain *shareSaveDomain)
    {
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
        
    }];
}

@end