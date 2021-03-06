//
//  FPHomeVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/13.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeVC.h"
#import "ParallaxHeaderView.h"
#import "FPHomeTopView.h"
#import "FPHomeSonView.h"
#import "FPHomeSelectView.h"
#import "FPHomeBtnCell.h"
#import "FPGifrwarePickerVC.h"
#import "DBNetDaoService.h"
#import "FPMyFamilyPhotoCollectionDomain.h"
#import "FPHomeWarningCell.h"
#import "MBProgressHUD+HM.h"
#import "MJExtension.h"
#import "FPHomeTimeLineCell.h"
#import "FPUploadVC.h"
#import "FPUploadSaveUrlDomain.h"
#import "MJRefresh.h"
#import "FPFamilyPhotoNormalDomain.h"
#import "KGDateUtil.h"
#import "MBProgressHUD+HM.h"
#import "FPTimeLineDetailVC.h"
#import "FPHomeTablePhotoCellTableViewCell.h"
#import "FPCollectionVC.h"

#import "FPHomeTimeLineSectionHeaderTableViewCell.h"
#import "UIImageView+WebCache.h"

#import "SINavigationMenuView.h"
#import "FPFamilyPhotoCollectionDetailTableViewController.h"
#import "GiftwareListVC.h"
#import "FFMovieEditMainVC.h"



//由于此方法调用十分频繁，cell的标示声明成静态变量有利于性能优化
#define DF_cellIdentifier @"FPHomeVC_UITableViewCell"

//由于此方法调用十分频繁，cell的标示声明成静态变量有利于性能优化
#define  DF_sectionHeaderIdentifier @"FPHomeTimeLineSectionHeaderTableViewCell"





NSInteger localDBlimit=50;
@interface FPHomeVC () <UITableViewDataSource,UITableViewDelegate,FPHomeSelectViewDelegate,SINavigationMenuDelegate>
{
    
    //header 显示相册。
    FPHomeTopView * fPHomeTopView;
    //已经加载的数据时间范围
    FPFamilyInfoDomain * localFamilyRangeTime ;
    //本地数据库分页查询还有数据没取完。默认true
    BOOL isLocalDBHasData;
    //远程数据库分页查询还有数据没取完。默认true
    BOOL isRemoteDBHasData;
    //上传照片进度按钮
    UIButton* btn_shangchuanzhaopian;
    
    //导航条下来数据内容
    NSMutableArray * _dataOfTopTitleBtnArray;
    //导航条下来数据内容,我的家庭相册列表
    NSArray * _dataOfmyCollectionArray;
    NSInteger  _PullDownMenu_myCollection_index;
    
    SINavigationMenuView * _topMenu;
    UITableView * _tableView;
    //左上下拉按钮
    FPHomeSonView * sonView;
    //上传照片选择（上传照片，新建精品相册）
    FPHomeSelectView * selView;
    
    DBNetDaoService * _service;
    
//    FPMyFamilyPhotoCollectionDomain * _myCollectionDomain;
    
    //照片数组
    NSMutableArray * dataSource;
    //照片数组加分组(日期分组）
    NSMutableArray * dataSourceGroup;
    //照片数组加分组（分组包含的数据）
    
    NSMutableDictionary * dataSourceGroupChildMap;
    
   
    
    BOOL _selectViewOpen;
    
    UIActivityIndicatorView * _aiv;
    
    //本地数据库分页数据

    NSInteger _pageNo;
    //当前时间
    NSString *_cur_time;
}

@end

@implementation FPHomeVC
+(void) setFamily_uuid:(NSString *)str{
//    family_uuid=str;
    
    [GlobalMap setObject:str forKey:NSUserDefaults_Key_FPMyFamilyPhotoCollection];
    //存沙盒
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:str forKey:NSUserDefaults_Key_FPMyFamilyPhotoCollection];
}
+(NSString *) getFamily_uuid{
    
    NSString * family_uuid=[GlobalMap objectForKey:NSUserDefaults_Key_FPMyFamilyPhotoCollection];
    if(family_uuid==nil){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        family_uuid= [userDefaults objectForKey:NSUserDefaults_Key_FPMyFamilyPhotoCollection];

    }
    return family_uuid;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"FPHomeVC.viewDidAppear()");
    //选择自己喜欢的颜色
    UIColor * color = [UIColor clearColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
//    [self fPPhotoItem_queryOfNewDataCount];
    //获取我的家庭相册信息
    [self getMyPhotoCollectionInfo];
}

