//
//  FPTimeLineDetailCell.m
//  kindergartenApp
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPTimeLineDetailCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "KGHttpService.h"
#import "MBProgressHUD+HM.h"
#import "FPTimeLineCommentCell.h"
#import "KGDateUtil.h"
#import "SPBottomItem.h"
#import "EYPopupViewHeader.h"
#import "KGHUD.h"
#import "HLActionSheet.h"
#import "UMSocial.h"
#import "FPTimeLineDetailMoreView.h"
#import "FPTimeLineDZDomain.h"
#import "CommitHeaderView.h"
#import "CommitTextFild.h"
#import "MJRefresh.h"
#import "FPFamilyPhotoNormalDomain.h"
#import "MJExtension.h"

#import "UIButton+Extension.h"

#import <objc/runtime.h>

@interface FPTimeLineDetailCell() <UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,FPTimeLineDetailMoreViewDelegate>
{
    NSMutableArray * _buttonItems;
    FPTimeLineDetailMoreView * _moreView;
    BOOL _moreViewOpen;
    BOOL _isCommit;
    BOOL _isFirstCommit;
    BOOL _useTF;
    UIButton * _completeBtn;
    NSInteger pageNum;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView * infoView;
@property (strong, nonatomic) UILabel * timeLbl;
@property (strong, nonatomic) UILabel * locationLbl;
@property (strong, nonatomic) UILabel * deviceLbl;
@property (strong, nonatomic) UILabel * nameLbl;

@property (strong, nonatomic) CommitTextFild * commitTextFD;
@property (strong, nonatomic) UIImageView * imageView;

@property (strong, nonatomic) UIView * sepView;

@property (strong, nonatomic) UITableView * commentTableView;

@property (assign, nonatomic) NSInteger pageNo;
@property (strong, nonatomic) NSString * currentTime;
//评论数据数组
@property (strong, nonatomic) NSMutableArray * dataArr;

@property (strong, nonatomic) FPFamilyPhotoNormalDomain * domain;

//当前照片在数据的序号
@property  NSInteger indexOfDomain;

//照片数组
@property (strong, nonatomic) NSMutableArray * dataArrOfDomain;
//照片url数组
@property (strong, nonatomic) NSMutableArray * imgUrlArray;


@property (weak, nonatomic) IBOutlet UIView * bottomView;

@property (nonatomic, strong)UILabel *imageDetailLable;

@end

@implementation FPTimeLineDetailCell

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil)
    {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)awakeFromNib
{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    _moreViewOpen = NO;
    self.pageNo = 1;
    
    
    
    //创建imageView
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, 500)];
    
    self.imageView .tag = [self indexOfDomain];
     self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullImgClicked:)];
    
    [ self.imageView addGestureRecognizer:singleTap1];

    
    [self.scrollView addSubview:self.imageView];
    
    //创建image描述的Lable
    self.imageDetailLable = [[UILabel alloc] init];
  
    self.imageDetailLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.imageDetailLable.numberOfLines = 0;
    self.imageDetailLable.textColor = [UIColor whiteColor];
    self.imageDetailLable.font = [UIFont systemFontOfSize:17];
    self.imageDetailLable.text = @"today is a fun day";
    //创建infoview
    self.infoView = [[UIView alloc] init];
    self.infoView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+5, APPWINDOWWIDTH, 280);
    NSLog(@"infoView y=%f",CGRectGetMaxY(self.imageView.frame));
    
      [self.imageView addSubview:self.imageDetailLable];
    
    
    self.timeLbl = [[UILabel alloc] init];
    self.timeLbl.frame = CGRectMake(20, 20, APPWINDOWWIDTH-20, 20);
    self.timeLbl.textColor = [UIColor brownColor];
    self.timeLbl.font = [UIFont systemFontOfSize:17];
    [self.infoView addSubview:self.timeLbl];
    
    self.locationLbl = [[UILabel alloc] init];
    self.locationLbl.frame = CGRectMake(20, 60, APPWINDOWWIDTH-20, 20);
    self.locationLbl.textColor = [UIColor brownColor];
    self.locationLbl.font = [UIFont systemFontOfSize:17];
    [self.infoView addSubview:self.locationLbl];
    
    self.deviceLbl = [[UILabel alloc] init];
    self.deviceLbl.frame = CGRectMake(20, 100, APPWINDOWWIDTH-20, 20);
    self.deviceLbl.textColor = [UIColor brownColor];
    self.deviceLbl.font = [UIFont systemFontOfSize:17];
    [self.infoView addSubview:self.deviceLbl];
    
    self.nameLbl = [[UILabel alloc] init];
    self.nameLbl.frame = CGRectMake(20, 140, APPWINDOWWIDTH-20, 20);
    self.nameLbl.textColor = [UIColor brownColor];
    self.nameLbl.font = [UIFont systemFontOfSize:17];
    [self.infoView addSubview:self.nameLbl];

    //添加到scrollview
    self.scrollView.showsVerticalScrollIndicator = YES;
    
    [self.scrollView addSubview:self.infoView];
    [self.scrollView setContentSize:CGSizeMake(0,CGRectGetMaxY(self.infoView.frame))];
    
    //创建底部按钮
    [self addBtn:self.bottomView];
    
    _moreView = [[[NSBundle mainBundle] loadNibNamed:@"FPTimeLineDetailMoreView" owner:nil options:nil] firstObject];
    _moreView.delegate = self;
    [_moreView setOrigin:CGPointMake(APPWINDOWWIDTH - 44, APPWINDOWHEIGHT)];
    [self addSubview:_moreView];
    [self bringSubviewToFront:self.bottomView];
    
    
    self.commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, APPWINDOWHEIGHT, APPWINDOWWIDTH, (APPWINDOWHEIGHT) / 2)];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.rowHeight = 80;
    self.commentTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self setupRefresh];
    
    
    
}

