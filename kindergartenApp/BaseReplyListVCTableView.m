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

@interface BaseReplyListVCTableView ()<UITableViewDataSource,UITableViewDelegate,UUInputFunctionViewDelegate>{
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
    
//    CGFloat y =  Main_Screen_Height/2-30;
    CGRect frame = CGRectMake(0,  0, superVC.view.frame.size.width, superVC.view.frame.size.height);
////    CGRect frame = CGRectMake(0, 100, Main_Screen_Width,  Main_Screen_Height/2);
//    
    NSLog(@"frame=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
//
    self = [super initWithFrame:frame];
    self.pageNo = 1;
    //
//      CGRect frameTable = CGRectMake(0, 0, Main_Screen_Width, frame.size.height-30);
//    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-40) ];
    NSLog(@"self.tableView.h=%f",self.frame.size.height-40);
  //  self.tableView.rowHeight = 70;    // 默认44px
  //  self.tableView.height=self.height-50;
    
       self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    self.backgroundColor=[UIColor redColor];
    
    
    
    // 设置表视图的头部视图(headView 添加子视图)
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor redColor];
    
    
    UIButton *closeBtn= [[UIButton alloc] initWithFrame:headerView.frame];
    
    ////    CGRect frame = CGRectMake(0, 100, Main_Screen_Width,  Main_Screen_Height/2);
    //

    [closeBtn setText:@"评论列表"];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:APPUILABELFONTNO18];
    [closeBtn setTextColor:[UIColor grayColor] sel:[UIColor redColor]];

    [closeBtn addTarget:self action:@selector(click_CloseBtn) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加子视图
//    UILabel *headText = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.frame.size.width, 40)];
//    headText.text = @"评论列表";
//    headText.numberOfLines = 0;
    [headerView addSubview:closeBtn];
    _tableView.tableHeaderView = headerView; //设置头部
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
- (void)click_CloseBtn {
    [self setHidden:YES];
}
//加载底部输入功能View
- (void)loadInputBtn {
    
    _replyBtn= [[UIButton alloc] initWithFrame:CGRectMake(0,self.frame.size.height-40,self.frame.size.width,40)];
    
    CGRect frame = _replyBtn.frame;
    ////    CGRect frame = CGRectMake(0, 100, Main_Screen_Width,  Main_Screen_Height/2);
    //
    NSLog(@"loadInputBtn.frame=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
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
    self.dataSoure=nil;
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
    
    
    if(self.dataSoure==nil)self.dataSoure=[NSMutableArray array];

    [[KGHttpService sharedService] baseReply_queryByRel_uuid:self.rel_uuid type:self.type pageNo:[NSString stringWithFormat:@"%ld",self.pageNo] time:self.currentTime  success:^(PageInfoDomain * pageInfoDomain)
     {
         
         NSArray * arr = [BaseReplyDomain objectArrayWithKeyValuesArray:pageInfoDomain.data];
 if(self.pageNo==1)[self.tableView headerEndRefreshing];
         
         if (arr.count == 0)
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

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSoure.count == 0)
    {
   
        return 204;
    }
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    // 這裏返回需要的高度
//    NSLog(@"height1=%f",cell.frame.size.height);
//    return cell.frame.size.height;
//    
    
    int row = [indexPath row];
    // 列寬
    CGFloat contentWidth = self.frame.size.width;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:14];
    // 該行要顯示的內容
    BaseReplyDomain *domain = [self.dataSoure objectAtIndex:row];
    
    NSString *content =domain.content;
    
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    
    // 這裏返回需要的高度
    NSLog(@"height=%f",size.height+54);
    
    return size.height+54;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    NSLog(@"self.dataSoure.count=%ld",[self.dataSoure count]);
    
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
     static NSString *reuse=@"BaseReplyUITableViewCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:reuse];
    if(cell==nil){
       
         cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
        cell.backgroundColor=[UIColor  greenColor];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    BaseReplyDomain *domain=self.dataSoure[indexPath.row];
    
    

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:domain.create_img ] placeholderImage:[UIImage imageNamed:@"waitImageDown"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
//         NSLog(@"t=%@,domain.create_img=%@",domain.content,domain.create_img);
     }];

    cell.textLabel.text=domain.create_user;
    //自动换行，这里最重要
   cell.detailTextLabel.numberOfLines = 0;
  
    

//    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap; //如何换行
    //Cell中的小箭头
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//      [cell.detailTextLabel setNumberOfLines:3];//可以显示3行
    cell.detailTextLabel.text=domain.content;
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:1 alpha:1]];
    }else {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    [cell setBorderWithWidth:10 color:[UIColor redColor]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    
    CGRect  frame=cell.frame;
    //frame.size.height=120;
    NSLog(@"cell %ld frame=%f,%f,%f,%f",indexPath.row, frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    
    //    frame.origin.y=(indexPath.row+1)*frame.size.height;
    // [cell setFrame:frame];
    frame=cell.contentView.frame;
    NSLog(@"contentView %ld frame=%f,%f,%f,%f",indexPath.row, frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);

    
    return cell;
}
#pragma mark - tableview D&D
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
#pragma loadInputFuniView
//加载底部输入功能View
- (void)loadInputFuniView {
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self.superVC isShow:YES];
    IFView.delegate = self;
    
    CGRect  frame=IFView.frame;
    frame.origin.y=self.frame.size.height-40-64;
  //  frame.size.height=120;
    NSLog(@"cell frame=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);

    [IFView setFrame:frame];
    [self addSubview:IFView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
  
    
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
//    if (notification.name == UIKeyboardWillShowNotification) {
//        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
//    }else{
//        self.bottomConstraint.constant = 40;
//    }
    
//    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y =  keyboardEndFrame.origin.y - newFrame.size.height ;
    
    CGRect frame=newFrame;
    NSLog(@"frame=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
   // IFView.frame = newFrame;
    [self setFrame:newFrame];
    [UIView commitAnimations];
    
}
#pragma mark - InputFunctionViewDelegate
//delete
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    
    funcView.TextViewInput.text = @"";

    BaseReplyDomain *domain =[[BaseReplyDomain alloc]init];
    domain.rel_uuid=self.rel_uuid;
    domain.type=self.type;
    domain.content=message;
    [[KGHttpService sharedService]  baseReply_save:domain success:^(NSString *msgStr) {
        [self headerRereshing];
    }faild:^(NSString *errorMsg) {
        [MBProgressHUD showError:@"获取评论列表失败!"];

    }];
    
   }


@end