- (void)viewDidLoad
{
    
    @try{
        
//        NSLog(@"FPHomeVC.viewDidLoad()");
        [super viewDidLoad];
        isLocalDBHasData=true;
        isRemoteDBHasData=true;
//        localFamilyRangeTime=[FPFamilyInfoDomain new];
        
        
        _dataOfTopTitleBtnArray=[NSMutableArray array];
        
        _dataOfmyCollectionArray = [NSMutableArray array];
        
        _selectViewOpen = NO;
        _pageNo = 1;
                //创建服务类
        _service = [DBNetDaoService defaulService];
        
        //创建下拉刷新navbar 菊花框
        [self initHeaderRefresh];
        //创建导航菜单
        [self createBarItems];
        
        [self initTableView];
        
        
        
        [self regNotification];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    
}







//注册通知
- (void)regNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //注册通知,用户提示用户有新数据需要更新啦
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(showUpDatePhotoDataView:) name:@"canUpDatePhotoData" object:nil];
    
    //用于从数据库获取数据
    [center addObserver:self selector:@selector(loadData) name:@"canLoadData" object:nil];
    
    [center addObserver:self selector:@selector(updatePhotoToRemoteFinish:) name:@"updatePhotoToRemoteFinish" object:nil];
    
    [center addObserver:self selector:@selector(headerRefreshing) name:@"refreshtimelinedata" object:nil];
//    [center addObserver:self selector:@selector(showEndUpDatePhotoDataView:) name:@"updateInfo" object:nil];
    [center addObserver:self selector:@selector(reloadData) name:@"reloaddata" object:nil];
}


//切换家庭相册
- (void)changeMyCollection :(NSInteger)row
{
    FPMyFamilyPhotoCollectionDomain * domain=_dataOfmyCollectionArray[row];
    //设置全局保存
   [FPHomeVC setFamily_uuid:domain.uuid];
 
    [self afterLoadFamilyCollectionData:domain];
   
  

}


//获取当前用户选择相册
- (FPMyFamilyPhotoCollectionDomain *)getCurFPMyFamilyPhotoCollectionDomain
{
    
    for(FPMyFamilyPhotoCollectionDomain * domain in _dataOfmyCollectionArray){
        
        if ([domain.uuid isEqualToString:  [FPHomeVC getFamily_uuid]] ) {
            return domain;
        }
        
    }
    
    if(_dataOfmyCollectionArray.count>0){
        return _dataOfmyCollectionArray[0];
    }
    return NULL;

}

- (void)initNaviationTitleBtn
{
    NSArray *testArray;
//    _dataOfTopTitleBtnArray = @[@"智能排序",@"评价最高",@"距离最近"];
//
    
    _dataOfTopTitleBtnArray=[NSMutableArray array];
    for(FPMyFamilyPhotoCollectionDomain * domain in _dataOfmyCollectionArray){
        
        [_dataOfTopTitleBtnArray addObject:domain.title];
    }
    
    FPMyFamilyPhotoCollectionDomain * cDomain=[self getCurFPMyFamilyPhotoCollectionDomain];
    NSString * title=nil;
    if(cDomain){
        title=[NSString stringWithFormat:@"%@(%d)",cDomain.title,_dataOfmyCollectionArray.count];
       
    }else{
        title=@"无相册";
    }
     UIButton *titleButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [titleButton setTitle: title forState: UIControlStateNormal];
//     [titleButton setBackgroundImage:[UIImage imageNamed:@"new_album"] forState:UIControlStateNormal];
     [titleButton sizeToFit];
     self.navigationItem.titleView = titleButton;
    
    if (_topMenu!=nil) {
        [_topMenu onHideMenu];
        [_topMenu removeFromSuperview];
        _topMenu=nil;
    }
    
    {
        
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        _topMenu= [[SINavigationMenuView alloc] initWithFrame:frame title:cDomain.title];
        [_topMenu displayMenuInView:self.view];
        _topMenu.items = _dataOfTopTitleBtnArray;
        _topMenu.delegate = self;
        self.navigationItem.titleView = _topMenu;
    }

}
#pragma 导航条下拉菜单
- (void)didSelectItemAtIndex:(NSUInteger)index
{
    [self changeMyCollection:index];
    
    
    NSLog(@"did selected item at index %@", _dataOfTopTitleBtnArray[index]);
}

