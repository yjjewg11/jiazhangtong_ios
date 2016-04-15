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

/**
 重新从数据库获取数据，全部上传。只允许调一次。启动时，防止数据冲突
 */
+ (NSInteger)upLoadAllFromLocalDB;

//添加到新数据到数据库和，开始上传
+ (void)addPhotoUploadDomain:(FPFamilyPhotoUploadDomain *)domain;

+ (void)pauseUploadAll;

//是否正在上传
+ (BOOL)isUpoading;

@property (nonatomic , strong) ALAssetsLibrary * library;


@property (nonatomic , strong)Reachability * wifiStatus; //网络状态
@property  BOOL  isUploadBy4G;//允许4G上传
@property  BOOL  isShowAlertView;//是否显示alertView
@property  BOOL  isPauseUpload;//是否暂停上传标示。
+ (ALAssetsLibrary *)defaultAssetsLibrary;
//上传队列
@property NSMutableArray * uploadingDataArray;

//带上传队列
@property NSMutableArray * waitUploadDataArray;

@end
