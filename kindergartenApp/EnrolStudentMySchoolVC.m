//
//  EnrolStudentMySchoolVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentMySchoolVC.h"
#import "ItemTitleButton.h"
#import "KGHttpService.h"
#import "EnrolStudentDataVO.h"
#import "UIButton+Extension.h"
#import "EnrolStudentMySchoolLayout.h"
#import "EnrolStudentMySchoolCommentCell.h"
#import "EnrolStudentMySchoolWebCell.h"
#import "EnrolStudentMySchoolBtnCell.h"
#import "KGHUD.h"
#import "MJExtension.h"
#import "MySPCommentDomain.h"
#import "EnrolStudentsSchoolCell.h"
#import "EnrolStudentsSchoolDomain.h"
#import "EnrolStudentMySchoolFullScreenLayout.h"
#import "PopupView.h"
#import "ShareViewController.h"

@interface EnrolStudentMySchoolVC () <UICollectionViewDataSource,UICollectionViewDelegate,EnrolStudentMySchoolBtnCellDelegate,EnrolStudentMySchoolWebCellDelegate>
{
    PopupView * popupView;
    ShareViewController * shareVC;
    
    ItemTitleButton  * titleBtn;
    NSArray   * groupDataArray;
    UIView    * groupListView;
    CGFloat     groupViewHeight;
    
    UICollectionView * _collectionView;
    
    NSString * _zhaoshengUrl;
    NSString * _jianjieUrl;
    NSString * _shareUrl;
    
    EnrolStudentMySchoolLayout * _oriLayout;
    EnrolStudentMySchoolFullScreenLayout * _newLayout;
    
    NSInteger _dataSourceType; //0 : web1           1:web2            2:comment
    
    MySPCommentDomain * _commentDomain;
    EnrolStudentsSchoolDomain * _schoolDomain;
    
    BOOL _haveComment;
    
    BOOL keyboardOn;
    
    NSString * _mappoint;
    
    EnrolStudentMySchoolWebCell * _webCell;
}

@end

@implementation EnrolStudentMySchoolVC

static NSString *const BtnCell = @"btncoll";
static NSString *const WebCell = @"webcoll";
static NSString *const PingJiaCell = @"pingjiacoll";
static NSString *const SchoolCell = @"schoolcoll";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"school_share"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = leftBarButtonItem;
    
    self.title = @"我的学校";
    
    //读取坐标
    NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
    _mappoint = [defu objectForKey:@"map_point"];
    
    //请求招生计划和学校简介数据
    [self getSchoolData];
    
    //初始化collectionview
    [self initCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
//    //设置手势
//    UISwipeGestureRecognizer *recognizer;
//    
//    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    
//    [self.view addGestureRecognizer:recognizer];
//    
//    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    
//    [self.view addGestureRecognizer:recognizer];
}

#pragma mark - 分享
- (void)shareBtnClick:(UIButton *)btn
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
    
    domain.title = @"问界互动家园";
    domain.share_url = _shareUrl;
    
    shareVC.announcementDomain = domain;
    
    [UIView viewAnimate:^
     {
         popupView.alpha = Number_One;
     }
     time:Number_AnimationTime_Five];
}

#pragma mark - 手势触发方法
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"swipe left");
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"swipe right");
    }
}

- (void)pullDownTopView
{
    _collectionView.scrollEnabled = YES;
    
    _webCell.webView.scrollView.scrollEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_oriLayout.haveSummary && _dataSourceType != 2)
    {
        if (scrollView.contentOffset.y == 144)
        {
            _collectionView.scrollEnabled = NO;
        }
    }
    else if (!_oriLayout.haveSummary && _dataSourceType != 2)
    {
        if (scrollView.contentOffset.y == (scrollView.contentSize.height - KGSCREEN.size.height) + 64)
        {
            _collectionView.scrollEnabled = NO;
            
            _webCell.webView.scrollView.scrollEnabled = YES;
        }
    }
}

