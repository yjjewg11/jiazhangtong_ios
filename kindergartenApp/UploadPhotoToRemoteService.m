		//
//  UploadPhotoToRemoteService.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/14.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "UploadPhotoToRemoteService.h"

@implementation UploadPhotoToRemoteService
//最大
static NSInteger maxUploadingNumber=2;
DBNetDaoService * _localDbservice;


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
+ (UploadPhotoToRemoteService *)getService
{
    static dispatch_once_t pred = 0;
    static UploadPhotoToRemoteService * service = nil;
    dispatch_once(&pred,^
                  {
                      service = [[UploadPhotoToRemoteService alloc] init];
                      service.library=[[ALAssetsLibrary alloc] init];
                      _localDbservice = [DBNetDaoService defaulService];
                      service.uploadingDataArray=[NSMutableArray array];
                      
                      service.wifiStatus = [Reachability reachabilityWithHostName:@"www.baidu.com"];
                      

                      
                  });
    return service;
}
+(BOOL)isWifi{
    return [[UploadPhotoToRemoteService getService].wifiStatus isReachableViaWiFi];
}
+(BOOL)canUploadBy4G{
    return [UploadPhotoToRemoteService getService].isUploadBy4G==YES;
}
+(BOOL)allowUploadBy4G{
    return [UploadPhotoToRemoteService getService].isUploadBy4G=YES;
}
/**
 重新从数据库获取数据，全部上传。只允许调一次。启动时，防止数据冲突
 */
+ (NSInteger)upLoadAllFromLocalDB{
   UploadPhotoToRemoteService *s=[UploadPhotoToRemoteService getService];
    s.isPauseUpload=NO;
    return [s upLoadDataFromDatabase];
    
 
}
+ (void)pauseUploadAll{
    UploadPhotoToRemoteService * s=[UploadPhotoToRemoteService getService];
    s.isPauseUpload=YES;
    
}
+ (BOOL)isUpoading{
    UploadPhotoToRemoteService * s=[UploadPhotoToRemoteService getService];
    return s.uploadingDataArray.count>0;
}

//添加到新数据到数据库和，开始上传
+ (void)addPhotoUploadDomain:(FPFamilyPhotoUploadDomain *)domain{
  
    UploadPhotoToRemoteService * s=[UploadPhotoToRemoteService getService];
      s.isPauseUpload=NO;
    FPUploadSaveUrlDomain * savedomain = [[FPUploadSaveUrlDomain alloc] init];
    
    savedomain.localUrl = [domain.localurl absoluteString];
    savedomain.family_uuid=domain.family_uuid;
    savedomain.status = 1;//等待

    [s addToWaitFPFamilyPhotoUploadDomain:domain];
    
    
    
}
- (void)addToWaitFPFamilyPhotoUploadDomain:(FPFamilyPhotoUploadDomain *)domain{
    
    [self.waitUploadDataArray addObject:domain];
    [self upLoadDataFromwaitUploadDataArray];
}
+ (void)upLoadFPFamilyPhotoUploadDomain:(FPFamilyPhotoUploadDomain *)domain{
    
    [[UploadPhotoToRemoteService getService]startUpLoad:domain];
}
- (void)upLoadDataFromwaitUploadDataArray
{
    if(self.waitUploadDataArray.count==0)return;
    
    if( self.isPauseUpload){
        NSLog(@"s.isPauseUpload=true");
        return;
    }
    
    //需要走判断流程，用户确认
    if([self uploadBy4GuserConfirm]){
        
        return;
    }
    while(self.waitUploadDataArray.count>0&&self.uploadingDataArray.count<maxUploadingNumber){
        FPFamilyPhotoUploadDomain * domain=self.waitUploadDataArray[0];
        [self.uploadingDataArray addObject:domain];
        [self.waitUploadDataArray removeObject:domain];
        
        [self startUpLoad:domain];
        NSLog(@"self.uploadingDataArray.count=%ld",self.uploadingDataArray.count);
    }

}

- (NSInteger)upLoadDataFromDatabase
{
  
    
    if(self.waitUploadDataArray==nil||self.waitUploadDataArray.count==0){
       
//       //数据库只去一次。防止重复
        self.waitUploadDataArray = [NSMutableArray arrayWithArray:[_localDbservice queryUploadListLocalImg]];

    }
     NSLog(@"self.waitUploadDataArray .count=%ld",self.waitUploadDataArray .count);
       [self upLoadDataFromwaitUploadDataArray];
    return self.waitUploadDataArray .count;
}
#pragma mark - 开始上传
- (void)startUpLoad:(FPFamilyPhotoUploadDomain *)domain
{
    
    NSURL * localUrl = domain.localurl;
    
    [self.library assetForURL:localUrl resultBlock:^(ALAsset *asset)
     {
         
         if(asset==nil){
             //存入数据库
             FPUploadSaveUrlDomain * domainSave = [[FPUploadSaveUrlDomain alloc] init];
             domainSave.status = 3;//失败
             domainSave.localUrl = [domain.localurl absoluteString];
             domainSave.family_uuid=domain.family_uuid;
             
            [self saveFPUploadSaveUrlDomain:domainSave uploadDomain:domain];
             return;
         }
         //获取大图
         UIImage * img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
         //获取时间
         NSString * date = [asset valueForProperty:@"ALAssetPropertyDate"];
         
         [self upLoadPic:img photoTime:date  uploadDomain:domain];
     }
             failureBlock:^(NSError *error)
     {
         NSLog(@"根据local url 查找失败");
     }];
}



