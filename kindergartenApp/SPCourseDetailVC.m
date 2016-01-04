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
#import "BrowseURLViewController.h"
#import "KGNSStringUtil.h"

#import "HLActionSheet.h"
#import "UMSocial.h"

@interface SPCourseDetailVC () <UIActionSheetDelegate,SpCourseDetailTableVCDelegate,UIScrollViewDelegate,UMSocialUIDelegate>
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
    
    self.title = @"课程详情";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //创建底部view
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.frame = CGRectMake(0, APPWINDOWHEIGHT - 48 - 64, APPWINDOWWIDTH, 48);
    [self addBtn:_bottomView];
    
    //获取数据
    [self getShareData];
    
    //创建上面三个按钮view
    _buttonsView = [[UIView alloc] init];
    _buttonsView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, 40);
    [self addSelBtns:_buttonsView];
    
    //创建按钮下面红线
    [self createBtnRedView];
    
    //创建课程详情view
    SPCourseDetailWebView * courseDetailView = [[[NSBundle mainBundle] loadNibNamed:@"SPCourseDetailWebView" owner:nil options:nil] firstObject];
    _courseDetailView = courseDetailView;
    courseDetailView.frame = CGRectMake(0, 40 + 0 + 2, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 40 - 48 - 2);
    
    //创建学校简介view
    SPCourseDetailScrollInfoWebView * schoolInfoView = [[[NSBundle mainBundle] loadNibNamed:@"SPCourseDetailScrollInfoWebView" owner:nil options:nil] firstObject];
    _schoolInfoView = schoolInfoView;
    schoolInfoView.frame = CGRectMake(0, 40 + 0 + 2, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 40 - 48 - 2);
    schoolInfoView.hidden = YES;
    
    //创建家长评论view
    //tableview显示完
    SpCourseDetailTableVC * tableVC = [[SpCourseDetailTableVC alloc] init];
    _tableVC = tableVC;
    tableVC.tableFrame = CGRectMake(0, 40 + 0 + 2, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 40 - 48 - 2);
    tableVC.tableView.hidden = YES;
    
    //请求课程详情
    [self getDetailData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToWebVC:) name:@"erweima_web" object:nil];
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

