//
//  FFMoiveEditMp3SelectedVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/8.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FFMoiveEditMp3SelectedVC.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "KGHttpService.h"
#import "MBProgressHUD+HM.h"
#import "KGHUD.h"
#import "KGDateUtil.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "BaseReplyDomain.h"
#import "ACMacros.h"
#import "UUInputFunctionView.h"
#import "KGEmojiManage.h"
#import "NoDataTableViewCell.h"
#import "UIButton+Extension.h"
#import "BaseReplyListTableViewCell.h"
#import "BaseReplyListHeaderView.h"
#import "Mp3Domain.h"
#import "FFMovieShareData.h"
#import "FFMoiveSubmitView.h"
#import "UIButton+Extension.h"
@interface FFMoiveEditMp3SelectedVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableViewCell * selectmaskView;
    
      FFMoiveSubmitView * _bottomView;
    UILabel *titlelb;
}

@property (assign, nonatomic) NSInteger pageNo;
@property (strong, nonatomic) NSString * currentTime;
@property (strong, nonatomic) UITableView * tableView;

@property (strong, nonatomic) NSMutableArray * dataSoure;

@end

@implementation FFMoiveEditMp3SelectedVC

#pragma mark - 创建下面确定view
- (void)createBottomView
{
    
    UIButton *_bottomViewBtn= [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.size.height-44-64, APPWINDOWWIDTH, 44)];
    
    
    [_bottomViewBtn setText:@"下一步"];
    
    _bottomViewBtn.titleLabel.font = [UIFont systemFontOfSize:APPUILABELFONTNO15];
    [_bottomViewBtn setTitleColor:[UIColor whiteColor ] forState:UIControlStateNormal];
    [_bottomViewBtn setBackgroundColor:[UIColor redColor]];
    _bottomViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [_bottomViewBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [_bottomView addSubview:dd];
    
    [self.view addSubview:_bottomViewBtn];
    
    
}
- (void)btnClick:(UIButton *)sender
{
    
    NSDictionary * dic = @{ @"nextIndex" : [NSNumber numberWithInteger:4]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_FFMoviewEditclickSubmitBysubView object:self userInfo:dic];
}

//
//#pragma mark - 创建下面确定view
//- (void)createBottomView
//{
//    
//    _bottomView=[FFMovieShareData createBottomView:self.view];
//    [self.view addSubview:_bottomView];
////    
////    _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"FFMoiveSubmitView" owner:nil options:nil] firstObject];
////    
////    
////    _bottomView.frame = CGRectMake(0, self.view.size.height-44-64, APPWINDOWWIDTH, 44);
////    _bottomView.titleLbl.text = @"4/4:下一步";
////    _bottomView.nextIndex=5-1;
////    _bottomView.submitBtn.titleLabel.text=@"预览";
////    _bottomView.doSubmitOkClick_action =^{
////        NSLog(@"ffff");
////        // segment
////        NSDictionary * dic = @{
////                               @"nextIndex" : [NSNumber numberWithInteger:_bottomView.nextIndex]};
////        
////        [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_FFMoviewEditclickSubmitBysubView object:self userInfo:dic];
////        
////        
////    };
////    [self.view addSubview:_bottomView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self headerRereshing];
    [self createBottomView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initView{
    //    CGFloat y =  Main_Screen_Height/2-30;
  
    ////    CGRect frame = CGRectMake(0, 100, Main_Screen_Width,  Main_Screen_Height/2);
    //
    [self.view setBackgroundColor:[UIColor blueColor]] ;
    self.pageNo = 1;
 
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-40-64) ];

  
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
      self.dataSoure=[NSMutableArray array];

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
    
    NSString * url=[NSString stringWithFormat:@"%@rest/mp3/query.json", [KGHttpUrl getBaseServiceURL]];
    //请求最新domain
    [[KGHttpService sharedService] queryByPage:url pageNo:self.pageNo success:^(KGListBaseDomain *baseDomain) {
    
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
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [self.tableView footerEndRefreshing];
                           if(self.pageNo==1){
                               self.dataSoure=[NSMutableArray array];
                           }
                           

                           [self.dataSoure addObjectsFromArray: [Mp3Domain objectArrayWithKeyValuesArray:baseDomain.list.data]];
        
                           [self.tableView reloadData];
                       });
        
    } faild:^(NSString *errorMsg) {
        if(self.pageNo==1)[self.tableView headerEndRefreshing];
        [MBProgressHUD showError:errorMsg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [self.tableView footerEndRefreshing];
                       });
    
    } ];
    
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if(indexPath.section == 0 && indexPath.row ==0)    return 44;
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0)return 0;
    return 44;
}

//设置选中的标题到头。
-(void)setHeaderTitle:(NSString *) title{
    if(titlelb==nil){
        titlelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        titlelb.text=@"请选择";
        [titlelb setTextAlignment:NSTextAlignmentCenter];
    }
    
    if(titlelb!=nil){
        
        titlelb.text=[NSString stringWithFormat:@"已选择:%@",title ];
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // 设置表视图的头部视图(headView 添加子视图)
    UIView *headerView =  [[UIView alloc]init];
    [headerView setBackgroundColor:[UIColor grayColor]];
    if(titlelb==nil){
        titlelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        titlelb.text=@"请选择";
        [titlelb setTextAlignment:NSTextAlignmentCenter];
    }
   
    [headerView addSubview:titlelb];
    
    　//秀发，不可见的数据，没触法设置herader方法ßßßååß
    for( Mp3Domain * domain in self.dataSoure){
        if([[FFMovieShareData getFFMovieShareData].domain.mp3 isEqualToString:domain.path]){
            
            [self setHeaderTitle:domain.title];
            
        }

    }
    
    return headerView;
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
    
    //由于此方法调用十分频繁，cell的标示声明成静态变量有利于性能优化
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    //首先根据标识去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    如果缓存池没有到则重新创建并放到缓存池中
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
//    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil]   ;
    if(self.dataSoure==nil){
        self.dataSoure=[NSMutableArray array];
    }

    Mp3Domain * domain= self.dataSoure[indexPath.row];
    cell.textLabel.text=domain.title;
    
   // cell.textLabel.textColor=[UIColor blueColor];
//    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
      [cell setAccessoryType:UITableViewCellAccessoryNone];
    if([[FFMovieShareData getFFMovieShareData].domain.mp3 isEqualToString:domain.path]){
        
        [self setHeaderTitle:domain.title];

        [self setViewCellSelectd:cell];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     Mp3Domain * domain= self.dataSoure[indexPath.row];
    [self setSelectedFPMoive4QDomain_mp3:domain.path];
   
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void) setViewCellSelectd:(UITableViewCell *) cell{
    
    
    if(selectmaskView!=nil){
        [selectmaskView setAccessoryType:UITableViewCellAccessoryNone];
    }
    
//    cell.textLabel.textColor=[UIColor blueColor];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        selectmaskView=cell;
    
}


- (void)setSelectedFPMoive4QDomain_mp3:(NSString *) mp3{
    FPMoive4QDomain * domain=[FFMovieShareData getFFMovieShareData].domain;

    domain.mp3=mp3;
    
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