#pragma mark - webview scrollable
- (void)isScrollAble
{
    if (_collectionView.contentOffset.y > 0)
    {
        _collectionView.scrollEnabled = NO;
        
        _webCell.webView.scrollView.scrollEnabled = YES;
    }
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    EnrolStudentMySchoolLayout *layout = [[EnrolStudentMySchoolLayout alloc] init];
    
    _oriLayout = layout;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 64) collectionViewLayout:layout];
    
    _collectionView.bounces = NO;
    
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentMySchoolCommentCell" bundle:nil] forCellWithReuseIdentifier:PingJiaCell];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentMySchoolWebCell" bundle:nil] forCellWithReuseIdentifier:WebCell];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentMySchoolBtnCell" bundle:nil] forCellWithReuseIdentifier:BtnCell];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EnrolStudentsSchoolCell" bundle:nil] forCellWithReuseIdentifier:SchoolCell];

    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
}

#pragma mark - 按钮点击
- (void)funcBtnClick:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 0:
        {
            [self isScrollAble];
            [[KGHUD sharedHud] hide:self.view];
            _dataSourceType = 0;
            
            [_collectionView reloadData];
        }
            break;
        case 1:
        {
            [self isScrollAble];
            [[KGHUD sharedHud] hide:self.view];
            _dataSourceType = 1;
            
            [_collectionView reloadData];
        }
            break;
            
        case 2:
        {
            [[KGHUD sharedHud] hide:self.view];
            _dataSourceType = 2;

            [self getCommentData];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 获取评论
- (void)getCommentData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getMySchoolComment:[KGHttpService sharedService].groupDomain.uuid success:^(EnrolStudentDataVO *vo)
    {
        if (vo.data == nil)  //没有评论，让用户评论
        {
            _haveComment = NO;
        }
        else                 //有评论，读取评论显示
        {
            _haveComment = YES;
            
            NSMutableArray * marr = [NSMutableArray arrayWithArray:[MySPCommentDomain objectArrayWithKeyValuesArray:vo.data]];
            
            //读取到这个模块的评论
            for (MySPCommentDomain * domain in marr)
            {
                if (domain.type == 4)
                {
                    _commentDomain = domain;
                    break;
                }
            }
        }
        
        [[KGHUD sharedHud] hide:self.view];
        
        [_collectionView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

#pragma mark - 请求数据
- (void)getSchoolData
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getZhaoShengSchoolDetail:self.uuid mappoint:_mappoint success:^(EnrolStudentDataVO *vo)
    {
        _zhaoshengUrl = vo.recruit_url;
        _jianjieUrl = vo.obj_url;
        _shareUrl = vo.share_url;
        
        _schoolDomain = [EnrolStudentsSchoolDomain objectWithKeyValues:vo.data];
        
        if (_schoolDomain.summary == nil || [_schoolDomain.summary isEqualToString:@""])
        {
            _oriLayout.haveSummary = NO;
        }
        else
        {
            _oriLayout.haveSummary = YES;
        }
        
        [self hidenLoadView];
        
        [self.view addSubview:_collectionView];
    }
    faild:^(NSString *errorMsg)
    {
        [self showNoNetView];
    }];
}

#pragma mark - collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        EnrolStudentsSchoolCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SchoolCell forIndexPath:indexPath];
        
        [cell setData:_schoolDomain];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        EnrolStudentMySchoolBtnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:BtnCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        return cell;
    }
    else if (indexPath.row == 2)
    {
        EnrolStudentMySchoolWebCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:WebCell forIndexPath:indexPath];
        
        cell.delegate = self;
        
        _webCell = cell;
        
        if (_dataSourceType == 0)
        {
            [cell setData:_zhaoshengUrl];
            
            return cell;
        }
        else if (_dataSourceType == 1)
        {
            [cell setData:_jianjieUrl];
            
            return cell;
        }
        else
        {
            EnrolStudentMySchoolCommentCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PingJiaCell forIndexPath:indexPath];
            
            cell.uuid = self.uuid;
            
            if (_haveComment == YES)
            {
                [cell haveCommentFun:_commentDomain];
            }
            else if (_haveComment == NO)
            {
                [cell noCommentFun];
            }
            
            return cell;
        }
    }
    
    return nil;
}

#pragma mark - 监听键盘事件
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (keyboardOn == NO)
    {
        [self.view setOrigin:CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y - (100 + 5))];
        keyboardOn = YES;
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (keyboardOn == YES)
    {
        [self.view setOrigin:CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y + (100 + 5))];
        keyboardOn = NO;
    }
    
}

@end
