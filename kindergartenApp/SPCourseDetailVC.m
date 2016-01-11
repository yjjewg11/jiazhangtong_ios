//
//  SpCourseDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/4.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "SpCourseDetailVC.h"
#import "SPCourseDetailVO.h"
#import "KGHttpService.h"
#import "MJExtension.h"
#import "SPCourseDetailDomain.h"
#import "KGHUD.h"
#import "KGDateUtil.h"
#import "SPBottomItem.h"
#import "HLActionSheet.h"
#import "UMSocial.h"
#import "InteractViewController.h"
#import "KGNSStringUtil.h"
#import "SPCommentDomain.h"
#import "SpCourseDetailCourseInfo.h"
#import "SpCourseDetailInfoWeb.h"
#import "SpCourseDetailCommentVC.h"
#import "UIColor+flat.h"
#import "MapVC.h"

@interface SpCourseDetailVC () <UMSocialUIDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SpCourseDetailInfoWebDelegate,SpCourseDetailCourseInfoDelegate>
{
    
    __weak IBOutlet UIButton *kechengxiangqing;
    
    __weak IBOutlet UIButton *xuexiaojianjie;
    
    __weak IBOutlet UIButton *jiazhangpingjia;
    
    BOOL isFavor;
    
    NSString * _groupuuid;
    
    UIView * _bottomView;
    
    SPCourseDetailDomain * _courseDetailDomain;
    
    NSMutableArray * _buttonItems;
    
    NSMutableArray * _commentDatas;
    
    NSInteger reqCount;//评论请求完了才显示
    
    UITableView * _tableView;
    
    SpCourseDetailInfoWeb * _webCell;
    
    SpCourseDetailCourseInfo * _infoCell;
    
    NSString * _commentNum;
    
    BOOL _haveCoursePrice;
    BOOL _haveCourseDiscountPrice;
    
    UIScrollView * _scrollView;
    
    UIWebView * _webView;
    
    SpCourseDetailCommentVC * _commentTableVC;
}

@property (strong, nonatomic) NSString * tels;

@property (strong, nonatomic) NSArray * telsNum;

@property (strong, nonatomic) NSString * detailUrl;

@property (strong, nonatomic) NSString * infoUrl;

@end

@implementation SpCourseDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"课程详情";
    
    [kechengxiangqing setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [xuexiaojianjie setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [jiazhangpingjia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //请求课程详情数据
    [self getData];
    
    //创建scrollview
    [self initScrollView];
    
    //创建table
    [self initTableView];
    
    //创建第二栏的webview
    [self initWebView];
    
    //创建第三栏的tableview
    [self initCommentTableView];
    
    [self getCommentData];
    
    //创建底部view
    [self initBottomView];
}

- (void)tryBtnClicked
{
    [self hidenNoNetView];
    
    //请求课程详情数据
    [self getData];
}

- (void)initCommentTableView
{
    _commentTableVC = [[SpCourseDetailCommentVC alloc] init];
    
    _commentTableVC.uuid = self.uuid;
    
    _commentTableVC.tableFrame = CGRectMake(APPWINDOWWIDTH * 2, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 48 - 64 - 30);
}

- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, APPWINDOWWIDTH, APPWINDOWHEIGHT - 48 - 64 - 30)];
    
    _scrollView.scrollEnabled = NO;
    
    _scrollView.contentSize = CGSizeMake(APPWINDOWWIDTH * 3, 0);
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = NO;
}

- (void)getData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getSPCourseDetail:self.uuid success:^(SPCourseDetailVO *vo)
    {
        _courseDetailDomain = [SPCourseDetailDomain objectWithKeyValues:vo.data];
        
        self.infoUrl = vo.share_url;
        
        self.detailUrl = vo.obj_url;
        
        [self getSchoolWebUrl:_courseDetailDomain.groupuuid];
        
        if (_courseDetailDomain.fees == 0)
        {
            _haveCoursePrice = NO;
        }
        else
        {
            _haveCoursePrice = YES;
        }
        
        if (_courseDetailDomain.discountfees == 0)
        {
            _haveCourseDiscountPrice = NO;
        }
        else
        {
            _haveCourseDiscountPrice = YES;
        }
        
        isFavor = vo.isFavor;
        
        self.tels = vo.link_tel;
        
        if(!isFavor)
        {
            ((SPBottomItem *)_buttonItems[0]).btn.selected = YES;
            ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang2"];
        }
        
        [_scrollView addSubview:_tableView];
        
        [self.view addSubview:_scrollView];
        
        [self.view addSubview:_bottomView];
        
        [self.view bringSubviewToFront:_bottomView];
    }
    faild:^(NSString *errorMsg)
    {
        [self hidenLoadView];
        [self showNoNetView];
    }];
}

- (void)getSchoolWebUrl:(NSString *)uuid
{
    [[KGHttpService sharedService] getSPSchoolInfoShareUrl:uuid success:^(NSString *url)
    {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    faild:^(NSString *errorMsg)
    {
         
    }];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, APPWINDOWHEIGHT - 48 - 64 - 30) style:UITableViewStylePlain];

    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    
    _tableView.bounces = NO;
    
    [_tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)initWebView
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(APPWINDOWWIDTH, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 48 - 64 - 30)];
    
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _webView.scrollView.bounces = NO;
    
    [_scrollView addSubview:_webView];
}

