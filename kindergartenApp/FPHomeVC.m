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
#import "FPCollectionVC.h"

#define NSUserDefaults_Key_FPMyFamilyPhotoCollection   @"FPMyFamilyPhotoCollection"      //用户偏好存储key

@interface FPHomeVC () <UITableViewDataSource,UITableViewDelegate,FPHomeSelectViewDelegate>
{
    
    //导航条下来数据内容
    NSMutableArray * _dataOfTopTitleBtnArray;
    //导航条下来数据内容,我的家庭相册列表
    NSArray * _dataOfmyCollectionArray;
    NSInteger  _PullDownMenu_myCollection_index;
    
    
    UITableView * _tableView;
    FPHomeSonView * sonView;
    //上传照片选择（上传照片，新建精品相册）
    FPHomeSelectView * selView;
    DBNetDaoService * _service;
    
//    FPMyFamilyPhotoCollectionDomain * _myCollectionDomain;
    
    NSMutableArray * _photoDatas;
    NSMutableArray * _timeDatas;
    
    CGFloat warningCellHeight;
    FPHomeWarningCell * _warningCell;
    
    BOOL _selectViewOpen;
    
    UIActivityIndicatorView * _aiv;
    
    NSInteger _pageNo;
}

@end

@implementation FPHomeVC
+(void) setFamily_uuid:(NSString *)str{
    family_uuid=str;
    //存沙盒
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:str forKey:NSUserDefaults_Key_FPMyFamilyPhotoCollection];
}
+(NSString *) getFamily_uuid{
    if(family_uuid==nil){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        family_uuid= [userDefaults objectForKey:NSUserDefaults_Key_FPMyFamilyPhotoCollection];

    }
    return family_uuid;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"FPHomeVC.viewDidAppear()");
    //选择自己喜欢的颜色
    UIColor * color = [UIColor clearColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataOfTopTitleBtnArray=[NSMutableArray array];

    _dataOfmyCollectionArray = [NSMutableArray array];
    _photoDatas = [NSMutableArray array];
    _timeDatas = [NSMutableArray array];
    _selectViewOpen = NO;
    _pageNo = 1;

    
    
    //创建服务类
    _service = [DBNetDaoService defaulService];
    
    //创建下拉刷新navbar 菊花框
    [self initHeaderRefresh];
    
    //获取我的家庭相册信息
    [self getMyPhotoCollectionInfo];
    
    [self createBarItems];
    //注册通知,用户提示用户有新数据需要更新啦
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(showUpDatePhotoDataView:) name:@"canUpDatePhotoData" object:nil];
    
    //用于从数据库获取数据
    [center addObserver:self selector:@selector(loadData) name:@"canLoadData" object:nil];
    [center addObserver:self selector:@selector(saveUploadImgPath:) name:@"saveuploadimg" object:nil];
    [center addObserver:self selector:@selector(headerRefreshing) name:@"refreshtimelinedata" object:nil];
    [center addObserver:self selector:@selector(showEndUpDatePhotoDataView:) name:@"updateInfo" object:nil];
    [center addObserver:self selector:@selector(reloadData) name:@"reloaddata" object:nil];
}