#pragma 加载家庭相册数据后，
- (void)afterLoadFamilyCollectionData:(FPMyFamilyPhotoCollectionDomain *) domain
{
    
    _pageNo=1;
//    localFamilyRangeTime.minTime=nil;
//    localFamilyRangeTime.maxTime=nil;
    localFamilyRangeTime=[_service queryTimeByFamilyUUID :[FPHomeVC getFamily_uuid]];
    
    
    isLocalDBHasData=true;
    isRemoteDBHasData=true;
    
    _cur_time=[KGDateUtil getLocalDateStr] ;
    
    
    //    _cur_time=@"2015-01-01 00:00:00";
    
    
    [fPHomeTopView setData:[self getCurFPMyFamilyPhotoCollectionDomain]];
    
    SINavigationMenuView *menu=self.navigationItem.titleView;
    
    [menu setMenuTitle:domain.title];
    
    //先更新
    
//      if(localFamilyRangeTime.updateTime==nil||[@"" isEqualToString:localFamilyRangeTime.updateTime]){
//          
//          localFamilyRangeTime.updateTime=@"1700-01-01 00:00:00";
//          [_service updateUpdateTime:localFamilyRangeTime.family_uuid updatetime:localFamilyRangeTime.updateTime];
//          //有数据则，初三全部更新变更数据。
////          if([localFamilyRangeTime.minTime isEqualToString:localFamilyRangeTime.maxTime]){
////                          }
//        
//      }
    					
    if(localFamilyRangeTime.updateTime.length>1&&localFamilyRangeTime.maxTime.length>1){
        
        [self fPPhotoItem_queryOfNewDataCount];
        
        [self showLoadView];
        [_service updateFPPhotoUpdateCountWithFamilyUUID:[FPHomeVC getFamily_uuid] success:^(NSString *status) {
            [self hidenLoadView];
            [self loadDataPhotoByFamilyUUID];
            
            
        } faild:^(NSString *errorMsg) {
            errorMsg=[NSString stringWithFormat:@"更新数据失败:%@",errorMsg];
                    [MBProgressHUD showError:errorMsg];
            
            [self hidenLoadView];
            
            [self loadDataPhotoByFamilyUUID];
        }];

    }else{//本地没数据，直接取数据
        //加载相册内照片
        [self loadDataPhotoByFamilyUUID];
      
       
    }
    
    
}



- (void)initTableView
{
    //自定义的headerview
    FPHomeTopView * view = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeTopView" owner:nil options:nil] firstObject];
    view.delegate=self;
    
    [view.warningLbl setHidden:YES];
    [view setData:[self getCurFPMyFamilyPhotoCollectionDomain]];
    view.size = CGSizeMake(APPWINDOWWIDTH, 235);
    //回调
    __weak typeof(self) weakSelf = self;

    view.pushToMyAlbum = ^{
        
        
        FPFamilyPhotoCollectionDetailTableViewController * fPFamilyPhotoCollectionDetailTableViewController=[[FPFamilyPhotoCollectionDetailTableViewController alloc]init];
        [fPFamilyPhotoCollectionDetailTableViewController loadLoadByUuid:[FPHomeVC getFamily_uuid]];
        
        [weakSelf.navigationController pushViewController:fPFamilyPhotoCollectionDetailTableViewController animated:YES];
//        [self.navigationController pushViewController:nil animated:YES];
        NSLog(@"push到我的家庭相册");
    };
    
    fPHomeTopView=view;
    
    //弄到tableviewheader里面去
    ParallaxHeaderView * headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:view];
    
    
//    
//    if (_warningCell == nil)
//                {
//                    _warningCell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeWarningCell" owner:nil options:nil] firstObject];
//        
//                    _warningCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    [headerView addSubview:_warningCell];
//                  //  return _warningCell;
//                }
    
//    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableHeaderView:headerView];
    
    
    [self setupRefresh];

    [self.view addSubview:_tableView];
}

#pragma mark UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
//        [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
//        
        sonView.origin = CGPointMake(0, -132);
        [sonView setHidden:true];
    }
}






//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0)
//    {
//        if (_warningCell == nil)
//        {
//            _warningCell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeWarningCell" owner:nil options:nil] firstObject];
//            
//            _warningCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            return _warningCell;
//        }
//        else
//        {
//            return _warningCell;
//        }
//    }
//    else
//    {
//        static NSString * str = @"time_line_cell";
//        
//        FPHomeTimeLineCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
//        
//        if (cell == nil)
//        {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeTimeLineCell" owner:nil options:nil] firstObject];
//        }
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        [cell setDateAndCount:_timeDatas[indexPath.row - 1]];
//        
//        [cell setImgs:[self queryImgs:indexPath]];
//        
//        return cell;
//    }
//    
//    return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataSourceGroup==0){//无数据
        return 204;
    }
    return APPWINDOWWIDTH/3;
}



#pragma mark - 创建navBar items
- (void)createBarItems
{
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"new_album"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pushToUpLoadVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    
     btn_shangchuanzhaopian = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,20)];
    [btn_shangchuanzhaopian setBackgroundImage:[UIImage imageNamed:@"uploadtaskcount"] forState:UIControlStateNormal];
    [btn_shangchuanzhaopian setTitle:@"0" forState:UIControlStateNormal];
    [btn_shangchuanzhaopian setTitleColor:[UIColor whiteColor]   forState:UIControlStateNormal];
    
    [btn_shangchuanzhaopian addTarget:self action:@selector(pushToFPUploadTaskVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btn_shangchuanzhaopian];
    
    
       
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBarBtn,rightBarBtn2,nil]];
        //初始化隐藏。大于0显示。
    [btn_shangchuanzhaopian setHidden:YES];
    
//    self.navigationItem.rightBarButtonItem = rightBarBtn;
 
    
    UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,27)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"btn_fp_home_more"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(showSonView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    
   
}
#pragma 显示上传任务进度表
- (void)pushToFPUploadTaskVC
{
     [self.navigationController pushViewController:[[FPUploadVC alloc]init]  animated:YES];
}