- (void)getCommentData
{
    [[KGHttpService sharedService] getSPCourseComment:self.uuid pageNo:@"1" success:^(SPCommentVO *commentVO)
     {
         _commentDatas = [NSMutableArray arrayWithArray:[SPCommentDomain objectArrayWithKeyValuesArray:commentVO.data]];
         
         NSNotification * no = [[NSNotification alloc] initWithName:@"setcomment" object:@(_commentDatas.count) userInfo:nil];
         
         [[NSNotificationCenter defaultCenter] postNotification:no];
         
         _commentTableVC.dataSource = _commentDatas;
         
         [_commentTableVC calCommentCellHeight];
         
         [_scrollView addSubview:_commentTableVC.tableView];
     }
     faild:^(NSString *errorMsg)
     {
         
     }];
}

- (void)initBottomView
{
    //创建底部按钮
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.frame = CGRectMake(0, APPWINDOWHEIGHT - 48 - 64, KGSCREEN.size.width, 48);
    
    _buttonItems = [NSMutableArray array];
    
    int totalloc = 4;
    CGFloat spcoursew = 80;
    CGFloat spcourseh = 48;
    CGFloat margin = (KGSCREEN.size.width - totalloc * spcoursew) / (totalloc + 1);
    
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
    
    UIView * sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, 1)];
    sepView.backgroundColor = [UIColor lightGrayColor];
    sepView.alpha = 0.5;
    [_bottomView addSubview:sepView];
}

#pragma mark - 上面按钮点击
- (IBAction)topBtnClick:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            [kechengxiangqing setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [xuexiaojianjie setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [jiazhangpingjia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 1:
        {
            [kechengxiangqing setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [xuexiaojianjie setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [jiazhangpingjia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_scrollView setContentOffset:CGPointMake(APPWINDOWWIDTH, 0) animated:YES];
        }
            break;
        case 2:
        {
            [kechengxiangqing setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [xuexiaojianjie setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [jiazhangpingjia setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [_scrollView setContentOffset:CGPointMake(APPWINDOWWIDTH * 2, 0) animated:YES];
        }
            break;
        default:
            break;
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
    UIView * sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, 1)];
    sepView.backgroundColor = [UIColor lightGrayColor];
    sepView.alpha = 0.5;
    [_bottomView addSubview:sepView];
}

#pragma mark - 收藏相关
//保存收藏
- (void)saveFavorites:(UIButton *)button
{
    [[KGHUD sharedHud] show:self.view];
    
    FavoritesDomain * domain = [[FavoritesDomain alloc] init];
    domain.title = _courseDetailDomain.title;
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

    domain.share_url = _courseDetailDomain.share_url;
    domain.title = _courseDetailDomain.title;
    
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

#pragma mark - tableview datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        if ((_haveCourseDiscountPrice || _haveCoursePrice) == NO)
        {
            return 0.1;
        }
        else
        {
            return 44;
        }
        
    }
    else
    {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 177;
    }
    else
    {
        return APPWINDOWHEIGHT - 64 - 30 - 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString * infoID = @"infoID";
        
        SpCourseDetailCourseInfo * cell = [tableView dequeueReusableCellWithIdentifier:infoID];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseDetailCourseInfo" owner:nil options:nil] firstObject];
        }

        _infoCell = cell;
        
        cell.delegate = self;
        
        _courseDetailDomain.commentNum = _commentNum;
        
        [cell setData:_courseDetailDomain];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString * webID = @"webID";
        
        SpCourseDetailInfoWeb * cell = [tableView dequeueReusableCellWithIdentifier:webID];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SpCourseDetailInfoWeb" owner:nil options:nil] firstObject];
        }
        
        _webCell = cell;
        _webCell.delegate = self;
        
        [cell setData:self.infoUrl];
        
        return cell;
    }
    else
    {
        return [[UITableViewCell alloc] init];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        if ((_haveCourseDiscountPrice || _haveCoursePrice) == NO)
        {
            return nil;
        }
        else
        {
            UITableViewHeaderFooterView * header = [[UITableViewHeaderFooterView alloc] init];
            
            header.contentView.backgroundColor = [UIColor whiteColor];
            
            header.size = CGSizeMake(APPWINDOWWIDTH, 44);
            
            UILabel * lbl = [[UILabel alloc] init];
            
            lbl.textColor = [UIColor colorWithHexCode:@"#03d263"];
            
            lbl.text = @"￥";
            
            lbl.font = [UIFont systemFontOfSize:14];
            
            lbl.frame = CGRectMake(10, (44 - 15)/2 , 15, 15);
            
            [header addSubview:lbl];
            
            
            UILabel * money = [[UILabel alloc] init];
            
            money.textColor = [UIColor colorWithHexCode:@"#03d263"];
            
            money.text = [NSString stringWithFormat:@"%.2f",_courseDetailDomain.fees];
            
            money.frame = CGRectMake(10 + 15 + 10, (44 - 20)/2, 120, 20);
            
            money.font = [UIFont systemFontOfSize:19 weight:2];
            
            [header addSubview:money];
            
            return header;
        }
    }
    else
    {
        return nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (ABS(((scrollView.contentOffset.y - 45 + 0.2) - ((scrollView.contentSize.height - (KGSCREEN.size.height - 67 - 30))))) <= 0.5)
    {
        _tableView.scrollEnabled = NO;
        
        _webCell.webview.scrollView.scrollEnabled = YES;
        
        [_webCell.webview.scrollView setContentOffset:CGPointMake(0, 2) animated:NO];
    }
}

- (void)pullDownTopView
{
    _tableView.scrollEnabled = YES;
    
    _webCell.webview.scrollView.scrollEnabled = NO;
}

- (void)pushToMapVC
{
    MapVC * vc = [[MapVC alloc] init];
    
    vc.map_point = self.map_point;
    
    vc.locationName = self.locationName;
    
    vc.schoolName = self.schoolName;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