//切换家庭相册
- (void)changeMyCollection :(NSInteger)row
{
    FPMyFamilyPhotoCollectionDomain * domain=_dataOfmyCollectionArray[row];
    //设置全局保存
   [FPHomeVC setFamily_uuid:domain.uuid];
  

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
    
    for(FPMyFamilyPhotoCollectionDomain * domain in _dataOfmyCollectionArray){
        
        [_dataOfTopTitleBtnArray addObject:domain.title];
    }
    
//    if(_dataOfTopTitleBtnArray.count==0){
//        [_dataOfTopTitleBtnArray addObject:@"没有家庭相册"];
//    }
//    testArray = @[_dataOfTopTitleBtnArray];
//   _dropMenu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor redColor]];
//    _dropMenu.backgroundColor=[UIColor clearColor];
//    _dropMenu.delegate = self;
////    _dropMenu.set
//    NSLog(@"APPWINDOWWIDTH=%f",APPWINDOWWIDTH);
//    _dropMenu.frame = CGRectMake(
//                                 30,
//                                 0, APPWINDOWWIDTH, _dropMenu.frame.size.height);
//
    
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
    
    //[self.view addSubview:_dropMenu];
//      self.navigationItem.titleView = _dropMenu;
}
- (void)initTableView
{
    
    
    [self initNaviationTitleBtn];
    
   
  
    
    
    //自定义的headerview
    FPHomeTopView * view = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeTopView" owner:nil options:nil] firstObject];
    
    [view setData:[self getCurFPMyFamilyPhotoCollectionDomain]];
    view.size = CGSizeMake(APPWINDOWWIDTH, 192);
    //回调
    view.pushToMyAlbum = ^{
//        [self.navigationController pushViewController:nil animated:YES];
        NSLog(@"push到我的家庭相册");
    };
    
    
    //弄到tableviewheader里面去
    ParallaxHeaderView * headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:view];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableHeaderView:headerView];
    
    
    sonView = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeSonView" owner:nil options:nil] firstObject];
    __weak typeof(self) weakSelf = self;
    sonView.origin = CGPointMake(0, -132);
    //回调
    sonView.pushUpLoad = ^{
        [weakSelf.navigationController pushViewController:[[FPUploadVC alloc]init]  animated:YES];
    };
    sonView.pushCollege = ^{
        [weakSelf.navigationController pushViewController:[[FPCollectionVC alloc]init] animated:YES];
    };
    //家庭相册修改
    sonView.pushAlbunInfo = ^{
        [weakSelf.navigationController pushViewController:[[FPCollectionVC alloc]init] animated:YES];
    };
    
    sonView.origin = CGPointMake(0, -132);
    sonView.size = CGSizeMake(140, 132);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:sonView.bounds];
    sonView.layer.masksToBounds = NO;
    sonView.layer.shadowColor = [UIColor blackColor].CGColor;
    sonView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    sonView.layer.shadowOpacity = 0.5f;
    sonView.layer.shadowPath = shadowPath.CGPath;
    
    [self setupRefresh];
    
    [self.view addSubview:sonView];
    [self.view addSubview:_tableView];
}

#pragma mark UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
        
        sonView.origin = CGPointMake(0, -132);
        [sonView removeFromSuperview];
    }
}

#pragma mark - tableview D&D
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + _timeDatas.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FPHomeBtnCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeBtnCell" owner:nil options:nil] firstObject];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (_warningCell == nil)
        {
            _warningCell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeWarningCell" owner:nil options:nil] firstObject];
            
            _warningCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return _warningCell;
        }
        else
        {
            return _warningCell;
        }
    }
    else
    {
        static NSString * str = @"time_line_cell";
        
        FPHomeTimeLineCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeTimeLineCell" owner:nil options:nil] firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setDateAndCount:_timeDatas[indexPath.row - 1]];
        
        [cell setImgs:[self queryImgs:indexPath]];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 30;
    }
    else
    {
        return (APPWINDOWWIDTH - 20) + 30 + 10 + 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return;
    }
    
    FPTimeLineDetailVC * vc = [[FPTimeLineDetailVC alloc] init];
    
    //传递点击的日期过去
    vc.daytimeStr = _timeDatas[indexPath.row - 1];
    vc.familyUUID = [FPHomeVC getFamily_uuid];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 创建navBar items
- (void)createBarItems
{
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"new_album"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pushToUpLoadVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,27)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"btn_fp_home_more"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(showSonView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
   
}

