//
//  FPUploadVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//
#import "FPHomeVC.h"
#import "FPUploadVC.h"
#import "FPImagePickerVC.h"
#import "MJExtension.h"
#import "FPFamilyPhotoUploadDomain.h"
#import "FPUploadCell.h"
#import "AFNetworking.h"
#import "KGHttpUrl.h"
#import "FPUploadSaveUrlDomain.h"
#import "KGHttpService.h"
#import "DBNetDaoService.h"

@interface FPUploadVC () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray * _dataArrs;
    
//    NSMutableArray * _cells;
    UIBarButtonItem *uploadStatusBar ;
    DBNetDaoService * _service;
    Reachability * wifiStatus; //网络状态
}

@property (strong, nonatomic) UITableView * uploadTable;
@property  BOOL  isUploadBy4G;
@end

@implementation FPUploadVC

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
    {
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (ALAssetsLibrary *)library
{
    if (nil == _library)
    {
        _library = [self.class defaultAssetsLibrary];
    }
    return _library;
}

-(void)updateCellBy:(NSNotification *)noti{
     FPUploadSaveUrlDomain * domain = noti.object;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    wifiStatus = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    NSLog(@"FPUplodVC viewDidLoad,isJumpTwoPages=%d,pushToSelectImageVC=%d",self.isJumpTwoPages,self.pushToSelectImageVC);
    if (self.isJumpTwoPages == YES) {
        [self.navigationController pushViewController:[[FPImagePickerVC alloc] init] animated:YES];
        self.isJumpTwoPages = NO;
    }
    
    if (self.pushToSelectImageVC == YES)
    {
        [self openSelectImageView];
    }
    
    _dataArrs = [NSMutableArray array];
//    _cells = [NSMutableArray array];
    
    _library = [[ALAssetsLibrary alloc] init];
    
    self.title = @"上传列表";
    
    [self initTableView];
        //在右上角添加一个按钮来选择图片
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(openSelectImageView)];
    barbtn.title = @"添加相片";
    barbtn.tintColor = [UIColor whiteColor];
    
    //在右上角添加一个按钮来选择图片
    uploadStatusBar = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(uploadStatusBar_click)];
    
    uploadStatusBar.tintColor = [UIColor whiteColor];
    
 [self refresh_uploadStatusBar_title];
     [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:barbtn,uploadStatusBar,nil]];
//    self.navigationItem.rightBarButtonItem = barbtn;
    [self regNotification];
   
    [self getDataFromDatabase];
    

    
}



- (void)initTableView
{
    self.uploadTable = [[UITableView alloc] init];
    self.uploadTable.dataSource = self;
    self.uploadTable.delegate = self;
    self.uploadTable.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT-64);
    [self.view addSubview:self.uploadTable];
}

- (void)getDataFromDatabase
{
    _service = [DBNetDaoService defaulService];
    
    NSMutableArray * marr = [NSMutableArray arrayWithArray:[_service queryUploadListLocalImg]];
    
    if(_dataArrs==nil)_dataArrs=[NSMutableArray array];
    
    _dataArrs= marr;
    
       [self.uploadTable reloadData];
    
 
    
}

- (void)startDoUploadTable2{
    
    if(_dataArrs.count>0){
        //找到第一个等待状态的数据开始上传。
        for (int i=0;i<_dataArrs.count;i++) {
            FPFamilyPhotoUploadDomain * domain=_dataArrs[i];
            if(domain.status==1){
                NSLog(@"startDoUploadTable _dataArrs.count=@d",_dataArrs.count);
                NSNotification * noti = [[NSNotification alloc] initWithName:@"startupload" object:@(i) userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:noti];
                
                break;
            }
            
        }
        
    }else{
        NSLog(@"startDoUploadTable _dataArrs.count==0");
    }
    [self.uploadTable reloadData];
}
/**
 开始执行初始化上传进度表，和开始上传。
 */
