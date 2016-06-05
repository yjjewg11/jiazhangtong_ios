//
//  EZCameraListViewController.m
//  kindergartenApp
//
//  Created by liumingquan on 16/6/1.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "EZCameraListViewController.h"
#import "MJRefresh.h"
#import "KGHttpService.h"
#import "AnnouncementDomain.h"
#import "SDImageCache.h"
#import "KGHttpService.h"
#import "MBProgressHUD+HM.h"
#import "KGHUD.h"

#import "PageInfoDomain.h"
#import "UIColor+Extension.h"
#import "GiftwareArticlesInfoViewController.h"
#import "GiftwareArticlesTableViewCell.h"
#import "NoDataTableViewCell.h"



@interface EZCameraListViewController () <UITableViewDataSource,UITableViewDelegate>
{

}


@property (assign, nonatomic) NSInteger pageNo;
@property (strong, nonatomic) NSString * currentTime;
@property (strong, nonatomic) UITableView * tableView;

@property (strong, nonatomic) NSMutableArray * dataSoure;

@end

@implementation EZCameraListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initEZOpenSDK];
    self.title = @"视频";
    [self initView];
    [self headerRereshing];
    
 NSString *accessToken=[GlobalMap objectForKey:GlobalMap_EZAccessToken];
  
   
    if(accessToken!=nil&&accessToken.length>0){
        [EZOpenSDK setAccessToken:accessToken];

    }else{
        [self setToken];
    }
}

- (id)initView{
    //    CGFloat y =  Main_Screen_Height/2-30;
    
    ////    CGRect frame = CGRectMake(0, 100, Main_Screen_Width,  Main_Screen_Height/2);
    //
    //    [self.view setBackgroundColor:[UIColor blueColor]] ;
    self.pageNo = 1;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64) ];
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.dataSoure=[NSMutableArray array];
    [self.tableView   setSeparatorColor:[UIColor    grayColor]];  //设置分割线为蓝色
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    
    
    //
    return self;
}

#pragma mark - 上拉下拉
- (void)setupRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableView.footerReleaseToRefreshText = @"松开立即加载";
    self.tableView.footerRefreshingText = @"正在加载中...";
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerRefreshingText = @"正在刷新中...";
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开立即刷新";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    self.pageNo=1;
    self.currentTime=nil;
    [self getData];
    
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    self.pageNo++;
    
    [self getData];
    
}

- (void)getData{
    if(self.pageNo==nil)self.pageNo=1;
    
    MBProgressHUD *hud=nil;
    if(self.pageNo==1){
        hud=[MBProgressHUD showMessage:@"加载中"];
        hud.removeFromSuperViewOnHide=YES;
       
    }
    NSString * url=[NSString stringWithFormat:@"%@rest/eZCamera/getCameraList.json", [KGHttpUrl getBaseServiceURL]];
    //请求最新domain
    [[KGHttpService sharedService] queryByPage:url pageNo:self.pageNo success:^(KGListBaseDomain *baseDomain) {
             if(hud!=nil) [hud hide:YES];
        if(self.pageNo==1){
       
            [self.tableView headerEndRefreshing];
        }
        if (baseDomain.list.data.count == 0)
        {
            self.tableView.footerRefreshingText = @"没有更多了...";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                           {
                               [self.tableView footerEndRefreshing];
                               
                           });
            return;
        }
        
        {
            [self.tableView footerEndRefreshing];
            if(self.pageNo==1){
                self.dataSoure=[NSMutableArray array];
            }
            
            
            [self.dataSoure addObjectsFromArray: [EZCamrea objectArrayWithKeyValuesArray:baseDomain.list.data]];
            
            [self.tableView reloadData];
        }
        
    } faild:^(NSString *errorMsg) {
        
             if(hud!=nil) [hud hide:YES];
        
        if(self.pageNo==1)[self.tableView headerEndRefreshing];
        [MBProgressHUD showError:errorMsg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [self.tableView footerEndRefreshing];
                       });
        
    } ];
    
    
}


- (void)initEZOpenSDK
{
//     static dispatch_once_t onceinitEZOpenSDK;
//    dispatch_once(&onceinitEZOpenSDK, ^{
//        //萤石开放平台SDK初始化
//        [EZOpenSDK initLibWithAppKey:@"44b89d0bea824201ad557c48f73635d9"];
//        
//        NSLog(@"EZOpenSDK initLibWithAppKey=44b89d0bea824201ad557c48f73635d9");
//    });
  
  
}

- (void)setToken{
  
    
    NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/eZCamera/getAccessToken.json"];
    
    [[KGHttpService sharedService] getNSDictionaryByURL:url success:^(NSDictionary *dic) {
        [self hidenLoadView];
        
        NSString *accessToken=[dic objectForKey:@"accessToken"];
        
      [GlobalMap setObject:accessToken forKey:GlobalMap_EZAccessToken];
        [EZOpenSDK setAccessToken:accessToken];
       
        
    } faild:^(NSString *errorMessage) {
        [self hidenLoadView];
        [MBProgressHUD showError:errorMessage];
    }];

}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if(indexPath.section == 0 && indexPath.row ==0)    return 44;
    return 220;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (section == 0)return 0;
    return 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    NSLog(@"self.dataSoure.count=%ld",[self.dataSoure count]);
    
    
    
    return [self.dataSoure count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.dataSoure.count == 0)
//    {
//        NoDataTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTableViewCell" owner:nil options:nil] firstObject];
//        
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        return cell;
//    }
//    else
    {
        static NSString * giftwareArticlesID = @"EzCameraTableViewCell";
        
        EzCameraTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:giftwareArticlesID];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EzCameraTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        [cell setDomainToView:self.dataSoure[indexPath.row]];
      
        
        return cell;
    }
}


#pragma mark - 选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZCamrea * domain = self.dataSoure[indexPath.row];
    
    
    
        UIStoryboard *ezMainStoryboard = [UIStoryboard storyboardWithName:@"EZMain" bundle:nil];
        //获取EZMain.storyboard的实例ViewController--获取摄像头列表
    
    EZLivePlayViewController * infoVC = [ezMainStoryboard instantiateViewControllerWithIdentifier:@"EZLivePlayViewControllerID"];
    //    //push摄像头列表的viewController
    //    [self.navigationController pushViewController:instanceVC animated:YES];
    
    
//    EZLivePlayViewController * infoVC = [[EZLivePlayViewController alloc] init];
    infoVC.cameraName=domain.cameraName;
    infoVC.cameraId=domain.cameraId;
   
    
    [self.navigationController pushViewController:infoVC animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
