//
//  FPTimeLineDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPTimeLineDetailVC.h"
#import "DBNetDaoService.h"
#import "MBProgressHUD+HM.h"
#import "FPTimeLineDetailLayout.h"
#import "FPTimeLineDetailCell.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "FPTimeLineEditVC.h"
#import "SPBottomItem.h"
#import "KGHUD.h"
#import "KGDateUtil.h"
#import "MBProgressHUD+HM.h"
#import "HLActionSheet.h"
#import "UMSocial.h"
#import "FPFamilyPhotoNormalDomain.h"
#import "MJExtension.h"
#import "PhotoVC.h"

@interface FPTimeLineDetailVC () <UICollectionViewDataSource,UICollectionViewDelegate,FPTimeLineDetailLayoutDelegate,UIAlertViewDelegate,UMSocialUIDelegate>
{
    DBNetDaoService * _service;
    NSMutableArray * _imgDatas;
    NSInteger _pageNo;
    UICollectionView * _collectionView;
    CGFloat imageViewHeight;
    NSInteger _selectPicNum;
    BOOL _isHideInfo;
}

@end

@implementation FPTimeLineDetailVC

static NSString *const PicID = @"camaracoll";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.title = [[self.daytimeStr componentsSeparatedByString:@","] firstObject];
//    
    self.title = @"照片详细";
    
    
    _service = [DBNetDaoService defaulService];
    _imgDatas = [NSMutableArray array];
    _pageNo = 1;
    _selectPicNum = 0;
    _isHideInfo = YES;
    
    //创建视图
    [self initView];
    
    //从数据库获取数据
    [self getInitData];
    
    //显示详细按钮
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,20,20)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"xinxi_photo"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(showInfoView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    //注册通知用于更新
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateDetailItem:) name:@"updatedetail" object:nil];
    [center addObserver:self selector:@selector(deleteBtn) name:@"deletebtn" object:nil];
    [center addObserver:self selector:@selector(modifyBtn) name:@"modibtn" object:nil];
    [center addObserver:self selector:@selector(sharePic:) name:@"sharepic" object:nil];
    
    
    //注册点击图片浏览图片通知
    [center addObserver:self selector:@selector(browseImagesNotification:) name:Key_Notification_BrowseImages object:nil];
}

- (void)showInfoView
{
    _isHideInfo = !_isHideInfo;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_selectPicNum inSection:0];
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)pushToModifyVC
{
    FPTimeLineEditVC * vc = [[FPTimeLineEditVC alloc] init];
    
    vc.domain = _imgDatas[_selectPicNum];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateDetailItem:(NSNotification *)noti
{
    FPFamilyPhotoNormalDomain * domain = noti.object;
    if (domain)
    {
        _imgDatas[_selectPicNum] = domain;
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_selectPicNum inSection:0];
            [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        });
    }
}
- (void)setFpPhotoNormalDomainArrByDic:( NSMutableArray *) fpItemArrDic{
    self.fpPhotoNormalDomainArr =[NSMutableArray array];

    for (id map in  fpItemArrDic) {
       FPFamilyPhotoNormalDomain * tmp = [FPFamilyPhotoNormalDomain objectWithKeyValues:map];
        [[self fpPhotoNormalDomainArr] addObject:tmp];
    }
    
}

#pragma mark - 获取数据
- (void)getInitData
{
    
    //传入得数据直接使用。1.收藏列表页面进入。2。时光轴进入
    if([self fpPhotoNormalDomainArr]&&[self fpPhotoNormalDomainArr].count>0){
        
        _imgDatas=[self fpPhotoNormalDomainArr];
        [self.view addSubview:_collectionView];
        
        if (self.selectIndex) {
            _selectPicNum=self.selectIndex;
        }
        [self resetTableViewCellIndex:_selectPicNum];
        return;
    }
    NSArray * arr = [_service queryPicDetailByDate:[[self.daytimeStr componentsSeparatedByString:@","] firstObject] pageNo:[NSString stringWithFormat:@"1"] familyUUID:self.familyUUID];
    if (arr)
    {
        [_imgDatas addObjectsFromArray:arr];
        [self.view addSubview:_collectionView];
    }
    else
    {
        [MBProgressHUD showError:@"获取相册数据失败,请重试!"];
    }
}

#pragma mark - 创建视图
- (void)initView
{
    FPTimeLineDetailLayout * layout = [[FPTimeLineDetailLayout alloc] init];
    layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"FPTimeLineDetailCell" bundle:nil] forCellWithReuseIdentifier:PicID];
}

#pragma mark - collectionView D&D
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPTimeLineDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PicID forIndexPath:indexPath];
    [cell setData:_imgDatas[indexPath.row] indexOfDomain:indexPath.row dataArray:_imgDatas];
   // [cell setData:_imgDatas[indexPath.row] hideInfo:_isHideInfo];
    
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


//设置当前展示的图片
- (void)resetTableViewCellIndex:(NSInteger)index{
    _selectPicNum=index;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:Number_Zero];
    
    //3）通过动画滚动到下一个位置
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
   
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgDatas.count;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page
{
    _selectPicNum = page;
}

- (void)downloadImg
{
    FPFamilyPhotoNormalDomain * domain = _imgDatas[_selectPicNum];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: domain.path] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (error)
        {
            [MBProgressHUD showSuccess:@"图片下载失败!"];
        }
        if (image)
        {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
        
    }];
    
    NSString * path = [[domain.path componentsSeparatedByString:@"@"] firstObject];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:path] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
    {
         
    }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        if (error)
        {
            [MBProgressHUD showSuccess:@"图片下载失败!"];
        }
        if (image)
        {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error)
    {
        [MBProgressHUD showSuccess:@"下载成功!"];
        
    }else
    {
        [MBProgressHUD showError:@"保存图片失败,请在设置中检查权限!"];
    }
}