#pragma mark - 上面按钮点击
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
    [[KGHttpService sharedService] getSPCourseDetail:self.uuid success:^(SPCourseDetailVO *vo)
    {
        [self hidenLoadView];
        
        self.courseDetailDomain = [SPCourseDetailDomain objectWithKeyValues:vo.data];
    
        //设置数据
        [_courseDetailView setData:vo];
        
        self.groupuuid = self.courseDetailDomain.groupuuid;
        
        [self.view addSubview:_courseDetailView];
        [self.view addSubview:_bottomView];
        [self.view bringSubviewToFront:_bottomView];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

#pragma mark - 请求学校介绍url
- (void)getSchoolData
{
    if (self.reqFlag)
    {
        [self showLoadView];
        
        [[KGHttpService sharedService] getSPSchoolInfoShareUrl:self.courseDetailDomain.groupuuid success:^(NSString *url)
         {
             [self hidenLoadView];
             
             self.url = url;
             //设置数据
             [_schoolInfoView setData:url];
             
             self.reqFlag = NO;
             
             [self.view addSubview:_schoolInfoView];
        }
        faild:^(NSString *errorMsg)
        {
            [self showNoNetView];
        }];
    }
}

#pragma mark - 请求评论列表
- (void)getCommentsData
{
    if (self.reqFlagOFComment == YES)
    {
        [self showLoadView];
        
        [[KGHttpService sharedService] getSPCourseComment:self.uuid pageNo:@"1" success:^(SPCommentVO *commentVO)
        {
            [self hidenLoadView];
            self.reqFlagOFComment = NO;
            
            _tableVC.uuid = self.uuid;
            
            _tableVC.presentsComments = [NSMutableArray arrayWithArray:[SPCommentDomain objectArrayWithKeyValuesArray:commentVO.data]];
            
            //计算行高
            NSMutableArray * rowHeights = [NSMutableArray array];
            
            if (_tableVC.presentsComments.count != 0)
            {
                for (SPCommentDomain * domain in _tableVC.presentsComments)
                {
                    NSString * text = domain.content;
                    
                    CGFloat textHeight = [KGNSStringUtil heightForString:text andWidth:KGSCREEN.size.width - 20];
                    
                    CGFloat height = 139 + ABS(67 - textHeight);
                    
                    [rowHeights addObject:@(height)];
                }
                
                _tableVC.rowHeights = rowHeights;
            }
            
            [self.view addSubview:_tableVC.tableView];
        }
        faild:^(NSString *errorMsg)
        {
            [self showNoNetView];
        }];
    }
}

#pragma mark - 没有网络连接重试代理
- (void)tryBtnClicked
{
    [self hidenNoNetView];
    
    //请求课程详情
    [self getDetailData];
    _schoolInfoView.hidden = YES;
    _tableVC.tableView.hidden = YES;
    _courseDetailView.hidden = NO;
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
    
    [[KGHttpService sharedService] delFavorites:self.uuid success:^(NSString *msgStr)
    {
        button.selected = !button.selected;
        button.enabled = YES;
        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
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
    AnnouncementDomain * domain = [[AnnouncementDomain alloc] init];
    
    domain.share_url = self.share_url;
    domain.title = self.courseDetailDomain.title;
    
    if (domain.title == nil)
    {
        domain.title = @"";
    }
    
    NSArray *titles = @[@"微博",@"微信",@"朋友圈",@"QQ好友",@"复制链接"];
    NSArray *imageNames = @[@"xinlang",@"weixin",@"pyquan",@"QQ",@"fuzhilianjie"];
    HLActionSheet *sheet = [[HLActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    
    [sheet showActionSheetWithClickBlock:^(NSInteger btnIndex)
     {
         switch (btnIndex)
         {
             case 0:
             {
                 [self handelShareWithShareType:UMShareToSina domain:domain];
             }
                 break;
                 
             case 1:
             {
                 [self handelShareWithShareType:UMShareToWechatSession domain:domain];
             }
                 break;
                 
             case 2:
             {
                 [self handelShareWithShareType:UMShareToWechatTimeline domain:domain];
             }
                 break;
                 
             case 3:
             {
                 [self handelShareWithShareType:UMShareToQQ domain:domain];
             }
                 break;
                 
             case 4:
             {
                 UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
                 pasteboard.string = domain.share_url;
                 //提示复制成功
                 UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已复制分享链接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 [av show];
             }
                 break;
                 
             default:
                 break;
         }
     }
     cancelBlock:^
     {
         NSLog(@"取消");
     }];
}

#pragma mark - 处理分享操作
- (void)handelShareWithShareType:(NSString *)shareType domain:(AnnouncementDomain *)domain
{
    NSString * contentString = domain.title;
    
    NSString * shareurl = domain.share_url;
    
    if(!shareurl || [shareurl length] == 0)
    {
        shareurl = @"http://wenjie.net";
    }
    
    //微信title设置方法：
    [UMSocialData defaultData].extConfig.wechatSessionData.title = domain.title;
    
    //朋友圈title设置方法：
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = domain.title;
    [UMSocialWechatHandler setWXAppId:@"wx6699cf8b21e12618" appSecret:@"639c78a45d012434370f4c1afc57acd1" url:domain.share_url];
    [UMSocialData defaultData].extConfig.qqData.title = domain.title;
    [UMSocialData defaultData].extConfig.qqData.url = domain.share_url;
    
    if (shareType == UMShareToSina)
    {
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",contentString,shareurl];
        [UMSocialData defaultData].extConfig.sinaData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:shareurl];
    }
    
    //设置分享内容，和回调对象
    [[UMSocialControllerService defaultControllerService] setShareText:contentString shareImage:[UIImage imageNamed:@"jiazhang_180"] socialUIDelegate:self];
    
    UMSocialSnsPlatform * snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareType];
    
    snsPlatform.snsClickHandler(self, [UMSocialControllerService defaultControllerService],YES);
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    UIAlertView * alertView;
    NSString * string;
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        string = @"分享成功";
    }
    else if (response.responseCode == UMSResponseCodeCancel)
    {
    }
    else
    {
        string = @"分享失败";
    }
    if (string && string.length)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}


#pragma mark - 获取分享收藏信息
- (void)getShareData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getSPCourseExtraFun:self.uuid success:^(SPShareSaveDomain *shareSaveDomain)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        isFavor = shareSaveDomain.isFavor;
        self.share_url = shareSaveDomain.share_url;
        self.tels = shareSaveDomain.link_tel;
        if(!isFavor)
        {
            ((SPBottomItem *)_buttonItems[0]).btn.selected = YES;
            ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang2"];
        }
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

- (void)pushToWebVC:(NSNotification *)noti
{
    BrowseURLViewController * vc = [[BrowseURLViewController alloc] init];
    
    vc.title = @"二维码详情";
    
    vc.url = noti.object;
    
    [self.navigationController pushViewController:vc animated:YES];
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