- (void)pushToUpLoadVC
{
    
    if (sonView)
    {
        [sonView  setHidden:YES];
    }
    if (selView)
    {
        if([selView isHidden]){
             [self.view bringSubviewToFront:selView];
              [selView setHidden:NO];
        }else{
              [selView setHidden:YES];
        }
      
        return;
    }
 
        
        selView = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeSelectView" owner:nil options:nil] firstObject];
        selView.delegate = self;
        selView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
       
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.3];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [[selView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
        //添加最上层
       
       [self.view addSubview:selView];
        
   
}

- (void)showSonView
{
    if (selView)
    {
        [selView  setHidden:YES];
    }
    if(sonView==nil){
        
        
        //左边按钮
        sonView = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeSonView" owner:nil options:nil] firstObject];
        __weak typeof(self) weakSelf = self;
        sonView.origin = CGPointMake(0, -132);
        //回调
        sonView.pushUpLoad = ^{
            [weakSelf.navigationController pushViewController:[[FPUploadVC alloc]init]  animated:YES];
            [sonView setHidden:YES];
        };
        sonView.pushCollege = ^{
            [weakSelf.navigationController pushViewController:[[FPCollectionVC alloc]init] animated:YES];
             [sonView setHidden:YES];
        };
        //家庭相册修改
        sonView.pushAlbunInfo = ^{
             [sonView setHidden:YES];
            FPFamilyPhotoCollectionDetailTableViewController * fPFamilyPhotoCollectionDetailTableViewController=[[FPFamilyPhotoCollectionDetailTableViewController alloc]init];
            [fPFamilyPhotoCollectionDetailTableViewController loadLoadByUuid:[FPHomeVC getFamily_uuid]];
            
            [weakSelf.navigationController pushViewController:fPFamilyPhotoCollectionDetailTableViewController animated:YES];
        };
        
        //家庭相册添加
        sonView.addMyCollectionBtn = ^{
            [sonView setHidden:YES];
            FPFamilyPhotoCollectionDetailTableViewController * fPFamilyPhotoCollectionDetailTableViewController=[[FPFamilyPhotoCollectionDetailTableViewController alloc]init];
//            [fPFamilyPhotoCollectionDetailTableViewController loadLoadByUuid:[FPHomeVC getFamily_uuid]];
//            
            [weakSelf.navigationController pushViewController:fPFamilyPhotoCollectionDetailTableViewController animated:YES];
        };

        
        sonView.origin = CGPointMake(0, -174);
        sonView.size = CGSizeMake(140, 174);
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:sonView.bounds];
        sonView.layer.masksToBounds = NO;
        sonView.layer.shadowColor = [UIColor blackColor].CGColor;
        sonView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        sonView.layer.shadowOpacity = 0.5f;
        sonView.layer.shadowPath = shadowPath.CGPath;
          [self.view addSubview:sonView];
    }else{
        
        if([sonView isHidden]){
            [sonView setHidden:NO];
            [self.view bringSubviewToFront:sonView];
        }else{
            [sonView setHidden:YES];
        }
       

    }
    
  
    [UIView animateWithDuration:0.2 animations:^
    {
        if (sonView.origin.y == 0)
        {
            sonView.origin = CGPointMake(0, -174);
             [sonView setHidden:NO];
            [self.view bringSubviewToFront:sonView];
        }
        else
        {
            sonView.origin = CGPointMake(0, 0);
             [sonView setHidden:NO];
            [self.view bringSubviewToFront:sonView];
        }
        
    }];
}

- (void)pushToImagePickerVC
{
    _selectViewOpen = NO;
    
    FPUploadVC * vc = [[FPUploadVC alloc] init];
    vc.isJumpTwoPages = YES;
    
    vc.family_uuid = [FPHomeVC getFamily_uuid];
    
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)pushToCreateGiftwareShopVC
{
    
    
    int count=[[DBNetDaoService defaulService] getfp_photo_item_count:[FPHomeVC getFamily_uuid]];
    if(count==0){
        [MBProgressHUD showSuccess:@"请先上传照片"];
        return;
    }
    
    FFMovieEditMainVC * vc = [[FFMovieEditMainVC alloc] init];
     [FFMovieShareData getFFMovieShareData].domain=nil;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)getPhotoDatas
{
    [_service getTimelinePhotos:[FPHomeVC getFamily_uuid]];
}

- (void)hidenSelf
{
    _selectViewOpen = NO;
    
//    [selView removeFromSuperview];
    [selView setHidden:YES];
}

#pragma mark - 通知 用于提示用户
- (void)showUpDatePhotoDataView:(NSNotification *)noti
{
    
      NSString *count = noti.object;
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [fPHomeTopView.warningLbl setHidden:NO];
        fPHomeTopView.warningLbl.text = @"有新照片,请下拉刷新";
        //上传任务数量显示
      
        [btn_shangchuanzhaopian setTitle:count forState:(UIControlStateNormal)];
        
        [btn_shangchuanzhaopian setHidden:[@"0" isEqualToString: count]];

    });
}

