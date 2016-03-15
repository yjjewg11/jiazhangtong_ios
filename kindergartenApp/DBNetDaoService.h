//
//  DBNetDaoService.h
//  kindergartenApp
//
//  Created by Mac on 16/1/21.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPMyFamilyPhotoCollectionDomain.h"
#import "KGHttpService.h"
#import "FPFamilyInfoDomain.h"
#import "FPFamilyPhotoNormalDomain.h"

@interface DBNetDaoService : NSObject

- (void)getTimelinePhotos:(NSString *)familyUUID;

- (NSMutableArray *)getListTimeHeadData:(NSString *)familyuuid;

- (NSArray *)getListTimePhotoData:(NSString *)date familyUUID:(NSString *)familyUUID;

- (void)saveUploadImgPath:(NSString *)path status:(NSString *)status  family_uuid
:(NSString *)family_uuid;

+ (DBNetDaoService *)defaulService;

- (NSMutableArray *)queryLocalImg;

- (NSMutableArray *)queryUploadListLocalImg;

- (void)saveUploadImgListPath:(NSMutableArray *)localurls;

- (void)deleteUploadImg:(NSString *)localurl;

- (FPFamilyInfoDomain *)queryTimeByFamilyUUID:(NSString *)familyUUID;

- (void)addPhotoToDatabase:(NSArray *)photos;

- (void)updateMaxTime:(NSString *)familyUUID maxTime:(NSString *)maxTime minTime:(NSString *)minTime uptime:(NSString *)updateTime;

- (NSArray *)queryPicDetailByDate:(NSString *)date pageNo:(NSString *)pageNo familyUUID:(NSString *)familyUUID;

- (void)updatePhotoItemInfo:(FPFamilyPhotoNormalDomain *)domain;

- (void)deletePhotoItem:(NSString *)uuid;

@end