//根据数据数组，转成url 数组。
-(NSMutableArray *)getImgUrlArray{
    
    
    if(_imgUrlArray){
        return _imgUrlArray;
    }
    _imgUrlArray =[NSMutableArray array];
    for(NSObject * obj in _dataArrOfDomain){
        NSString * path=nil;
        if([obj isKindOfClass:[FPFamilyPhotoNormalDomain class]]){
           FPFamilyPhotoNormalDomain * tmp=obj;
            path=tmp.path;
        }else if([obj isKindOfClass:[NSMutableDictionary class]]){
            NSMutableDictionary * tmp=obj;
            path=[tmp objectForKey:@"path"];

        }
        if(path){
            path=[[path componentsSeparatedByString:@"@"] firstObject];
               [_imgUrlArray addObject:path];
        }
        
     
    }
    return _imgUrlArray;
 }


- (void)showFullImgClicked:(UITapGestureRecognizer *)recognizer

{
    
    //获得事件的来源
    
    UIImageView *imgView = [recognizer view];
    

    NSDictionary * dic = @{Key_ImagesArray : [self getImgUrlArray], Key_Tag : [NSNumber numberWithInteger:imgView.tag]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_BrowseImages object:self userInfo:dic];
}
- (void)getDZData
{
    
    [[KGHttpService sharedService] getFPItemExtraInfo:self.domain.uuid success:^(FPTimeLineDZDomain *needUpDateDatas)
     {
         if (needUpDateDatas)
         {
             if(needUpDateDatas.yidianzan == 1)
             {
                 SPBottomItem * item = _buttonItems[2];
                 item.imgView.image = [UIImage imageNamed:@"fp_dz2"];
                 item.btn.selected = YES;
             }
             else
             {
                 SPBottomItem * item = _buttonItems[2];
                 item.imgView.image = [UIImage imageNamed:@"fp_dz"];
                 item.btn.selected = NO;
             }
             
             if(needUpDateDatas.isFavor == 0)
             {
                 SPBottomItem * item = _buttonItems[0];
                 item.imgView.image = [UIImage imageNamed:@"fp_shoucang2"];
                 item.btn.selected = YES;
             }
             else
             {
                 SPBottomItem * item = _buttonItems[0];
                 item.imgView.image = [UIImage imageNamed:@"newshoucang1"];
                 item.btn.selected = NO;
             }
         }
     } faild:^(NSString *errorMsg)
     {
         [MBProgressHUD showError:@"获取收藏信息失败!"];
     }];
}