//- (void)showEndUpDatePhotoDataView:(NSNotification *)noti
//{
//    dispatch_async(dispatch_get_main_queue(), ^
//    {
//        fPHomeTopView.warningLbl.text = [NSString stringWithFormat:@"最后更新时间:%@",noti.object];
//    });
//}

#pragma mark - 获取我的相册信息 首页头部显示用
- (void)getMyPhotoCollectionInfo
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getMyPhotoCollection:^( NSArray *datas)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self hidenLoadView];
            
            if (!datas || !datas.count){
                //array是空或nil
                NSLog(@"MyPhotoCollection is empty!");
                return;
            }
            
            _dataOfmyCollectionArray=datas;
            BOOL isChageFailyUuid=true;
            FPMyFamilyPhotoCollectionDomain * domain=nil;
            for(FPMyFamilyPhotoCollectionDomain* v in datas){
                //没有初始化，则默认第一个。
                if([FPHomeVC getFamily_uuid]==nil){
                    [FPHomeVC setFamily_uuid:v.uuid];
                    domain=v;
                    isChageFailyUuid=false;
                    break;
                    
                }
                //包含全局uuid，则设置为初始化
                if([v.uuid isEqualToString:[FPHomeVC getFamily_uuid]]){
                     isChageFailyUuid=false;
                    domain=v;
                    break;
                }

            }
            //没设置则设置为第一个
            if(isChageFailyUuid&&_dataOfmyCollectionArray.count>0){
                
                
                FPMyFamilyPhotoCollectionDomain * tmp=_dataOfmyCollectionArray[0];
                  [FPHomeVC setFamily_uuid:tmp.uuid];
                domain=tmp;
            }
            
            [self initNaviationTitleBtn];
            [self afterLoadFamilyCollectionData:domain];
          
        });
    }
    faild:^(NSString *errorMsg)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self hidenLoadView];
            [self showNoNetView];
        });
    }];
}

#pragma mark - 网络重试按钮
- (void)tryBtnClicked
{
    [self hidenNoNetView];
    //获取我的家庭相册信息
    [self getMyPhotoCollectionInfo];
}

#pragma mark - 根据数据加载到tableview
//timeAfter true，标示添加数据时间数组是正序。从0位置插入。
- (void)loadDataPhotoByDataArr: (NSMutableArray *) dataArr timeAfter:(BOOL)timeAfter
{
    
        [_tableView footerEndRefreshing];

        //反过来
    //    NSArray * dataArr = [[arr reverseObjectEnumerator] allObjects];
    if(dataSourceGroup==nil)dataSourceGroup=[NSMutableArray array];
    if(dataSourceGroupChildMap==nil)dataSourceGroupChildMap=[[NSMutableDictionary alloc] init];
    
    
    for(FPFamilyPhotoNormalDomain * domain in dataArr){
        
        if(domain.create_time==nil){
            domain.create_time=@"1900-01-01 00:00:00";
        }
       NSString *sectionName= [[domain.create_time componentsSeparatedByString:@" "] firstObject];
        NSMutableArray *  tmp= [dataSourceGroupChildMap objectForKey:sectionName];
        //分组数据转换
        if(tmp==nil){
            tmp=[NSMutableArray array];
            if(timeAfter){
                [dataSourceGroup insertObject:sectionName atIndex:0];
                [tmp insertObject:domain atIndex:0];
                
            }else{
                [dataSourceGroup addObject:sectionName];
                
                [tmp addObject:domain];

            }
            [dataSourceGroupChildMap setObject:tmp forKey:sectionName];
        }else{
            
            
            if(timeAfter){
                [tmp insertObject:domain atIndex:0];
                
            }else{
                 [tmp addObject:domain];
            }
           
        }

    }
    
 
    
    [_tableView reloadData];
    

}
#pragma mark - 获取数据库照片数据，根据创建时间

- (void)loadDataPhotoByFamilyUUID
{
    
    
    if(isLocalDBHasData==false){
        //远程服务器获取数据
        [self loadRemoteDataPhotoByFamilyUUID];
        return;
    }
    if(!_cur_time)_cur_time=[KGDateUtil getLocalDateStr] ;
    

    if(!_pageNo)_pageNo=1;
    
    
    
      NSMutableArray * dataArr = [_service getListTimePhotoDataByPage:_cur_time familyUUID:[FPHomeVC getFamily_uuid] pageNo:_pageNo limit:localDBlimit];
    
    
    
    if(_pageNo==1){
        [dataSourceGroup removeAllObjects];
        
        [dataSourceGroupChildMap removeAllObjects];
    }
    
    
    
    
    //本地第1页数据获取后，设置第一条数据为maxTime；
    if(isLocalDBHasData&&isRemoteDBHasData&&_pageNo==1){
        
        if(dataArr.count>0){
            FPFamilyPhotoNormalDomain * domain=[dataArr firstObject];
            localFamilyRangeTime.maxTime=domain.create_time;
            [_service updateMaxTime:localFamilyRangeTime];
        }
    }
    _pageNo++;
    

    //本地数据已经取完了，下次从远程服务器取。
    if(dataArr.count<localDBlimit){
        NSLog(@"本地数据已经没有了，准备远程取数据");
        isLocalDBHasData=false;
        
    }
    //本地没数据，直接远程取数据。
    if(dataArr.count==0&&isRemoteDBHasData==true){
        [self loadRemoteDataPhotoByFamilyUUID];
        if(_pageNo==1){
             localFamilyRangeTime.maxTime=[KGDateUtil getLocalDateStr];
              localFamilyRangeTime.updateTime=localFamilyRangeTime.maxTime;
              localFamilyRangeTime.minTime=localFamilyRangeTime.maxTime;
            localFamilyRangeTime.family_uuid=localFamilyRangeTime.maxTime;
            
            [_service updateMaxTime:localFamilyRangeTime];
            
        }
        return;
    }
   
    
    [self loadDataPhotoByDataArr:dataArr timeAfter:false];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                   {
                       [_aiv stopAnimating];
                   });
}