- (void)startDoUploadTable{
    
    NSString *countStr=[NSString stringWithFormat:@"%ld",_dataArrs.count];
    

    //通知主页时光轴有数据更新
    NSNotification * noti1 = [[NSNotification alloc] initWithName:@"canUpDatePhotoData" object:countStr userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:noti1];
    
    if(_dataArrs.count==0){
        return;
    }
    
    
    //确认允许4G上传标记。
    if(self.isUploadBy4G==YES){
        [self startDoUploadTable2];
        return;
    }
    //wifi直接上传
    if(![wifiStatus isReachableViaWiFi]){
        [self startDoUploadTable2];
        return;

    }    //4G判断
    {
        
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"不是wifi环境，使用移动流量，是否要上传?" message:@"请确认" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [al show];
        return;
    }
 
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        self.isUploadBy4G=YES;
        [self startDoUploadTable2];
      
    }
}



#pragma mark - tableview d & d
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * upload_ID = @"upload_id";
    
    FPUploadCell * cell = [tableView dequeueReusableCellWithIdentifier:upload_ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FPUploadCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setData:_dataArrs[indexPath.row]];
    cell.index = indexPath.row;
    
//    [_cells addObject:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)refresh_uploadStatusBar_title{
    if([UploadPhotoToRemoteService isUpoading]){
        uploadStatusBar.title=@"全部暂停";
        
        
    }else{
               uploadStatusBar.title=@"全部开始";
        
    }

}
- (void)uploadStatusBar_click
{
    if([UploadPhotoToRemoteService isUpoading]){
        [UploadPhotoToRemoteService pauseUploadAll];
        
    }else{
      
        if([UploadPhotoToRemoteService upLoadAllFromLocalDB]==0){
            [MBProgressHUD showSuccess:@"已经全部上传了"];
        }
       
    }
    
    [self refresh_uploadStatusBar_title];
}
- (void)openSelectImageView
{
    FPImagePickerVC * vc = [[FPImagePickerVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //把数据库里面的也给栓了
        FPFamilyPhotoUploadDomain * domain = _dataArrs[indexPath.row];
        if (domain.status != 0)
        {
            [_service deleteUploadImg:[domain.localurl absoluteString]];
            [_dataArrs removeObjectAtIndex:indexPath.row];
            [self.uploadTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - 通知
//获取到了图片
- (void)didGetPhotoData:(NSNotification *)noti
{
    NSArray * urls = noti.object;
    
    for (NSInteger i=0; i<urls.count; i++)
    {
        FPFamilyPhotoUploadDomain * domain = [[FPFamilyPhotoUploadDomain alloc] init];
        domain.family_uuid=[FPHomeVC getFamily_uuid];
        domain.localurl = urls[i];
        domain.status = 1;
//        domain.suoluetu = [UIImage imageWithCGImage:[asset thumbnail]];
        [_dataArrs addObject:domain];
        [UploadPhotoToRemoteService addPhotoUploadDomain:domain];
//        
//        [_library assetForURL:urls[i] resultBlock:^(ALAsset *asset)
//        {
//            
////            
////            if (i == urls.count-1)
////            {
////                dispatch_async(dispatch_get_main_queue(), ^
////                {
//////                    [self startDoUploadTable];
////                });
////            }
//        }
//        failureBlock:^(NSError *error)
//        {
//            NSLog(@"大图失败拉");
//        }];
    }
    [self.uploadTable reloadData];
}

- (void)dealloc
{
    NSLog(@"upload delloc ---");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 开始上传
- (void)startUpLoad:(NSNotification *)noti
{
    NSInteger index = [noti.object integerValue];
    
    NSLog(@"第几号:%d",index);
    
    FPFamilyPhotoUploadDomain * domain = _dataArrs[index];

    NSURL * localUrl = domain.localurl;
    [_library assetForURL:localUrl resultBlock:^(ALAsset *asset)
    {
        //获取大图
        UIImage * img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        //获取时间
        NSString * date = [asset valueForProperty:@"ALAssetPropertyDate"];
        
        [self upLoadPic:img photoTime:date index:index uploadDomain:domain];
    }
    failureBlock:^(NSError *error)
    {
        NSLog(@"根据local url 查找失败");
    }];
}

- (void)upLoadPic:(UIImage *)img photoTime:(NSString *)photoTime index:(NSInteger)index uploadDomain:(FPFamilyPhotoUploadDomain *)uploadDomain
{
    NSData *data;
    data = UIImageJPEGRepresentation(img, 0.1);
     NSString * phone_uuid=[KGUUID getUUID];//手机设备唯一标示
    NSString * phoneType = [UIDevice currentDevice].model;
    //这里传入一个 uuid
     FPFamilyPhotoUploadDomain *uploadDmain=_dataArrs[index];
   
    NSDictionary * dict = @{

                            @"family_uuid":uploadDmain.family_uuid,@"photo_time":photoTime,@"phone_type":phoneType,@"md5":[uploadDomain.localurl absoluteString],@"phone_uuid":phone_uuid,@"address":@""};
    NSLog(@"FPUploadImgUrl=%@",[KGHttpUrl getFPUploadImgUrl] );
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:[KGHttpUrl getFPUploadImgUrl] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:@"file"
                                mimeType:@"image/jpeg"];
    } error:nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
//        [self sessionTimeoutHandle:baseDomain];
        
        FPUploadSaveUrlDomain * domain = [[FPUploadSaveUrlDomain alloc] init];
       
        domain.uuid=baseDomain.data_id;
        domain.localUrl = [uploadDmain.localurl absoluteString];
        domain.family_uuid=uploadDmain.family_uuid;
        domain.status = 0;//成功
     
        //存入数据库
        NSNotification * noti0 = [[NSNotification alloc] initWithName:@"saveuploadimg" object:domain userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti0];
      
        
        //从列表移除
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
           [_dataArrs removeObjectAtIndex:index];
           [self.uploadTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [self startDoUploadTable];
        });
        
        
        
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        //失败了，修改_dataarr状态
        dispatch_async(dispatch_get_main_queue(), ^
        {
//            FPUploadCell * cell = [_cells objectAtIndex:index];
//            [cell setStatus:3];
        });
    
        //存入数据库
        FPUploadSaveUrlDomain * domain = [[FPUploadSaveUrlDomain alloc] init];
        
            domain.status = 3;//失败
        
        
        domain.localUrl = [uploadDmain.localurl absoluteString];
        domain.family_uuid=uploadDmain.family_uuid;
       
        
        NSNotification * noti = [[NSNotification alloc] initWithName:@"saveuploadimg" object:domain userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
        
          [self startDoUploadTable];
    }];
    
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite)
    {
        //通知更新进度条
        CGFloat percent = totalBytesWritten * 1.0 /totalBytesExpectedToWrite * 1.0;
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
//            FPUploadCell * cell = [_cells objectAtIndex:index];
//            [cell setPercent:percent];
        });
    }];
    
    // 5. Begin!
    [operation start];
}


- (void)regNotification {
   [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didGetPhotoData:) name:@"didgetphotodata" object:nil];
    //    [center addObserver:self selector:@selector(startUpLoad:) name:@"startupload" object:nil];
    [center addObserver:self selector:@selector(saveUploadImgPath:) name:@"saveuploadimg" object:nil];
    //从数据库去读取上传失败的，等待上传的数据
}
- (void)saveUploadImgPath:(NSNotification *)noti
{
    FPUploadSaveUrlDomain * domainNew = noti.object;
    for (int i=0;i<_dataArrs.count;i++) {
        FPFamilyPhotoUploadDomain * domain=_dataArrs[i];
        
        if([[domain.localurl absoluteString] isEqualToString:domainNew.localUrl]&&[domain.family_uuid isEqualToString:domainNew.family_uuid]){
            domain.status=domainNew.status;
            if(domain.status==0){//
                 [_dataArrs removeObject:domain];
                [self.uploadTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
               
            }else{
                [self.uploadTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}
@end
