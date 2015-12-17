//
//  EnrolStudentSchoolDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentSchoolDetailVC.h"
#import "MJRefresh.h"
#import "KGHttpService.h"
#import "EnrolStudentSchoolDetailDomain.h"
#import "MJExtension.h"
#import "EnrolStudentSchoolDetailLayout.h"
#import "EnrolStudentsSchoolCell.h"
#import "EnrolStudentsSchoolDomain.h"
#import "EnrolStudentButtonCell.h"
#import "EnrolStudentWebViewCell.h"
#import "EnrolStudentSchoolCommentDomain.h"
#import "KGNSStringUtil.h"
#import "EnrolStudentCommentCell.h"
#import "KGHUD.h"
#import "NoDataView.h"
#import "SPBottomItem.h"
#import "InteractViewController.h"
#import "KGDateUtil.h"
#import "PopupView.h"
#import "ShareViewController.h"

#define DataSource_ZhaoSheng 0
#define DataSource_JianJie 1
#define DataSource_PingLun 2

@interface EnrolStudentSchoolDetailVC () <UICollectionViewDelegate,UICollectionViewDataSource,EnrolStudentButtonCellDelegate,EnrolStudentWebViewCellDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    UICollectionView * _collectionView;
    
    NSString * _mappoint;
    
    EnrolStudentDataVO * _voData;
    
    EnrolStudentSchoolDetailDomain * _domainData;
    
    EnrolStudentsSchoolDomain * _schoolDomain;
    
    EnrolStudentSchoolDetailLayout * _oriLayout;
    
    NSInteger _dataSourceType;
    
    NSMutableArray * _commentsData;
    NSMutableArray * _dataHeights;
    
    BOOL _haveCommentData;
    BOOL _haveSummary;
    
    CGFloat _yPoint;
    
    EnrolStudentWebViewCell * _webCell;
    
    BOOL _isFullScreen;
    
    BOOL _canReqData;
    
    NSMutableArray * _buttonItems;
    
    UIView * _bottomView;
    
    NSInteger _pageNo;
    
    NSString * _currentShareUrl;
    
    BOOL isFavor;
    PopupView * popupView;
    ShareViewController * shareVC;
    
    NSString * _tels;
    
    NSMutableArray * _telsNum;
}

@end

@implementation EnrolStudentSchoolDetailVC

static NSString *const CommentCellID = @"commentcellcoll";
static NSString *const ButtonCellID = @"btncellcoll";
static NSString *const WebCellID = @"webcellcoll";
static NSString *const SchoolCellID = @"schoolcellcoll";
static NSString *const NoDataCell = @"nodata";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"学校详情";
    
    _canReqData = YES;
    _haveCommentData = NO;
    _isFullScreen = NO;
    
    _pageNo = 2;
    //读取坐标
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    _mappoint = [defu objectForKey:@"map_point"];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //创建底部按钮
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 48 - 64, KGSCREEN.size.width, 48);
    [self addBtn:_bottomView];
    
    //请求学校详情
    [self getSchoolDetailData];
    
    [self initCollectionView];
}

#pragma mark - 无网络重试
- (void)tryBtnClicked
{
    [self hidenNoNetView];
    
    [self getSchoolDetailData];
    
    [self initCollectionView];
}

#pragma mark - 添加底部按钮
- (void)addBtn:(UIView *)view
{
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

}

#pragma mark - 手势触发方法
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
//    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
//    {
//        NSLog(@"swipe left");
//    }
//    
//    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
//    {
//        NSLog(@"swipe right");
//    }
}