#pragma mark - 远程获取数据.（某个时间以前的数据）
- (void)loadRemoteDataPhotoByFamilyUUID
{
    
    
    if (isRemoteDBHasData==false) {
        
    }
    if (![_aiv isAnimating])
    {
        _aiv.hidden = NO;
        [_aiv startAnimating];
        
        //1.去查询增量更新maxtime以后的数据并保存到本地,注意要更新时间
        //从数据库查询 familyUUID 所对应的 maxTime 和 minTime 如果没有相应数据 则自动创建一条，且把maxTime和minTime设置为空
        //        FPFamilyInfoDomain * localFamilyRangeTime = [_service queryTimeByFamilyUUID:[FPHomeVC getFamily_uuid]];
        //
        //加载更早以前数据
        [[KGHttpService sharedService] getPhotoCollectionUseFamilyUUID:[FPHomeVC getFamily_uuid] withTime:localFamilyRangeTime.minTime timeType:1 pageNo:@"1" success:^(FPFamilyPhotoLastTimeVO *lastTimeVO)
         {
             
             
             [_tableView footerEndRefreshing];
             
             
             [_aiv stopAnimating];
             _aiv.hidden = YES;
             
             NSArray * datas = [FPFamilyPhotoNormalDomain objectArrayWithKeyValuesArray:lastTimeVO.data];
             
             NSLog(@"datas.count=%d",datas.count );
             
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//                            {
//                                //更新刷新时间
//                                fPHomeTopView.warningLbl.text = fPHomeTopView.warningLbl.text = [NSString stringWithFormat:@"最后更新时间:%@",[KGDateUtil getLocalDateStr]];
//                            });
             
             if(lastTimeVO.pageSize>datas.count){
                 isRemoteDBHasData=false;
             }
            
             if (datas.count> 0)
             {
                 //把数据缓存到本地
                 NSLog(@"缓存下拉加载的相片数据到数据库中");
                 [_service addPhotoToDatabase:(datas)];
                 
                 localFamilyRangeTime.family_uuid=[FPHomeVC getFamily_uuid];
                 localFamilyRangeTime.minTime=lastTimeVO.lastTime;
                 
                 
                 
                 //设置maxTime 和 minTime到这个familyUUID
                 NSLog(@"%@ =更新time中=  %@ === %@",[KGDateUtil getLocalDateStr],lastTimeVO.lastTime,[KGDateUtil getLocalDateStr]);
                 //
                 [_service updateMaxTime:localFamilyRangeTime];
                 
                 //2.去数据库里面查询
                 // [self loadData];
                [self loadDataPhotoByDataArr:datas timeAfter:false];
             }else{
                 _tableView.footerRefreshingText = @"没有更多了...";
                 
                 [_tableView footerEndRefreshing];
                 [_tableView reloadData];
                 
                 
             }
         }
                                                                 faild:^(NSString *errorMsg)
         {
             [MBProgressHUD showError:@"请求超时,请稍后再试!"];
             [_aiv stopAnimating];
             _aiv.hidden = YES;
         }];
    }
}





