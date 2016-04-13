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
#import "BaseReplyListVCTableView.h"
#import "UIButton+Extension.h"
#import "DBNetDaoService.h"
#import <objc/runtime.h>
#import "SPBottomItem.h"
#import "SPBottomItemTools.h"

@interface FPTimeLineDetailCell() <UMSocialUIDelegate,FPTimeLineDetailMoreViewDelegate>
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
@property (strong, nonatomic) UILabel * dianzanName;
@property (strong, nonatomic) UILabel * locationLbl;
@property (strong, nonatomic) UILabel * deviceLbl;
@property (strong, nonatomic) UILabel * nameLbl;
@property (strong, nonatomic) UIView * dividingLine;


@property (strong, nonatomic) UIImageView * imageView;

@property (strong, nonatomic) UIView * sepView;

@property (strong, nonatomic) SPBottomItem * pinglunSPBottomItem;
@property (strong, nonatomic) BaseReplyListVCTableView * baseReplyListVC;

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
    

    
    _moreViewOpen = NO;
    self.pageNo = 1;
    
    
    
    //创建imageView
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, 500)];
    
    self.imageView .tag = [self indexOfDomain];
     self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullImgClicked:)];
    
    [ self.imageView addGestureRecognizer:singleTap1];

    
    [self.scrollView addSubview:self.imageView];

 
    //UILabel自适应高度和自动换行
    //初始化label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    //设置自动行数与字符换行
    [label setNumberOfLines:0];
    label.lineBreakMode = UILineBreakModeWordWrap;
    // 测试字串
       UIFont *font = [UIFont fontWithName:@"Arial" size:16];
        //备注
    self.imageDetailLable=label;
    
    self.infoView = [[UIView alloc] init];
    self.infoView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+5, APPWINDOWWIDTH, 280);
    
    
    NSLog(@"infoView y=%f",self.infoView.frame.origin.y);
     [self.infoView addSubview:self.imageDetailLable];
    
        CGRect frame =self.imageDetailLable.frame;
    NSLog(@"imageDetailLable frame=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    frame =self.infoView.frame;
    NSLog(@"scrollView frame=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    
    //点赞
     self.dianzanName = [[UILabel alloc] init];
    
    UIColor *color1=[UIColor grayColor];
    UIFont * uIFont1=[UIFont systemFontOfSize:17];
    self.dianzanName.frame = CGRectMake(10, CGRectGetMaxY(self.imageDetailLable.frame)+5, APPWINDOWWIDTH-10, 20);
    self.dianzanName.textColor = color1;
    
    self.dianzanName.font = [UIFont systemFontOfSize:12];
    
    self.dianzanName.text=@"0人点赞";
    
    [self.infoView addSubview:self.dianzanName];
    
    
    //5.在导航视图底添加分割线
    self.dividingLine = [[UIView alloc] init];

         self.dividingLine.frame =CGRectMake(10, CGRectGetMaxY(self.dianzanName.frame)+2, APPWINDOWWIDTH-10, 1);
         self.dividingLine.backgroundColor = [UIColor grayColor];
        [self.infoView addSubview: self.dividingLine];
    
   //拍摄时间
        self.timeLbl = [[UILabel alloc] init];
    
    
    self.timeLbl.frame = CGRectMake(20, CGRectGetMaxY(self.dianzanName.frame)+5, APPWINDOWWIDTH-20, 20);
    self.timeLbl.textColor = color1;
    self.timeLbl.font = uIFont1;
    [self.infoView addSubview:self.timeLbl];
    
    //拍摄地点
    self.locationLbl = [[UILabel alloc] init];
    self.locationLbl.frame = CGRectMake(20, CGRectGetMaxY(self.timeLbl.frame)+5, APPWINDOWWIDTH-20, 20);
    self.locationLbl.textColor =color1;
    self.locationLbl.font = uIFont1;
    [self.infoView addSubview:self.locationLbl];
//    
//    self.deviceLbl = [[UILabel alloc] init];
//    self.deviceLbl.frame = CGRectMake(20, 100, APPWINDOWWIDTH-20, 20);
//    self.deviceLbl.textColor = [UIColor brownColor];
//    self.deviceLbl.font = [UIFont systemFontOfSize:17];
//    [self.infoView addSubview:self.deviceLbl];
    
    //创建人
    self.nameLbl = [[UILabel alloc] init];
    self.nameLbl.frame = CGRectMake(20, CGRectGetMaxY(self.locationLbl.frame)+5, APPWINDOWWIDTH-20, 20);
    self.nameLbl.textColor = color1;
    self.nameLbl.font = uIFont1;
    [self.infoView addSubview:self.nameLbl];

    //添加到scrollview
    self.scrollView.showsVerticalScrollIndicator = YES;
    
    [self.scrollView addSubview:self.infoView];
    [self.scrollView setContentSize:CGSizeMake(0,CGRectGetMaxY(self.infoView.frame))];
    
    CGSize size=self.bottomView.size;
    size.width=APPWINDOWWIDTH;
    [self.bottomView setSize:size];
    
    //创建底部按钮
    [self addBtn:self.bottomView];
    
    _moreView = [[[NSBundle mainBundle] loadNibNamed:@"FPTimeLineDetailMoreView" owner:nil options:nil] firstObject];
    _moreView.delegate = self;
    [_moreView setOrigin:CGPointMake(APPWINDOWWIDTH - 44, APPWINDOWHEIGHT)];
    [self addSubview:_moreView];
    [self bringSubviewToFront:self.bottomView];
    

    
    
    
}

//设置内容后，重计算高度
-(void )resetFrame{
    UIFont *font = [UIFont fontWithName:@"Arial" size:16];
  
    
    
    //设置一个行高上限
    CGSize size = CGSizeMake(APPWINDOWWIDTH,2000);
    
    CGSize labelsize = [self.imageDetailLable.text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    [self.imageDetailLable setFrame:CGRectMake(0,0, labelsize.width, labelsize.height)];
    NSLog(@"imageDetailLable.y=%f", CGRectGetMaxY(self.imageDetailLable.frame));
    [self.dianzanName setFrame:CGRectMake(10, CGRectGetMaxY(self.imageDetailLable.frame)+5, APPWINDOWWIDTH-10, 20)];
     NSLog(@"dianzanName=%f", CGRectGetMaxY(self.dianzanName.frame));
    
    
    [self.dividingLine setFrame:CGRectMake(10, CGRectGetMaxY(self.dianzanName.frame)+2,self.infoView.frame.size.width-10, 1)];
    
    [self.timeLbl setFrame:CGRectMake(10, CGRectGetMaxY(self.dianzanName.frame)+10, APPWINDOWWIDTH-10, 20)];
    
    
    [self.locationLbl setFrame:CGRectMake(10, CGRectGetMaxY(self.timeLbl.frame)+10, APPWINDOWWIDTH-10, 20)];
    
     NSLog(@"timeLbl=%f", CGRectGetMaxY(self.timeLbl.frame));
    [self.nameLbl setFrame:CGRectMake(10, CGRectGetMaxY(self.locationLbl.frame)+5, APPWINDOWWIDTH-10, 20)];
    
 NSLog(@"nameLbl=%f", CGRectGetMaxY(self.nameLbl.frame));
    [self.infoView setFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+5, APPWINDOWWIDTH, CGRectGetMaxY(self.nameLbl.frame)+5)];
    
     NSLog(@"imageView=%f", CGRectGetMaxY(self.imageView.frame));
    //添加到scrollview
    self.scrollView.showsVerticalScrollIndicator = YES;
    
    [self.scrollView addSubview:self.infoView];
    
    [self.scrollView setContentSize:CGSizeMake(0,CGRectGetMaxY(self.infoView.frame))];

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
             
             [self.pinglunSPBottomItem setTipNumber:needUpDateDatas.reply_count];
             
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
- (void)loadImgByRemote
{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.domain.path ] placeholderImage:[UIImage imageNamed:@"waitImageDown"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         //         NSLog(@"self.domain.path=%@",self.domain.path);
     }];
    
    
    
    
    
    //原图，远程地址
    [self calImageViewHeight:self.domain success:^(CGFloat height)
     {
         
         
         //设置图片、图片高度
         self.imageView.height = height;
         
         self.imageDetailLable.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) - 44, APPWINDOWWIDTH, 44);
         
         [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[self.domain.path componentsSeparatedByString:@"@"] firstObject]]];
         
         [self resetFrame];
     }
                       faild:^(NSString *errorMsg)
     {
         //按照一个大小设置imageView
     }];

}
- (void)resetData:(BOOL)hideInfoView
{
   
    
    self.imageView .tag = [self indexOfDomain];
    NSLog(@" self.imageView .tag=%d", self.imageView .tag);
      if([@"(null)" isEqualToString:self.domain.photo_time]||self.domain.photo_time==nil)self.domain.photo_time=@"";
    self.timeLbl.text = [NSString stringWithFormat:@"拍摄时间:%@",self.domain.photo_time];
    
      if([@"(null)" isEqualToString:self.domain.address]||self.domain.address==nil)self.domain.address=@"";
    self.locationLbl.text = [NSString stringWithFormat:@"拍摄地点:%@",self.domain.address];
    
//    if(self.domain.phone_type==nil)self.domain.phone_type=@"";
//
//    self.deviceLbl.text = [NSString stringWithFormat:@"设备:%@",self.domain.phone_type];
    
    if([@"(null)" isEqualToString:self.domain.create_user]||self.domain.create_user==nil)self.domain.create_user=@"";

    self.nameLbl.text = [NSString stringWithFormat:@"上传人:%@",self.domain.create_user];
    
    if([@"(null)" isEqualToString:self.domain.note]||self.domain.note==nil)self.domain.note=@"";

    self.imageDetailLable.text=self.domain.note;
//    
//     self.imageDetailLable.text=@"这是一个测试！！！adsfsaf时发生发勿忘我勿忘我勿忘我勿忘我勿忘我阿阿阿阿阿阿阿阿阿阿阿阿阿啊00000000阿什顿。。。";
//    if(self.imageDetailLable.text==nil){
//        [self.imageDetailLable setHidden:NO];
//    }else{
//         [self.imageDetailLable setHidden:YES];
//    }
    
    
    
    
    DBNetDaoService * _service = [DBNetDaoService defaulService];
    NSString * localUrl=[_service getfp_upload_localurl:self.domain.uuid];
//    localUrl=@"assets-library://asset/asset111.JPG?id=99D53A1F-FEEF-40E1-8BB3-7DD55A43C8B71111&ext=JPG";
    //本地有图片则优先显示。
    if(localUrl.length>0){
        ALAssetsLibrary * _library =[FPUploadVC defaultAssetsLibrary];
        [_library assetForURL:[NSURL URLWithString:localUrl] resultBlock:^(ALAsset *asset)
         {
             // Could not find asset with UUID
             if(asset==nil){
                  [self loadImgByRemote];
                 return ;
             }
             //获取大图
             UIImage * img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
             [self.imageView setImage:img];
             
         }
                 failureBlock:^(NSError *error)
         {
             NSLog(@"根据local url 查找失败");
             [self loadImgByRemote];
         }];
        
    }else{
        [self loadImgByRemote];
        
    }

    [self resetFrame];
    //请求点赞数据
    [self getDZData];
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
    //test
    if ([domain.status isEqualToString:@"1"]) //需要修改的domain
    {
        MBProgressHUD * hub=[MBProgressHUD showMessage:@"更新数据，请稍后"];
        hub.removeFromSuperViewOnHide=YES;
        
        //请求最新domain
        [[KGHttpService sharedService] getFPTimeLineItem:domain.uuid success:^(FPFamilyPhotoNormalDomain *item)
        {
            
            [hub hide:YES];
            self.domain = item;
            //更新数据库
            [[DBNetDaoService defaulService] updatePhotoItemInfo:self.domain];
            self.domain.status=0;
            _dataArrOfDomain[self.indexOfDomain] =self.domain;
            [self resetData:true];
            
            
            
        }
        faild:^(NSString *errorMsg)
        {
            [hub hide:YES];
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

#pragma mark - 创建底部按钮
- (void)addBtn:(UIView *)view
{
    
    NSArray * imageName = @[@"newshoucang1",@"fp_hudong",@"fp_dz",@"fp_fenxiang",@"fp_more"];
    NSArray * titleName = @[@"收藏",@"评论",@"点赞",@"分享",@"更多"];
    
  
    _buttonItems=[SPBottomItemTools createBottoms:view imageName:imageName titleName:titleName addTarget:self action:@selector(bottomBtnClicked:) ];
    
    
    self.pinglunSPBottomItem=_buttonItems[1];
    return;
    _buttonItems = [NSMutableArray array];
    
    int totalloc = 5;
    CGFloat spcoursew = 80;
    CGFloat spcourseh = 48;
    CGFloat margin = (KGSCREEN.size.width - totalloc * spcoursew) / (totalloc + 1);

   
    
    for (NSInteger i = 0; i < 5; i++)
    {
        NSInteger row = (NSInteger)(i / totalloc);  //行号
        NSInteger loc = i % totalloc;               //列号
       
        SPBottomItem * item = [[[NSBundle mainBundle] loadNibNamed:@"SPBottomItem" owner:nil options:nil] firstObject];
        if(i==1){//评论
            self.pinglunSPBottomItem=item;
        }
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

#pragma pinglun
- (void)baseReplyListVC_show{
    
     NSInteger type=Topic_FPTimeLine;
    
    NSDictionary * dic = @{@"rel_uuid" :_domain.uuid, @"type" : [NSNumber numberWithInteger:type]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_ShowBaseReplyList object:self userInfo:dic];
    
    return;
  
    
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
        case 1://评论
        {
            
            [self baseReplyListVC_show];
           
            
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


@end