- (void)resetData:(BOOL)hideInfoView
{
    self.scrollView.hidden = YES;
    
    self.imageView .tag = [self indexOfDomain];
    NSLog(@" self.imageView .tag=%d", self.imageView .tag);
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.domain.path ] placeholderImage:[UIImage imageNamed:@"waitImageDown"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         NSLog(@"self.domain.path=%@",self.domain.path);
     }];
    
    
    self.timeLbl.text = [NSString stringWithFormat:@"拍摄时间:%@",self.domain.photo_time];
    self.locationLbl.text = [NSString stringWithFormat:@"位置:%@",self.domain.address];
    self.deviceLbl.text = [NSString stringWithFormat:@"设备:%@",self.domain.phone_type];
    self.nameLbl.text = [NSString stringWithFormat:@"上传人:%@",self.domain.create_user];
    
    self.imageDetailLable.text=self.domain.note;
    if(self.imageDetailLable.text){
        [self.imageDetailLable setHidden:NO];
    }else{
         [self.imageDetailLable setHidden:YES];
    }
    [self showByHideInfoView:hideInfoView];
    
    //请求点赞数据
    [self getDZData];
    
    
    [self calImageViewHeight:self.domain success:^(CGFloat height)
    {
        
        
        NSLog(@"self.imageView.height1=%f",self.imageView.height);
         //设置图片、图片高度
         self.imageView.height = height;
        
        
        NSLog(@"self.imageView.height2=%f",self.imageView.height);
        self.imageDetailLable.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) - 44, APPWINDOWWIDTH, 44);
        
         [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[self.domain.path componentsSeparatedByString:@"@"] firstObject]]];
        
        [self showByHideInfoView:hideInfoView];
     }
     faild:^(NSString *errorMsg)
     {
         //按照一个大小设置imageView
     }];
}
//不在使用
- (void)showByHideInfoView:(BOOL)hideInfoView
{
    
            [self.infoView setOrigin:CGPointMake(0, CGRectGetMaxY(self.imageView.frame))];
    
  //  return;
//    
//    if (hideInfoView == NO)
//    {
//        //显示infoview
//        [self.infoView setOrigin:CGPointMake(0, 0)];
//        [self.imageView setOrigin:CGPointMake(0, CGRectGetMaxY(self.infoView.frame))];
//    }
//    else
//    {
//        //隐藏infoview
//        [self.infoView setOrigin:CGPointMake(0, -180)];
//        [self.imageView setOrigin:CGPointMake(0, CGRectGetMaxY(self.infoView.frame))];
//    }
    
//    [self.scrollView setContentSize:CGSizeMake(0,CGRectGetMaxY(self.imageView.frame)+49)];
//    
    self.scrollView.hidden = NO;
}
- (void)setDataByMap:(id) map  indexOfDomain:(NSInteger)indexOfDomain dataArray :(NSArray*) dataArray
{
    
    FPFamilyPhotoNormalDomain * tmp = [FPFamilyPhotoNormalDomain objectWithKeyValues:map];
    
    [self setData:tmp indexOfDomain:indexOfDomain dataArray:dataArray];
    
    
}

- (void)setData:(FPFamilyPhotoNormalDomain *)domain indexOfDomain:(NSInteger)indexOfDomain dataArray :(NSArray*) dataArray
{
    _dataArrOfDomain=dataArray;
    [self setIndexOfDomain:indexOfDomain];
    
    if ([domain.status isEqualToString:@"1"]) //需要修改的domain
    {
        [MBProgressHUD showMessage:@"请稍后..."];
        //请求最新domain
        [[KGHttpService sharedService] getFPTimeLineItem:domain.uuid success:^(FPFamilyPhotoNormalDomain *item)
        {
            [MBProgressHUD hideHUD];
            self.domain = item;
            
            [self resetData:true];
            
        }
        faild:^(NSString *errorMsg)
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"获取最新相片信息失败!"];
            self.domain = domain;
        }];
    }
    else
    {
        self.domain = domain;
        
        [self resetData:true];
    }
}