#pragma mark - 远程获取数据.（某个时间以后的数据）。
//本地数据库已经有数据了，在新数据的时候，增量更新。
- (void)loadRemoteDataPhotoByFamilyUUIDAfterLocalTime
{
        if (![_aiv isAnimating])
    {
        _aiv.hidden = NO;
        [_aiv startAnimating];
                //加载更早以前数据
        [[KGHttpService sharedService] getPhotoCollectionUseFamilyUUID:[FPHomeVC getFamily_uuid] withTime:localFamilyRangeTime.maxTime timeType:0 pageNo:@"1" success:^(FPFamilyPhotoLastTimeVO *lastTimeVO)
         {
             
             
             [_tableView headerEndRefreshing];
             [_aiv stopAnimating];
             _aiv.hidden = YES;

             NSArray * datas = [FPFamilyPhotoNormalDomain objectArrayWithKeyValuesArray:lastTimeVO.data];
             
             NSLog(@"datasNew.count=%d",datas.count );
            
          
             if (datas.count> 0)
             {
                 //把数据缓存到本地
                 NSLog(@"缓存下拉加载的相片数据到数据库中");
                 [_service addPhotoToDatabase:(datas)];
                 
                 localFamilyRangeTime.family_uuid=[FPHomeVC getFamily_uuid];
                 
                 localFamilyRangeTime.maxTime=lastTimeVO.lastTime;
                 
                 
                 //设置maxTime 和 minTime到这个familyUUID
                 NSLog(@"%@ =更新time中=  %@ === %@",[KGDateUtil getLocalDateStr],lastTimeVO.lastTime,[KGDateUtil getLocalDateStr]);
                 
                 [_service updateMaxTime:localFamilyRangeTime];
                 
                 //2.去数据库里面查询
                // [self loadData];
                [self loadDataPhotoByDataArr:datas timeAfter:true];
             }else{
                 _tableView.headerRefreshingText = @"没有新数据...";
              }
             
             //没有数据隐藏提示
             if(lastTimeVO.pageSize>datas.count){
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                {
                                    [fPHomeTopView.warningLbl setHidden:YES];
                                    //更新刷新时间
                                    //                                fPHomeTopView.warningLbl.text = fPHomeTopView.warningLbl.text = [NSString stringWithFormat:@"最后更新时间:%@",[KGDateUtil getLocalDateStr]];
                                });

             }
             
         }
        faild:^(NSString *errorMsg)
         {
             [MBProgressHUD showError:@"请求超时,请稍后再试!"];
             [_aiv stopAnimating];
             _aiv.hidden = YES;
         }];
    }
}



#pragma mark - 获取数据库照片数据，根据拍摄日期分文件夹
- (void)loadDataByPotoDate
{
//    NSMutableArray * arr = [_service getListTimeHeadData:[FPHomeVC getFamily_uuid]];
//    //反过来
//    NSArray * dataArr = [[arr reverseObjectEnumerator] allObjects];
//    
//    [_timeDatas removeAllObjects];
//    [_timeDatas addObjectsFromArray:dataArr];
//    [_tableView reloadData];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//    {
//        [_aiv stopAnimating];
//    });
}

//- (NSArray *)queryImgs:(NSIndexPath *)indexPath
//{
//    NSString * strs = _timeDatas[indexPath.row - 1];
//    NSArray * imgs = [_service getListTimePhotoData:[[strs componentsSeparatedByString:@","] firstObject] familyUUID:[FPHomeVC getFamily_uuid]];
//    [_photoDatas addObject:imgs];
//    return imgs;
//}

#pragma mark - 保存上传图片列表
- (void)updatePhotoToRemoteFinish:(NSNotification *)noti
{
    NSLog(@"updatePhotoToRemoteFinish");
    //防止数据还没更新
      [self performSelector:@selector(getMyPhotoCollectionInfo) withObject:nil afterDelay:2.0f];
    
//    [self getMyPhotoCollectionInfo];
//    FPUploadSaveUrlDomain * domain = noti.object;
//    [_service saveUploadImgPath:domain.localUrl status:[NSString stringWithFormat:@"%ld",(long)domain.status] family_uuid:domain.family_uuid uuid:domain.uuid];
}



#pragma mark - 创建下拉菊花
- (void)initHeaderRefresh
{
    _aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _aiv.size = CGSizeMake(30, 30);
    _aiv.origin = CGPointMake(APPWINDOWWIDTH / 2 - 15, APPSTATUSBARHEIGHT / 2);
    _aiv.hidden = YES;
    [_aiv stopAnimating];
    
    [self.navigationController.navigationBar addSubview:_aiv];
}

#pragma mark - 上啦下拉
- (void)setupRefresh
{

    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
   // [_tableView headerBeginRefreshing];
    
    
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.footerPullToRefreshText = @"上拉加载更多";
    _tableView.footerReleaseToRefreshText = @"松开立即加载";
    _tableView.footerRefreshingText = @"正在加载中...";
    
    
    
 
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    [self loadDataPhotoByFamilyUUID];
}

#pragma mark - 下拉刷新
- (void)headerRefreshing
{
    
    [self loadRemoteDataPhotoByFamilyUUIDAfterLocalTime];
    }
#pragma 表格-分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return dataSourceGroup.count;
}


#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(dataSourceGroup==0){
        return 1;
    }
    NSString * groupName=dataSourceGroup[section];
    if(groupName==nil) return nil;
    NSArray *arr=[dataSourceGroupChildMap objectForKey:groupName];
    NSInteger num= arr.count/3;
    if(arr.count%3>0){
        num++;
    }
    return num;
}




