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

@interface FPTimeLineDetailCell() <UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,FPTimeLineDetailMoreViewDelegate>
{
    NSMutableArray * _buttonItems;
    FPTimeLineDetailMoreView * _moreView;
    BOOL _moreViewOpen;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView * infoView;
@property (strong, nonatomic) UILabel * timeLbl;
@property (strong, nonatomic) UILabel * locationLbl;
@property (strong, nonatomic) UILabel * deviceLbl;
@property (strong, nonatomic) UILabel * nameLbl;

@property (strong, nonatomic) UIImageView * imageView;

@property (strong, nonatomic) UIView * sepView;

@property (strong, nonatomic) UITableView * commentTableView;

@property (assign, nonatomic) NSInteger pageNo;
@property (strong, nonatomic) NSString * currentTime;
@property (strong, nonatomic) NSMutableArray * dataArr;

@property (strong, nonatomic) FPFamilyPhotoNormalDomain * domain;

@property (weak, nonatomic) IBOutlet UIView * bottomView;

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
    _moreViewOpen = NO;
    self.pageNo = 1;
    
    //创建infoview
    self.infoView = [[UIView alloc] init];
    self.infoView.frame = CGRectMake(0, -180, APPWINDOWWIDTH, 180);
    
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
    
    //创建imageView
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoView.frame), APPWINDOWWIDTH, 500)];
    
    //创建最新评论view
    self.commentTableView = [[UITableView alloc] init];
    self.commentTableView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 10, APPWINDOWWIDTH,5);
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    
    //添加到scrollview
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.infoView];
    [self.scrollView addSubview:self.commentTableView];
    [self.scrollView setContentSize:CGSizeMake(0,CGRectGetMaxY(self.imageView.frame))];
    
    //创建底部按钮
    [self addBtn:self.bottomView];
    
    _moreView = [[[NSBundle mainBundle] loadNibNamed:@"FPTimeLineDetailMoreView" owner:nil options:nil] firstObject];
    _moreView.delegate = self;
    [_moreView setOrigin:CGPointMake(APPWINDOWWIDTH - 44, APPWINDOWHEIGHT)];
    [self addSubview:_moreView];
    [self bringSubviewToFront:self.bottomView];
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
    
    [self calImageViewHeight:self.domain success:^(CGFloat height)
    {
         //设置图片、图片高度
         self.imageView.height = height;
         [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[self.domain.path componentsSeparatedByString:@"@"] firstObject]]];
         
         self.timeLbl.text = [NSString stringWithFormat:@"拍摄时间:%@",self.domain.photo_time];
         self.locationLbl.text = [NSString stringWithFormat:@"位置:%@",self.domain.address];
         self.deviceLbl.text = [NSString stringWithFormat:@"设备:%@",self.domain.phone_type];
         self.nameLbl.text = [NSString stringWithFormat:@"上传人:%@",self.domain.create_user];
         
         if (hideInfoView == NO)
         {
             //显示infoview
             [self.infoView setOrigin:CGPointMake(0, 0)];
             [self.imageView setOrigin:CGPointMake(0, CGRectGetMaxY(self.infoView.frame))];
         }
         else
         {
             //隐藏infoview
             [self.infoView setOrigin:CGPointMake(0, -180)];
             [self.imageView setOrigin:CGPointMake(0, CGRectGetMaxY(self.infoView.frame))];
         }
        
         //请求点赞数据
         [self getDZData];
        
         [self.scrollView setContentSize:CGSizeMake(0,CGRectGetMaxY(self.imageView.frame)+49)];
         
         //请求评论数据
         self.currentTime = [KGDateUtil getFPFormatSringWithDate:[NSDate date]];
         [self getCommentData:self.domain.uuid];
         
         self.scrollView.hidden = NO;
     }
     faild:^(NSString *errorMsg)
     {
         //按照一个大小设置imageView
     }];
}

- (void)setData:(FPFamilyPhotoNormalDomain *)domain hideInfo:(BOOL)hideInfoView
{
    if ([domain.status isEqualToString:@"1"]) //需要修改的domain
    {
        [MBProgressHUD showMessage:@"请稍后..."];
        //请求最新domain
        [[KGHttpService sharedService] getFPTimeLineItem:domain.uuid success:^(FPFamilyPhotoNormalDomain *item)
        {
            [MBProgressHUD hideHUD];
            self.domain = item;
            [self resetData:hideInfoView];
            
        }
        faild:^(NSString *errorMsg)
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"获取最新相片信息失败!"];
            self.domain = domain;
            [self resetData:hideInfoView];
        }];
    }
    else
    {
        self.domain = domain;
        [self resetData:hideInfoView];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            [EYInputPopupView popViewWithTitle:@"编辑评论内容" contentText:@"" type:EYInputPopupView_Type_multi_line cancelBlock:^
             {
                 
                 
             } confirmBlock:^(UIView *view, NSString *text)
             {
                 //保存评论
                 
                 [[KGHttpService sharedService] saveFPItemReply:text rel_uuid:self.domain.uuid success:^(NSString *mgr)
                  {
                      [MBProgressHUD showSuccess:@"评论成功!"];
                      [self.commentTableView reloadData];
                  }
                  faild:^(NSString *errorMsg)
                  {
                      [MBProgressHUD showError:@"评论失败"];
                  }];
                 
             } dismissBlock:^
             {
                 
             }];
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

#pragma mark - 收藏相关
//保存收藏
- (void)saveFavorites:(UIButton *)button
{
    FPFamilyPhotoNormalDomain * temp = self.domain;
    
    [[KGHUD sharedHud] show:self.contentView];
    
    FavoritesDomain * domain = [[FavoritesDomain alloc] init];
    domain.title = temp.note;
    domain.type  = Topic_FPTimeLine;
    domain.reluuid = temp.uuid;
    domain.createtime = [KGDateUtil presentTime];
    button.enabled = NO;
    
    [[KGHttpService sharedService] saveFavorites:domain success:^(NSString *msgStr)
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
    FPFamilyPhotoNormalDomain * temp = self.domain;
    
    [[KGHttpService sharedService] delFavorites:temp.uuid success:^(NSString *msgStr)
     {
         button.selected = !button.selected;
         button.enabled = YES;
         [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
         ((SPBottomItem *)_buttonItems[0]).imgView.image = [UIImage imageNamed:@"newshoucang1"];
     }
     failed:^(NSString *errorMsg)
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

@end
