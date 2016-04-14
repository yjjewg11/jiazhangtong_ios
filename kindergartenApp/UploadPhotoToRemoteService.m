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
static NSInteger maxUploadingNumber=1;
DBNetDaoService * _localDbservice;
//带上传队列
NSMutableArray * waitUploadDataArray;
//上传队列
NSMutableArray * uploadingDataArray;

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
                      uploadingDataArray=[NSMutableArray array];
                      
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
+ (void)upLoadAllFromLocalDB{
   
    [[UploadPhotoToRemoteService getService] upLoadDataFromDatabase];
}
//添加到新数据到数据库和，开始上传
+ (void)addPhotoUploadDomain:(FPFamilyPhotoUploadDomain *)domain{
    UploadPhotoToRemoteService * s=[UploadPhotoToRemoteService getService];
    
    FPUploadSaveUrlDomain * savedomain = [[FPUploadSaveUrlDomain alloc] init];
    
    savedomain.localUrl = [domain.localurl absoluteString];
    savedomain.family_uuid=domain.family_uuid;
    savedomain.status = 1;//等待

    [s addToWaitFPFamilyPhotoUploadDomain:domain];
    
}
- (void)addToWaitFPFamilyPhotoUploadDomain:(FPFamilyPhotoUploadDomain *)domain{
    [waitUploadDataArray addObject:domain];
    [self upLoadDataFromWaitUploadDataArray];
}
+ (void)upLoadFPFamilyPhotoUploadDomain:(FPFamilyPhotoUploadDomain *)domain{
    
    [[UploadPhotoToRemoteService getService]startUpLoad:domain];
}
- (void)upLoadDataFromWaitUploadDataArray
{
    if(waitUploadDataArray.count==0)return;
    
    while(waitUploadDataArray.count>0&&uploadingDataArray.count<maxUploadingNumber){
        FPFamilyPhotoUploadDomain * domain=waitUploadDataArray[0];
        [uploadingDataArray addObject:domain];
        [waitUploadDataArray removeObject:domain];
        
        [self startUpLoad:domain];
        NSLog(@"uploadingDataArray.count=%ld",uploadingDataArray.count);
    }

}

- (void)upLoadDataFromDatabase
{
  
    
    if(waitUploadDataArray.count>0){
        NSLog(@"waitUploadDataArray .count=%ld",waitUploadDataArray .count);
        return;
    }
    waitUploadDataArray = [NSMutableArray arrayWithArray:[_localDbservice queryUploadListLocalImg]];
    [self upLoadDataFromWaitUploadDataArray];

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
         UIImage * img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
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
    NSData *data;
    data = UIImageJPEGRepresentation(img, 0.1);
    NSString * phone_uuid=[KGUUID getUUID];//手机设备唯一标示
    NSString * phoneType = [UIDevice currentDevice].model;

    
    NSDictionary * dict = @{
                            
                            @"family_uuid":uploadDomain.family_uuid,@"photo_time":photoTime,@"phone_type":phoneType,@"md5":[uploadDomain.localurl absoluteString],@"phone_uuid":phone_uuid,@"address":@""};
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
         domain.localUrl = [uploadDomain.localurl absoluteString];
         domain.family_uuid=uploadDomain.family_uuid;
         domain.status = 0;//成功
         
         [self saveFPUploadSaveUrlDomain:domain uploadDomain:uploadDomain];
         
         
         
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         //重新上传
         [waitUploadDataArray addObject:uploadDomain];
       
         [self upLoadDataFromWaitUploadDataArray];

         
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
    
    
    [uploadingDataArray removeObject:uploadDomain];
    [self upLoadDataFromWaitUploadDataArray];
}


@end
