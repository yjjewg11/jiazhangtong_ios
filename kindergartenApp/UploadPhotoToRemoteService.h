//
//  UploadPhotoToRemoteService.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/14.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "DBNetDaoService.h"
#import "KGDateUtil.h"
#import "UIImageView+WebCache.h"
#import "KGHttpService.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KGUUID.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "KGHttpUrl.h"
#import "FPUploadSaveUrlDomain.h"
#import "NSObject+MJKeyValue.h"
#import "FPFamilyPhotoUploadDomain.h"

@interface UploadPhotoToRemoteService : NSObject
+ (UploadPhotoToRemoteService *)getService;

+ (void)upLoadAll;
+ (void)addPhotoUploadDomain:(FPFamilyPhotoUploadDomain *)domain;
@property (nonatomic , strong) ALAssetsLibrary * library;


@property (nonatomic , strong)Reachability * wifiStatus; //网络状态
@property  BOOL  isUploadBy4G;//允许4G上传
/**
 重新从数据库获取数据，全部上传。只允许调一次。启动时，防止数据冲突
 */
+ (void)upLoadAllFromLocalDB;
+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end