- (void)pullDownTopView
{
    _collectionView.scrollEnabled = YES;
    
    _webCell.webView.scrollView.scrollEnabled = NO;
    
    [_collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - 请求数据 - 首次进入
- (void)getSchoolDetailData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getZhaoShengSchoolDetail:self.groupuuid mappoint:_mappoint success:^(EnrolStudentDataVO *vo)
    {
        [self hidenLoadView];
        
        _voData = vo;
        _domainData = [EnrolStudentSchoolDetailDomain objectWithKeyValues:vo.data];
        _schoolDomain = [EnrolStudentsSchoolDomain objectWithKeyValues:vo.data];
        _schoolDomain.distance = vo.distance;
        
        if (_schoolDomain.summary != nil)
        {
            _haveSummary = YES;
            _oriLayout.cellHeight = [self calSummaryCellHeight:[self formatSummary:_domainData.summary]];
        }
        else
        {
            _haveSummary = NO;
        }
        
        _oriLayout.haveSummary = _haveSummary;
        
        isFavor = vo.isFavor;
        
        _currentShareUrl = vo.share_url;
        
        _tels = _domainData.link_tel;
        
        if(!isFavor)
        {
            ((SPBottomItem *)_buttonItems[0]).btn.selected = YES;
            ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang2"];
        }
        
        [self.view addSubview:_collectionView];
        
        [self.view addSubview:_bottomView];
        
        [self.view bringSubviewToFront:_bottomView];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

#pragma mark - 请求评论
- (void)getCommentData
{
    [[KGHUD sharedHud] hide:self.view];
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getSPCourseComment:self.groupuuid pageNo:@"" success:^(SPCommentVO *commentVO)
    {
        _commentsData = [NSMutableArray arrayWithArray:[EnrolStudentSchoolCommentDomain objectArrayWithKeyValuesArray:commentVO.data]];
        
        if (_commentsData.count == 0)
        {
            _collectionView.bounces = NO;
            
            _haveCommentData = NO;
            
            [[KGHUD sharedHud] hide:self.view];
            
            [_collectionView reloadData];
        }
        else
        {
            _haveCommentData = YES;
            //计算所有数据的行高
            [self calCommentsDataHeight];
            
            _collectionView.bounces = YES;
            
            [[KGHUD sharedHud] hide:self.view];
            
            [_collectionView reloadData];
        }

    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 计算评论内容的高度
- (void)calCommentsDataHeight
{
    if (_dataHeights == nil)
    {
        _dataHeights = [NSMutableArray array];
    }
    
    for (EnrolStudentSchoolCommentDomain * domain in _commentsData)
    {
        CGFloat height = [KGNSStringUtil heightForString:domain.content andWidth:KGSCREEN.size.width - 20];
        
        [_dataHeights addObject:@(height)];
    }
    
    //给布局传递
    _oriLayout.commentsCellHeights = _dataHeights;
}

- (CGFloat)calSummaryCellHeight:(NSString *)content
{
    CGFloat lblW = KGSCREEN.size.width - 90 - 8;
    
    CGFloat itemHeight = [KGNSStringUtil heightForString:[self formatSummary:content] andWidth:lblW];
    
    return itemHeight;
}

- (NSString *)formatSummary:(NSString *)summary
{
    NSArray * arr = [summary componentsSeparatedByString:@","];
    
    NSMutableString * mstr = [NSMutableString string];
    
    for (NSString * str in arr)
    {
        [mstr appendString:[NSString stringWithFormat:@"%@\r\n",str]];
    }
    
    return mstr;
}

#pragma mark - coll datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataSourceType == DataSource_ZhaoSheng || _dataSourceType == DataSource_JianJie)
    {
        return 3;
    }
    else if (_dataSourceType == DataSource_PingLun)
    {
        if (_haveCommentData == YES)
        {
            return 2 + _commentsData.count;
        }
        else
        {
            return 3;
        }
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        EnrolStudentsSchoolCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SchoolCellID forIndexPath:indexPath];
        
        [cell setData:_schoolDomain];
        
        return cell;
    }
    
    else if (indexPath.row == 1)
    {
        EnrolStudentButtonCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ButtonCellID forIndexPath:indexPath];
        
        cell.delegate = self;
        
        return cell;
    }
    else
    {
        
        EnrolStudentWebViewCell * webcell = [collectionView dequeueReusableCellWithReuseIdentifier:WebCellID forIndexPath:indexPath];
        
        webcell.delegate = self;
        
        _webCell = webcell;
        
        
        if (_dataSourceType == DataSource_ZhaoSheng)
        {
            [webcell setData:_voData.recruit_url];
            
            return webcell;
        }
        else if (_dataSourceType == DataSource_JianJie)
        {
            
            [webcell setData:_voData.obj_url];
            
            return webcell;
        }
        else if (_dataSourceType == DataSource_PingLun)
        {
            if (_haveCommentData == YES)
            {
                EnrolStudentCommentCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CommentCellID forIndexPath:indexPath];
                
                [cell setData:_commentsData[indexPath.row - 2]];
                
                return cell;
            }
            
            else
            {
                NoDataView * nodata = [collectionView dequeueReusableCellWithReuseIdentifier:NoDataCell forIndexPath:indexPath];
                
                _collectionView.bounces = NO;
                
                return nodata;
            }
        }
    }
    
    return nil;
}

#pragma mark - 按钮点击事件 - 切换数据源
- (void)funcBtnClick:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 0:
        {
            _currentShareUrl = _voData.share_url;
            [self resetCollectionView];
            _collectionView.bounces = NO;
            [[KGHUD sharedHud] hide:self.view];
            _dataSourceType = DataSource_ZhaoSheng;
            _oriLayout.isCommentCell = NO;
            
            [_collectionView reloadData];
        }
            break;
        case 1:
        {
            _currentShareUrl = _voData.recruit_url;
            [self resetCollectionView];
            _collectionView.bounces = NO;
            [[KGHUD sharedHud] hide:self.view];
            _dataSourceType = DataSource_JianJie;
            _oriLayout.isCommentCell = NO;
            
            [_collectionView reloadData];
        }
            break;
            
        case 2:
        {
            [self resetCollectionView];
            _collectionView.bounces = YES;
            _dataSourceType = DataSource_PingLun;
            _oriLayout.isCommentCell = YES;
            if (_commentsData == nil)
            {
                [self getCommentData];
            }
            else
            {
                [_collectionView reloadData];
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - webview scrollable
- (void)resetCollectionView
{
    _collectionView.scrollEnabled = YES;
    
    _webCell.webView.scrollView.scrollEnabled = NO;
    
    [_collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    EnrolStudentSchoolDetailLayout *layout = [[EnrolStudentSchoolDetailLayout alloc] init];
    
    _oriLayout = layout;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 64 - 48) collectionViewLayout:layout];
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.bounces = NO;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentsSchoolCell" bundle:nil] forCellWithReuseIdentifier:SchoolCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentButtonCell" bundle:nil] forCellWithReuseIdentifier:ButtonCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentWebViewCell" bundle:nil] forCellWithReuseIdentifier:WebCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentCommentCell" bundle:nil] forCellWithReuseIdentifier:CommentCellID];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NoDataView" bundle:nil] forCellWithReuseIdentifier:NoDataCell];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self setupRefresh];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_haveSummary && _dataSourceType != DataSource_PingLun)
    {
        if (ABS(((scrollView.contentOffset.y) - ((scrollView.contentSize.height+48 - KGSCREEN.size.height) + 64))) <= 0.1)
        {
            _collectionView.scrollEnabled = NO;
            
            _webCell.webView.scrollView.scrollEnabled = YES;
            
            [_webCell.webView.scrollView setContentOffset:CGPointMake(0, 1) animated:NO];
        }
    }
    else if (!_haveSummary && _dataSourceType != DataSource_PingLun)
    {
        if (ABS(((scrollView.contentOffset.y) - ((scrollView.contentSize.height+48 - KGSCREEN.size.height) + 64))) <= 0.1)
        {
            _collectionView.scrollEnabled = NO;
            
            _webCell.webView.scrollView.scrollEnabled = YES;
            
            [_webCell.webView.scrollView setContentOffset:CGPointMake(0, 1) animated:NO];
        }
    }
    else
    {
        //自动翻页，加载更多评论数据
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
        CGFloat maximumOffset = size.height;
        //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
        if(currentOffset >= maximumOffset)
        {
            if (_canReqData == YES)
            {
                _canReqData = NO;
                
                if (_dataSourceType == 2)
                {
                    [[KGHttpService sharedService] getSPCourseComment:self.groupuuid pageNo:[NSString stringWithFormat:@"%ld",(long)_pageNo] success:^(SPCommentVO *commentVO)
                     {
                         NSMutableArray * marr = [NSMutableArray arrayWithArray:[EnrolStudentSchoolCommentDomain objectArrayWithKeyValuesArray:commentVO.data]];
                         
                         if (marr.count == 0)
                         {
                         }
                         else
                         {
                             _pageNo++;
                             
                             [_commentsData addObjectsFromArray:marr];
                             
                             //计算所有数据的行高
                             [self calCommentsDataHeight];
                             
                             [_collectionView reloadData];
                             
                             _canReqData = YES;
                         }
                     }
                     faild:^(NSString *errorMsg)
                     {
                         [[KGHUD sharedHud] show:_collectionView onlyMsg:errorMsg];
                     }];
                }
            }
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
    
    NSString *callString = [NSString stringWithFormat:@"tel://%@",_telsNum[buttonIndex-1]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
       NSString * uuid = self.groupuuid;
       
       //调用接口保存用户信息
       [[KGHttpService sharedService] saveTelUserDatas:uuid type:@"4" success:^(NSString *msg)
       {
            
       }
       faild:^(NSString *errorMsg)
       {
           NSLog(@"保存咨询信息失败");
       }];
       
    });
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callString]];
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
            baseVC.groupuuid = self.groupuuid;
            baseVC.dataScourseType = 1;
            
            if(baseVC)
            {
                [self.navigationController pushViewController:baseVC animated:YES];
            }
            
            break;
        }
        case 3:            //电话
        {
            _tels = [_tels stringByReplacingOccurrencesOfString:@"/" withString:@","];
            
            _telsNum = [NSMutableArray arrayWithArray:[_tels componentsSeparatedByString:@","]];
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"为您查询到如下联系号码" delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            
            for (NSString * str in _telsNum)
            {
                [sheet addButtonWithTitle:str];
            }
            
            [sheet showInView:self.view];
            
            break;
        }
    }
}