- (void)upLoadPic:(UIImage *)img photoTime:(NSString *)photoTime  uploadDomain:(FPFamilyPhotoUploadDomain *)uploadDomain
{
    
    
    
    {
    
        //通知开始上传
        FPUploadSaveUrlDomain * domain = [[FPUploadSaveUrlDomain alloc] init];
        
//        domain.uuid=baseDomain.data_id;
        domain.localUrl = [uploadDomain.localurl absoluteString];
        domain.family_uuid=uploadDomain.family_uuid;
        domain.status = 2;//成功
        
        [self saveFPUploadSaveUrlDomain:domain uploadDomain:uploadDomain];
        
    }
    NSData *data;
    data = UIImageJPEGRepresentation(img, 0.1);
    NSString * phone_uuid=[KGUUID getUUID];//手机设备唯一标示
    NSString * phoneType = [UIDevice currentDevice].model;
    
    NSString * pathExtension=[uploadDomain.localurl pathExtension];
     NSString * filename=[ NSString stringWithFormat:@"f.%@",pathExtension ];
    NSDictionary * dict = @{
                            
                            @"family_uuid":uploadDomain.family_uuid,@"photo_time":photoTime,@"phone_type":phoneType,@"md5":[uploadDomain.localurl absoluteString],@"phone_uuid":phone_uuid,@"address":@""};
    NSLog(@"FPUploadImgUrl=%@",[KGHttpUrl getFPUploadImgUrl] );
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:[KGHttpUrl getFPUploadImgUrl] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        [formData appendPartWithFileData:data
                                                                    name:@"file"
                                                                fileName:filename
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
         domain.localUrl = [uploadDomain.localurl absoluteString];
         domain.family_uuid=uploadDomain.family_uuid;
         domain.status = 0;//成功
         
         [self saveFPUploadSaveUrlDomain:domain uploadDomain:uploadDomain];
         
         
         
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         //重新上传
         [self.waitUploadDataArray addObject:uploadDomain];
       
         [self upLoadDataFromwaitUploadDataArray];

         
     }];
    
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite)
     {
//         //通知更新进度条
//         CGFloat percent = totalBytesWritten * 1.0 /totalBytesExpectedToWrite * 1.0;
//         
//         dispatch_async(dispatch_get_main_queue(), ^
//                        {
//                            FPUploadCell * cell = [_cells objectAtIndex:index];
//                            [cell setPercent:percent];
//                        });
     }];
    
    // 5. Begin!
    [operation start];
}

//保存到数据库
/**
 //存入数据库
 FPUploadSaveUrlDomain * domainSave = [[FPUploadSaveUrlDomain alloc] init];
 domainSave.status = 3;//失败
 domainSave.localUrl = [domain.localurl absoluteString];
 domainSave.family_uuid=domain.family_uuid;
 [self saveFPUploadSaveUrlDomain:domainSave];
 */
- (void)saveFPUploadSaveUrlDomain:(FPUploadSaveUrlDomain *)domain uploadDomain:(FPFamilyPhotoUploadDomain *)uploadDomain
{
    [_localDbservice saveUploadImgPath:domain.localUrl status:[NSString stringWithFormat:@"%ld",(long)domain.status] family_uuid:domain.family_uuid uuid:domain.uuid];
    
    
    //存入数据库，通知相关界面更新
    NSNotification * noti0 = [[NSNotification alloc] initWithName:@"saveuploadimg" object:domain userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti0];
    
    if(domain.status==1){//添加等待数据
        return;
    }
    if(domain.status==2){//开始上传
        return;
    }
    
    if(domain.status==0){//上传成功
        [self.uploadingDataArray removeObject:uploadDomain];
//        //上传完毕后，发送通知
//        if(self.uploadingDataArray.count==0&&self.waitUploadDataArray.count==0){
//            //通知主页时光轴有数据更新
//            NSNotification * noti1 = [[NSNotification alloc] initWithName:@"updatePhotoToRemoteFinish" object:nil userInfo:nil];
//            
//            [[NSNotificationCenter defaultCenter] postNotification:noti1];
//            
//
//        }
        
         [self upLoadDataFromwaitUploadDataArray];
        
        
        
        
    
        NSString *countStr=[NSString stringWithFormat:@"%ld",self.waitUploadDataArray.count+self.uploadingDataArray.count];
        
        //通知主页时光轴有数据更新
        NSNotification * noti1 = [[NSNotification alloc] initWithName:@"canUpDatePhotoData" object:countStr userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:noti1];
        


        return;
    }
   
    
   
}
//4G上传提示，用户确认
- (BOOL)uploadBy4GuserConfirm{
    
    //确认允许4G上传标记。
    if(self.isUploadBy4G==YES){
//        [self upLoadDataFromwaitUploadDataArray];
        return NO;
    }
    //wifi直接上传
    if([self.wifiStatus isReachableViaWiFi]){
//        [self upLoadDataFromwaitUploadDataArray];
        return NO;
        
    }    //4G判断
    {
        //提示窗口，只谈一次。
        if(self.isShowAlertView==YES){
            return YES;
        }
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"请确认" message:@"不是wifi环境，使用移动流量，是否要上传?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [al show];
        return YES;
    }

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    self.isShowAlertView==NO;
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        self.isUploadBy4G=YES;
         [self upLoadDataFromwaitUploadDataArray];
    }
}

@end