- (void)deleteBtn
{
    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"确定要删除该相片吗?" message:@"请确认" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [al show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        FPFamilyPhotoNormalDomain * domain = _imgDatas[_selectPicNum];
        NSLog(@"...... >>> %@",domain.uuid);
        [MBProgressHUD showMessage:@"请稍候..."];
        //调用接口删除
        [[KGHttpService sharedService] deleteFPTimeLineItem:domain.uuid success:^(NSString *mgr)
        {
            [MBProgressHUD hideHUD];
            //从collectionview中删除
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_selectPicNum inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^
            {
                //从数据库删除照片
                [_service deletePhotoItem:domain.uuid];
                [_imgDatas removeObjectAtIndex:_selectPicNum];
                [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                [_collectionView reloadData];
                [MBProgressHUD showSuccess:@"操作成功!"];
                //通知homevc刷新数据
                NSNotification * noti = [[NSNotification alloc] initWithName:@"reloaddata" object:nil userInfo:nil];
                if(noti){
                    [[NSNotificationCenter defaultCenter] postNotification:noti];
                }else{
                    NSLog(@" NSNotification reloaddata is null");
                }
                
            });
        }
        faild:^(NSString *errorMsg)
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络错误,请重试!"];
        }];
    }
}

- (void)modifyBtn
{
    [self pushToModifyVC];
}

#pragma mark - 处理分享
- (void)sharePic:(NSNotification *)noti
{
    [self shareClicked:noti.object];
}

#pragma mark - 分享相关
- (void)shareClicked:(FPFamilyPhotoNormalDomain *)norDomain
{
    FPFamilyPhotoNormalDomain * temp = norDomain;
    
    AnnouncementDomain * domain = [[AnnouncementDomain alloc] init];
    
    domain.share_url = temp.path;
    domain.title = temp.note;
    
    if (domain.title == nil)
    {
        domain.title = @"";
    }
    
    NSArray *titles = @[@"微博",@"微信",@"朋友圈",@"QQ好友",@"复制链接"];
    NSArray *imageNames = @[@"xinlang",@"weixin",@"pyquan",@"QQ",@"fuzhilianjie"];
    HLActionSheet *sheet = [[HLActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    
    [sheet showActionSheetWithClickBlock:^(NSInteger btnIndex)
     {
         switch (btnIndex)
         {
             case 0:
             {
                 [self handelShareWithShareType:UMShareToSina domain:domain];
             }
                 break;
                 
             case 1:
             {
                 [self handelShareWithShareType:UMShareToWechatSession domain:domain];
             }
                 break;
                 
             case 2:
             {
                 [self handelShareWithShareType:UMShareToWechatTimeline domain:domain];
             }
                 break;
                 
             case 3:
             {
                 [self handelShareWithShareType:UMShareToQQ domain:domain];
             }
                 break;
                 
             case 4:
             {
                 UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
                 pasteboard.string = domain.share_url;
                 //提示复制成功
                 UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已复制分享链接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 [av show];
             }
                 break;
                 
             default:
                 break;
         }
     }
     cancelBlock:^
     {
         NSLog(@"取消");
     }];
}

#pragma mark - 处理分享操作
- (void)handelShareWithShareType:(NSString *)shareType domain:(AnnouncementDomain *)domain
{
    NSString * contentString = domain.title;
    
    NSString * shareurl = domain.share_url;
    
    if(!shareurl || [shareurl length] == 0)
    {
        shareurl = @"http://wenjie.net";
    }
    
    //微信title设置方法：
    [UMSocialData defaultData].extConfig.wechatSessionData.title = domain.title;
    
    //朋友圈title设置方法：
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = domain.title;
    [UMSocialWechatHandler setWXAppId:@"wx6699cf8b21e12618" appSecret:@"639c78a45d012434370f4c1afc57acd1" url:domain.share_url];
    [UMSocialData defaultData].extConfig.qqData.title = domain.title;
    [UMSocialData defaultData].extConfig.qqData.url = domain.share_url;
    
    if (shareType == UMShareToSina)
    {
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",contentString,shareurl];
        [UMSocialData defaultData].extConfig.sinaData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:shareurl];
    }
    
    //设置分享内容，和回调对象
    [[UMSocialControllerService defaultControllerService] setShareText:contentString shareImage:[UIImage imageNamed:@"jiazhang_180"] socialUIDelegate:self];
    
    UMSocialSnsPlatform * snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareType];
    
    snsPlatform.snsClickHandler(self, [UMSocialControllerService defaultControllerService],YES);
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    UIAlertView * alertView;
    NSString * string;
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        string = @"分享成功";
    }
    else if (response.responseCode == UMSResponseCodeCancel)
    {
    }
    else
    {
        string = @"分享失败";
    }
    if (string && string.length)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}
//图片点击浏览图片通知
- (void)browseImagesNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    NSMutableArray * imagesMArray = [dic objectForKey:Key_ImagesArray];
    NSInteger index = [[dic objectForKey:Key_Tag] integerValue];
    PhotoVC * vc = [[PhotoVC alloc] init];
    vc.imgMArray = imagesMArray;
    vc.isShowSave = YES;
    vc.curentPage = index;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