- (void)pushToUpLoadVC
{
    
  //  if(_tableView==nil)return;
    if (_selectViewOpen == NO)
    {
        if (sonView)
        {
            [sonView removeFromSuperview];
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
       
      //  [self.view insertSubview:selView aboveSubview:_tableView];
       [self.view addSubview:selView];
        
        _selectViewOpen = YES;
    }else{
        if(selView)[self.view bringSubviewToFront:selView];
    }
}

- (void)showSonView
{
    [self.view addSubview:sonView];
    [UIView animateWithDuration:0.2 animations:^
    {
        if (sonView.origin.y == 0)
        {
            sonView.origin = CGPointMake(0, -132);
            [self.view bringSubviewToFront:sonView];
        }
        else
        {
            sonView.origin = CGPointMake(0, 0);
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
    
}

- (void)getPhotoDatas
{
    [_service getTimelinePhotos:[FPHomeVC getFamily_uuid]];
}

- (void)hidenSelf
{
    _selectViewOpen = NO;
    
    [selView removeFromSuperview];
}

#pragma mark - 通知 用于提示用户
- (void)showUpDatePhotoDataView:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        _warningCell.warningLbl.text = @"有新图片上传了,请下拉刷新";
    });
}

- (void)showEndUpDatePhotoDataView:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        _warningCell.warningLbl.text = [NSString stringWithFormat:@"最后更新时间:%@",noti.object];
    });
}

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
            
            for(FPMyFamilyPhotoCollectionDomain* v in datas){
                //没有初始化，则默认第一个。
                if([FPHomeVC getFamily_uuid]==nil){
                    [FPHomeVC setFamily_uuid:v.uuid];
                    isChageFailyUuid=false;
                    break;
                    
                }
                //包含全局uuid，则设置为初始化
                if([v.uuid isEqualToString:[FPHomeVC getFamily_uuid]]){
                     isChageFailyUuid=false;
                    break;
                }

            }
            //没设置则设置为第一个
            if(isChageFailyUuid&&_dataOfmyCollectionArray.count>0){
                FPMyFamilyPhotoCollectionDomain * tmp=_dataOfmyCollectionArray[0];
                  [FPHomeVC setFamily_uuid:tmp.uuid];
            }
            
            [self initTableView];
            [self getPhotoDatas];
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

#pragma mark - 获取数据库照片数据
- (void)loadData
{
    NSMutableArray * arr = [_service getListTimeHeadData:[FPHomeVC getFamily_uuid]];
    //反过来
    NSArray * dataArr = [[arr reverseObjectEnumerator] allObjects];
    
    [_timeDatas removeAllObjects];
    [_timeDatas addObjectsFromArray:dataArr];
    [_tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [_aiv stopAnimating];
    });
}

- (NSArray *)queryImgs:(NSIndexPath *)indexPath
{
    NSString * strs = _timeDatas[indexPath.row - 1];
    NSArray * imgs = [_service getListTimePhotoData:[[strs componentsSeparatedByString:@","] firstObject] familyUUID:[FPHomeVC getFamily_uuid]];
    [_photoDatas addObject:imgs];
    return imgs;
}