- (void)calImageViewHeight:(FPFamilyPhotoNormalDomain *)domain success:(void(^)(CGFloat height))success faild:(void(^)(NSString * errorMsg))faild
{
    NSString * path = [[domain.path componentsSeparatedByString:@"@"] firstObject];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:path] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
    {
        
    }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
         if (error)
         {
             NSLog(@"%@",error.debugDescription);
         }
         if (image)
         {
             [[SDImageCache sharedImageCache] storeImage:image forKey:[[domain.path componentsSeparatedByString:@"@"] firstObject] toDisk:YES];
             
             CGFloat imgW = image.size.width;
             CGFloat imgH = image.size.height;
             
             //计算宽度压缩了还是拉伸了
             CGFloat widthBiZhi = (APPWINDOWWIDTH) / imgW;
             if (widthBiZhi >= 1) //直接按照这个比例设定imageview的高度,也就是图片本身的imgH
             {
                 success(imgH);
             }
             else //高度按照这个比例相应缩小
             {
                 success(imgH * widthBiZhi);
             }
         }
    }];
}

- (void)getCommentData:(NSString *)uuid
{
    [[KGHttpService sharedService] getFPItemCommentList:uuid pageNo:[NSString stringWithFormat:@"%ld",(long)_pageNo] time:self.currentTime success:^(NSArray *arr)
    {
        [self.dataArr addObjectsFromArray:arr];
        self.commentTableView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 10, APPWINDOWWIDTH, 80 * self.dataArr.count);
        [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.commentTableView.frame)+49)];
        [self.commentTableView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        [MBProgressHUD showError:@"获取评论列表失败!"];
    }];
}

#pragma mark - 创建底部按钮
- (void)addBtn:(UIView *)view
{
    _buttonItems = [NSMutableArray array];
    
    int totalloc = 5;
    CGFloat spcoursew = 80;
    CGFloat spcourseh = 48;
    CGFloat margin = (KGSCREEN.size.width - totalloc * spcoursew) / (totalloc + 1);

    NSArray * imageName = @[@"newshoucang1",@"fp_hudong",@"fp_dz",@"fp_fenxiang",@"fp_more"];
    NSArray * titleName = @[@"收藏",@"评论",@"点赞",@"分享",@"更多"];
    
    for (NSInteger i = 0; i < 5; i++)
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
        
        [self.bottomView addSubview:item];
    }
    
    UIView * sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, 1)];
    sepView.backgroundColor = [UIColor lightGrayColor];
    sepView.alpha = 0.5;
    [self.bottomView addSubview:sepView];
}