-(UIImageView *)createUIImageView:(FPFamilyPhotoNormalDomain *) domain rowCount:(NSInteger )rowCount index:(NSInteger) index{
    int perWidth=APPWINDOWWIDTH/rowCount-5;
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake((perWidth+5)*index, 0, perWidth, perWidth)];
    
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.imageBox addSubview:imgView];
    [imgView sd_setImageWithURL:[NSURL URLWithString:domain.path] placeholderImage:[UIImage imageNamed:@"waitImageDown"]  options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {}];
    
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickFPPhotoImage:)];
   
    [imgView addGestureRecognizer:singleTap1];
    return imgView;
    

}


-(void)onClickFPPhotoImage:(UITapGestureRecognizer *)recognizer
{  
    //获得事件的来源
    
    UIImageView *imgView = [recognizer view];
    
    
    NSString * groupName=dataSourceGroup[imgView.superview.tag];
    if(groupName==nil) return ;
    NSArray *arr=[dataSourceGroupChildMap objectForKey:groupName];
    if(arr==nil)return ;
    FPTimeLineDetailVC * vc = [[FPTimeLineDetailVC alloc] init];
    vc.fpPhotoNormalDomainArr=arr;
    vc.selectIndex=imgView.tag;
    vc.title=groupName;
    [self.navigationController pushViewController:vc animated:YES];
                           
    

    //do something
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(dataSourceGroup==0){
        NoDataTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTableViewCell" owner:nil options:nil] firstObject];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return cell;
    }

//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DF_cellIdentifier];
    
//    if (cell == nil)
//    {
//        
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DF_cellIdentifier];
//
//        
//    }else{
//        //移除所有子视图
//        [cell.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            UIView *subView = (UIView *)obj;
//            [subView removeFromSuperview];
//        }];
//    }
//    
     UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DF_cellIdentifier];
    

    //一列显示3个数据
    
    //NSIndexPath是一个对象，记录了组和行信息
    NSLog(@"生成单元格(组：%i,行%i)",indexPath.section,indexPath.row);
    NSString * groupName=dataSourceGroup[indexPath.section];
    if(groupName==nil) return nil;
    NSArray *arr=[dataSourceGroupChildMap objectForKey:groupName];
    NSInteger rowStartInd= indexPath.row*3;
    for (int i=0; i<3; i++) {
        int objInd=rowStartInd+i;
        if(objInd<arr.count){
            FPFamilyPhotoNormalDomain * domain=arr[objInd];
            UIImageView *imgView=[self createUIImageView:domain rowCount:(3) index:(i)];
            [cell addSubview:imgView];
            
            //用于点击图片事件，
            imgView.tag=objInd;
            imgView.superview.tag=indexPath.section;
        }
    }
//    CGRect  frame=cell.frame;
//    //frame.size.height=120;
//    NSLog(@"cell %ld frame=%f,%f,%f,%f",indexPath.row, frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    
    
    return cell;
}

#pragma 分组名。照片日期，和照片数量
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
       FPHomeTimeLineSectionHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DF_sectionHeaderIdentifier];
    
    if (cell == nil)
    {
        
//        cell = [[FPHomeTablePhotoCellTableViewCell alloc]initWithStyle:nil reuseIdentifier:DF_sectionHeaderIdentifier];
//
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeTimeLineSectionHeaderTableViewCell" owner:nil options:nil] firstObject];
        
        [cell initWithStyle:nil reuseIdentifier:DF_sectionHeaderIdentifier];
        
        
        NSLog(@"create section ,section=%ld",section);
    
        
    }
//    else{
//        //移除所有子视图
//        [cell.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            UIView *subView = (UIView *)obj;
//            [subView removeFromSuperview];
//        }];
//    }

    
    
    NSString * groupName=dataSourceGroup[section];
    if(groupName==nil) return nil;
    NSArray *arr=[dataSourceGroupChildMap objectForKey:groupName];
    [cell setDateAndCount:groupName total:arr.count];
    return cell;
}


- (void)clickGiftwareBtn{
    GiftwareListVC *vc=[[GiftwareListVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)fPPhotoItem_queryOfNewDataCount{
    localFamilyRangeTime=[_service queryTimeByFamilyUUID :[FPHomeVC getFamily_uuid]];
    if(localFamilyRangeTime.maxTime.length<1){
        return;
    }
    
    NSDictionary * dict = @{@"family_uuid":[FPHomeVC getFamily_uuid],@"maxTime":[KGDateUtil getQueryFormDateStringByString:localFamilyRangeTime.maxTime]};
    NSString * url=[NSString stringWithFormat:@"%@rest/fPPhotoItem/queryOfNewDataCount.json", [KGHttpUrl getBaseServiceURL]];
    
    [[KGHttpService sharedService] getByDicByParams:url param:dict success:^(id success) {
        NSDictionary * responseDic=success;
        ;
       
        NSNumber * newDataCount=[responseDic objectForKey:@"newDataCount"];
        NSInteger tmpCount=[newDataCount integerValue];
        NSLog(@"newDataCount=%ld",tmpCount);
        if(tmpCount>0){
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [fPHomeTopView.warningLbl setHidden:NO];
                               fPHomeTopView.warningLbl.text = @"有新照片,请下拉刷新";
                           });
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


@end