#pragma mark - 保存上传图片列表
- (void)saveUploadImgPath:(NSNotification *)noti
{
    FPUploadSaveUrlDomain * domain = noti.object;
    [_service saveUploadImgPath:domain.localUrl status:[NSString stringWithFormat:@"%ld",(long)domain.status] family_uuid:domain.family_uuid];
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
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.footerPullToRefreshText = @"上拉加载更多";
    _tableView.footerReleaseToRefreshText = @"松开立即加载";
    _tableView.footerRefreshingText = @"正在加载中...";
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    //1.去查询增量更新maxtime以后的数据并保存到本地,注意要更新时间
    //从数据库查询 familyUUID 所对应的 maxTime 和 minTime 如果没有相应数据 则自动创建一条，且把maxTime和minTime设置为空
    FPFamilyInfoDomain * domain = [_service queryTimeByFamilyUUID:[FPHomeVC getFamily_uuid]];
    
    [[KGHttpService sharedService] getPhotoCollectionUseFamilyUUID:[FPHomeVC getFamily_uuid] withTime:domain.maxTime timeType:0 pageNo:[NSString stringWithFormat:@"%ld",(long)_pageNo] success:^(FPFamilyPhotoLastTimeVO *lastTimeVO)
    {
        NSArray * datas = [FPFamilyPhotoNormalDomain objectArrayWithKeyValuesArray:lastTimeVO.data];
         
        if (datas.count == 0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                _tableView.footerRefreshingText = @"没有更多了...";
                [_tableView footerEndRefreshing];
            });
        }
        else
        {
            //把数据缓存到本地
            NSLog(@"缓存下拉加载的相片数据到数据库中");
            [_service addPhotoToDatabase:(datas)];
             
            //设置maxTime 和 minTime到这个familyUUID
            NSLog(@"%@ =更新time中=  %@ === %@",[KGDateUtil getLocalDateStr],lastTimeVO.lastTime,[KGDateUtil getLocalDateStr]);
            [_service updateMaxTime:[FPHomeVC getFamily_uuid] maxTime:[KGDateUtil getLocalDateStr] minTime:lastTimeVO.lastTime uptime:[KGDateUtil getLocalDateStr]];
             
            //2.去数据库里面查询
            [self loadData];
             
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [_tableView footerEndRefreshing];
            });
        }
    }
    faild:^(NSString *errorMsg)
    {
        [MBProgressHUD showError:@"请求超时,请稍后再试!"];
        [_tableView footerEndRefreshing];
    }];
}

#pragma mark - 下拉刷新
- (void)headerRefreshing
{
    if (![_aiv isAnimating])
    {
        _aiv.hidden = NO;
        [_aiv startAnimating];
        
        //1.去查询增量更新maxtime以后的数据并保存到本地,注意要更新时间
        //从数据库查询 familyUUID 所对应的 maxTime 和 minTime 如果没有相应数据 则自动创建一条，且把maxTime和minTime设置为空
        FPFamilyInfoDomain * domain = [_service queryTimeByFamilyUUID:[FPHomeVC getFamily_uuid]];
        
        [[KGHttpService sharedService] getPhotoCollectionUseFamilyUUID:[FPHomeVC getFamily_uuid] withTime:domain.maxTime timeType:0 pageNo:@"1" success:^(FPFamilyPhotoLastTimeVO *lastTimeVO)
        {
            NSArray * datas = [FPFamilyPhotoNormalDomain objectArrayWithKeyValuesArray:lastTimeVO.data];
            
            if (datas.count == 0)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                {
                    [_aiv stopAnimating];
                    _aiv.hidden = YES;
                    //更新刷新时间
                    _warningCell.warningLbl.text = _warningCell.warningLbl.text = [NSString stringWithFormat:@"最后更新时间:%@",[KGDateUtil getLocalDateStr]];
                });
            }
            else
            {
                //把数据缓存到本地
                NSLog(@"缓存下拉加载的相片数据到数据库中");
                [_service addPhotoToDatabase:(datas)];
                
                //设置maxTime 和 minTime到这个familyUUID
                NSLog(@"%@ =更新time中=  %@ === %@",[KGDateUtil getLocalDateStr],lastTimeVO.lastTime,[KGDateUtil getLocalDateStr]);
                [_service updateMaxTime:[FPHomeVC getFamily_uuid] maxTime:[KGDateUtil getLocalDateStr] minTime:lastTimeVO.lastTime uptime:[KGDateUtil getLocalDateStr]];
                
                //2.去数据库里面查询
                [self loadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                {
                    [_aiv stopAnimating];
                    _aiv.hidden = YES;
                    //更新刷新时间
                    _warningCell.warningLbl.text = _warningCell.warningLbl.text = [NSString stringWithFormat:@"最后更新时间:%@",[KGDateUtil getLocalDateStr]];
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

- (void)reloadData
{
    
}

@end