#pragma mark - tableview D&D
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count == 0)
    {
        UITableViewCell * newCell = [[UITableViewCell alloc]init];
        return newCell;
    }
    
    static NSString * cellid = @"comment_id";
    
    FPTimeLineCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FPTimeLineCommentCell" owner:nil options:nil] firstObject];
    }
    
    [cell setData:self.dataArr[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CommitHeaderView * headerView = [[[NSBundle mainBundle] loadNibNamed:@"CommitHeaderView" owner:nil options:nil] firstObject];
    return headerView;
}
#pragma mark - 下面按钮点击
- (void)bottomBtnClicked:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 0:
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
        case 1:
        {
            if (_isFirstCommit == NO)
            {
                __weak typeof(self) weakSelf = self;
                
                [[KGHttpService sharedService] getFPItemCommentList:self.domain.uuid pageNo:@"1" time:[KGDateUtil getFPFormatSringWithDate:[NSDate date]] success:^(NSArray *arr)
                 {
                     _isFirstCommit = YES;
                     weakSelf.dataArr = [NSMutableArray arrayWithArray:arr];
                     [self.contentView addSubview:self.commentTableView];
                     
                 } faild:^(NSString *errorMsg) {
                     
                 }];
                
            }
            
            if (_isCommit == NO)
            {
                self.commentTableView.frame = CGRectMake(0, APPWINDOWHEIGHT / 2 - 49- 64, APPWINDOWWIDTH, APPWINDOWHEIGHT / 2);
                _useTF = YES;
                
                self.commitTextFD = [[[NSBundle mainBundle] loadNibNamed:@"CommitTextFild" owner:nil options:nil] firstObject];
                __weak typeof(self) weakSelf = self;
                //点击完成之后回调的block
                self.commitTextFD.completeCommite = ^{
                    [weakSelf completeCommit:nil];
                };
                
                self.commitTextFD.frame = CGRectMake(0, CGRectGetMaxY(self.commentTableView.frame), APPWINDOWWIDTH, 48);
                [self.contentView addSubview:self.commitTextFD];
                self.commitTextFD.hidden = NO;
                _isCommit = YES;
                _completeBtn.hidden = NO;
            }
            else
            {
                self.commentTableView.frame = CGRectMake(0, APPWINDOWHEIGHT, APPWINDOWWIDTH, (APPWINDOWHEIGHT) / 2);
                _isCommit = NO;
                
            }
            
        }
            break;
        case 2:
        {
            if (btn.selected == YES)
            {
                [self delDZ:btn];
                
            }else
            {
                [self savwDZ:btn];
            }
        }
            break;
        case 3:
        {
            //分享
            NSNotification * noti = [[NSNotification alloc] initWithName:@"sharepic" object:self.domain userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:noti];
        }
            break;
        case 4:
        {
            [self showMoreView];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 完成按钮
-(void)completeCommit:(UIBarButtonItem *)sender{
    
    _useTF = NO;
    _completeBtn.hidden = YES;
    [[KGHttpService sharedService] saveFPItemReply:self.commitTextFD.TF.text rel_uuid:self.domain.uuid success:^(NSString *mgr) {
        [MBProgressHUD showSuccess:@"评论成功"];
    } faild:^(NSString *errorMsg) {
        [MBProgressHUD showError:errorMsg];
    }];
    [self.commentTableView headerBeginRefreshing];
    _isCommit = NO;
    self.commitTextFD.TF.text = @"";
    [self.commitTextFD.TF resignFirstResponder];
}

#pragma mark - 收藏相关
//保存收藏
- (void)saveFavorites:(UIButton *)button
{
    FPFamilyPhotoNormalDomain * temp = self.domain;
    
    [[KGHUD sharedHud] show:self.contentView];
    
 
    button.enabled = NO;
    
    [[KGHttpService sharedService] fPPhotoItem_addFavorites:self.domain.uuid  success:^(NSString *msgStr)
     {
         ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang2"];
         [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
         button.selected = !button.selected;
         button.enabled = YES;
     }
     faild:^(NSString *errorMsg)
     {
         button.selected = !button.selected;
         button.enabled = YES;
         [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
     }];
}

//取消收藏
- (void)delFavorites:(UIButton *)button
{
    [[KGHUD sharedHud] show:self.contentView];
    button.enabled = NO;
//    FPFamilyPhotoNormalDomain * temp = self.domain;
    
    [[KGHttpService sharedService] fPPhotoItem_deleteFavorites:self.domain.uuid  success:^(NSString *msgStr)
    {
        button.selected = !button.selected;
        button.enabled = YES;
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang1"];
    }
faild:^(NSString *errorMsg)
    {
        button.enabled = YES;
        button.selected = !button.selected;
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}

#pragma mark - 点赞相关
//保存点赞
- (void)savwDZ:(UIButton *)sender
{
    FPFamilyPhotoNormalDomain * temp = self.domain;
    [[KGHUD sharedHud] show:self.contentView];
    sender.enabled = NO;
    [[KGHttpService sharedService] saveFPDZ:temp.uuid type:Topic_FPTimeLine success:^(NSString *msgStr)
     {
         [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
         
         SPBottomItem * item = _buttonItems[2];
         item.imgView.image = [UIImage imageNamed:@"fp_dz2"];
         
         sender.selected = !sender.selected;
         sender.enabled = YES;
         
     } faild:^(NSString *errorMsg)
     {
         sender.enabled = YES;
         [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
     }];
}

//取消点赞
- (void)delDZ:(UIButton *)sender
{
    FPFamilyPhotoNormalDomain * temp = self.domain;
    [[KGHUD sharedHud] show:self.contentView];
    
    sender.enabled = NO;
    [[KGHttpService sharedService] delFPDZ:temp.uuid success:^(NSString *msgStr)
     {
         [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
         
         SPBottomItem * item = _buttonItems[2];
         item.imgView.image = [UIImage imageNamed:@"fp_dz"];
         sender.selected = !sender.selected;
         sender.enabled = YES;
         
     } faild:^(NSString *errorMsg)
     {
         sender.enabled = YES;
         [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
     }];
}



- (void)showMoreView //39 90
{
    if (_moreViewOpen == NO)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             [_moreView setOrigin:CGPointMake(APPWINDOWWIDTH - 44, CGRectGetMaxY(_bottomView.frame)-49-90)];
         }];
        _moreViewOpen = YES;
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             [_moreView setOrigin:CGPointMake(APPWINDOWWIDTH - 44, APPWINDOWHEIGHT)];
         }];
        _moreViewOpen = NO;
    }
}

- (void)deleteBtn
{
    NSNotification * noti = [[NSNotification alloc] initWithName:@"deletebtn" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

- (void)modifyBtn
{
    NSNotification * noti = [[NSNotification alloc] initWithName:@"modibtn" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

-(void)changeFreamsWithHeight:(CGFloat)height{
    self.commentTableView.frame = CGRectMake(0, APPWINDOWHEIGHT / 2 - 49- 64 - height, APPWINDOWWIDTH, APPWINDOWHEIGHT / 2);
    self.commitTextFD.frame = CGRectMake(0, CGRectGetMaxY(self.commentTableView.frame), APPWINDOWWIDTH, 49);
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [self changeFreamsWithHeight:kbSize.height];
}
-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    [self changeFreamsWithHeight:0];
}

#pragma mark - 上拉下拉
- (void)setupRefresh
{
    [self.commentTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.commentTableView.footerPullToRefreshText = @"上拉加载更多";
    self.commentTableView.footerReleaseToRefreshText = @"松开立即加载";
    self.commentTableView.footerRefreshingText = @"正在加载中...";
    
    [self.commentTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.commentTableView.headerRefreshingText = @"正在刷新中...";
   self.commentTableView.headerPullToRefreshText = @"下拉刷新";
    self.commentTableView.headerReleaseToRefreshText = @"松开立即刷新";
}

- (void)footerRereshing
{
    
    __weak typeof(self) weakSelf = self;
    
    [[KGHttpService sharedService] getFPItemCommentList:self.domain.uuid pageNo:[NSString stringWithFormat:@"%ld",(long)self.pageNo] time:[KGDateUtil getFPFormatSringWithDate:[NSDate date]] success:^(NSArray *arr)
     {
         if (arr.count == 0 || arr == nil)
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 weakSelf.commentTableView.footerRefreshingText = @"没有更多了";
                 [weakSelf.commentTableView footerEndRefreshing];
             });
             
         }else
         {
             weakSelf.pageNo++;
             [weakSelf.dataArr addObjectsFromArray:arr];
             [weakSelf.commentTableView reloadData];
             [weakSelf.commentTableView footerEndRefreshing];
         }
         
     } faild:^(NSString *errorMsg) {
         [MBProgressHUD showError:@"请求失败"];
         [weakSelf.commentTableView headerEndRefreshing];
     }];
    
}
- (void)headerRereshing
{
    __weak typeof(self) weakSelf = self;
    
    [self.dataArr removeAllObjects];
    
    [[KGHttpService sharedService] getFPItemCommentList:self.domain.uuid pageNo:@"1" time:[KGDateUtil getFPFormatSringWithDate:[NSDate date]] success:^(NSArray *arr)
     {
         weakSelf.dataArr = [NSMutableArray arrayWithArray:arr];
         [self.commentTableView reloadData];
         [self.commentTableView headerEndRefreshing];
         
     } faild:^(NSString *errorMsg) {
         [MBProgressHUD showError:@"请求失败"];
         [self.commentTableView headerEndRefreshing];
     }];

}


@end





