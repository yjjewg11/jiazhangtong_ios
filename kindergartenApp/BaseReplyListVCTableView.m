//
//  BaseReplyListVCTableViewController.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/1.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseReplyListVCTableView.h"
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
@interface BaseReplyListVCTableView ()<UITableViewDataSource,UITableViewDelegate,UUInputFunctionViewDelegate,BaseReplyListDataSoruceDelegate>{
    UUInputFunctionView *IFView;
}


@property (assign, nonatomic) NSInteger pageNo;
@property (strong, nonatomic) NSString * currentTime;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) IBOutlet UIButton *replyBtn;
@property (strong, nonatomic) NSMutableArray * dataSoure;

@end


@implementation BaseReplyListVCTableView

- (void)setBaseReplyData:(NSString *)rel_uuid type:(KGTopicType)type{
    self.rel_uuid=rel_uuid;
    self.type=type;
   
    [self headerRereshing];
    
}

- (id)initWithSuperVC:(UIViewController *)superVC {
    self.superVC=superVC;
//    CGFloat y =  Main_Screen_Height/2-30;
    CGRect frame = CGRectMake(0,  0, superVC.view.frame.size.width, superVC.view.frame.size.height);
////    CGRect frame = CGRectMake(0, 100, Main_Screen_Width,  Main_Screen_Height/2);
//    

//
    self = [super initWithFrame:frame];
    self.pageNo = 1;
    //
//      CGRect frameTable = CGRectMake(0, 0, Main_Screen_Width, frame.size.height-30);
//    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-40) ];

  //  self.tableView.rowHeight = 70;    // 默认44px
  //  self.tableView.height=self.height-50;
    
       self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    self.backgroundColor=[UIColor redColor];
    
    
    
   
//    _tableView.tableHeaderView = headerView; //设置头部
    _tableView.estimatedRowHeight = 110;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];//设置列表边框
    self.tableView.separatorColor = [UIColor redColor];//设置行间隔边框
    
    [self addSubview:self.tableView];
    [self setupRefresh];
    
    
    //
    [self loadInputBtn];

    return self;
}

- (void)click_CloseBtn:(UITapGestureRecognizer *)tap {
   
    if (tap.state == UIGestureRecognizerStateEnded){
            [self setHidden:YES];
    }

}
//加载底部输入功能View
- (void)loadInputBtn {
    
    _replyBtn= [[UIButton alloc] initWithFrame:CGRectMake(0,self.frame.size.height-40,self.frame.size.width,40)];
    
    CGRect frame = _replyBtn.frame;
    ////    CGRect frame = CGRectMake(0, 100, Main_Screen_Width,  Main_Screen_Height/2);
    //

    [_replyBtn setText:@"写下您的评论..."];
    _replyBtn.titleLabel.font = [UIFont systemFontOfSize:APPUILABELFONTNO12];
    [_replyBtn setTextColor:[UIColor grayColor] sel:[UIColor grayColor]];
    _replyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _replyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _replyBtn.layer.borderWidth = 1;
    _replyBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    [_replyBtn addTarget:self action:@selector(click_replyBtn) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_replyBtn];
    
    
    
    
}
#pragma mark - 上拉下拉
- (void)click_replyBtn
{
 
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_BeginBaseReplyInput object:self userInfo:nil];
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
  
    [self baseReply_queryByRel_uuid];
    
}

#pragma mark 开始进入刷新状态
- (void)footerRereshing
{
    self.pageNo++;
    [self baseReply_queryByRel_uuid];
    
}

-(void)baseReply_queryByRel_uuid
{
    if(self.rel_uuid==nil){
          [MBProgressHUD showError:@"rel_uuid==nil"];
        return;
    }
    if(self.type==nil){
        [MBProgressHUD showError:@"type==nil"];
        return;
    }
    
    
    if(self.pageNo==nil)self.pageNo=1;
    if(self.currentTime==nil)self.currentTime=[KGDateUtil getQueryFormDateStringByDate:[KGDateUtil getLocalDate]];
    
    
    
    
    [[KGHttpService sharedService] baseReply_queryByRel_uuid:self.rel_uuid type:self.type pageNo:[NSString stringWithFormat:@"%ld",self.pageNo] time:self.currentTime  success:^(PageInfoDomain * pageInfoDomain)
     {
         
         if(self.pageNo==1){
              [self.tableView headerEndRefreshing];
             self.dataSoure=[NSMutableArray array];
             
             
         }

         
         NSArray * arr = [BaseReplyDomain objectArrayWithKeyValuesArray:pageInfoDomain.data];

         if (arr.count == 0)
         {
             
             self.tableView.footerRefreshingText = @"没有更多了...";
             [self.tableView reloadData];
            
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                            {
                                [self.tableView footerEndRefreshing];
                               
                            });
             return;
         }

         
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                        {
                            

                            [self.tableView footerEndRefreshing];
                        
                            [self.dataSoure addObjectsFromArray:arr];
                            [self.tableView reloadData];
                        });
         
         
     }
      faild:^(NSString *errorMsg)
     {
          if(self.pageNo==1)[self.tableView headerEndRefreshing];
         [MBProgressHUD showError:@"获取评论列表失败!"];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                        {
                            [self.tableView footerEndRefreshing];
                        });
     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSoure.count == 0)
    {
   
        return 204;
    }else{
     //  return  78;
    }
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    // 這裏返回需要的高度

    return cell.frame.size.height+25;
//
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    NSLog(@"self.dataSoure.count=%ld",[self.dataSoure count]);
    if (self.dataSoure==nil)return 0;

    if (self.dataSoure.count == 0)
    {
        return 1;
    }

    
    return [self.dataSoure count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (self.dataSoure.count == 0)
    {
        
       
        NoDataTableViewCell * cell1 = [[[NSBundle mainBundle] loadNibNamed:@"NoDataTableViewCell" owner:nil options:nil] firstObject];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return cell1;
    }
     static NSString *reuse=@"BaseReplyListTableViewCell";
    BaseReplyListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:reuse];
    if(cell==nil){
      cell= [[[NSBundle mainBundle] loadNibNamed:@"BaseReplyListTableViewCell" owner:nil options:nil] firstObject];
       
    }
    cell.delegate=self;
    
//    CGRect frame = cell.frame;
//    NSLog(@"frame=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    

    [cell resetValue:self.dataSoure[indexPath.row] parame:nil];
    
//    frame = cell.frame;
//    NSLog(@"frame3=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
//    


    
    return cell;
}
#pragma mark - tableview D&D
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // 设置表视图的头部视图(headView 添加子视图)
    BaseReplyListHeaderView *headerView =  [[[NSBundle mainBundle] loadNibNamed:@"BaseReplyListHeaderView" owner:nil options:nil] firstObject];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click_CloseBtn:)];
    
    [headerView addGestureRecognizer:tap];
    
    return headerView;
}

#pragma BaseReplyListDataSoruceDelegate
//取消点赞
- (void)baseReply_delete:(NSString *)newsuid   {
    [[KGHUD sharedHud] show:self.superVC.view];
    
    [[KGHttpService sharedService] baseReply_delete:newsuid type:self.type success:^(NSString *msgStr)
     {
         [[KGHUD sharedHud] show:self.superVC.view onlyMsg:msgStr];
         
         [self headerRereshing];
         
     } faild:^(NSString *errorMsg) {
         [[KGHUD sharedHud] show:self.superVC.view onlyMsg:errorMsg];
         
     }];
}




@end