#pragma mark - 收藏分享相关
//保存收藏
- (void)saveFavorites:(UIButton *)button
{
    [[KGHUD sharedHud] show:self.view];
    
    FavoritesDomain * domain = [[FavoritesDomain alloc] init];
    domain.title = _schoolDomain.brand_name;
    domain.type  = Topic_ZSJH;
    domain.reluuid = self.groupuuid;
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
    if(!popupView)
    {
        popupView = [[PopupView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, KGSCREEN.size.width, KGSCREEN.size.height)];
        popupView.alpha = Number_Zero;
        
        CGFloat height = 140;
        shareVC = [[ShareViewController alloc] init];
        shareVC.view.frame = CGRectMake(Number_Zero,  KGSCREEN.size.height - height - 64, KGSCREEN.size.width, height);
        [popupView addSubview:shareVC.view];
        [self.view addSubview:popupView];
        [self addChildViewController:shareVC];
    }
    
    AnnouncementDomain * domain = [[AnnouncementDomain alloc] init];
    
    domain.share_url = _currentShareUrl;
    domain.isFavor = isFavor;
    
    shareVC.announcementDomain = domain;
    
    [UIView viewAnimate:^ { popupView.alpha = Number_One; } time:Number_AnimationTime_Five];
}


#pragma mark - 上拉刷新，下拉加载数据
- (void)setupRefresh
{
    [_collectionView addFooterWithTarget:self action:@selector(footerRereshing) showActivityView:YES];
    _collectionView.footerPullToRefreshText = @"上拉加载更多";
    _collectionView.footerReleaseToRefreshText = @"松开立即加载";
    _collectionView.footerRefreshingText = @"正在加载中...";
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        _collectionView.footerRefreshingText = @"没有更多了";
        [_collectionView footerEndRefreshing];
    });
}

@end
