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
#import "LoginRespDomain.h"

@interface DBNetDaoService : NSObject
- (void)restAllTable;
- (int)getfp_photo_item_count:(NSString *)familyUUID;
- (void)getTimelinePhotos:(NSString *)familyUUID;

- (NSMutableArray *)getListTimeHeadData:(NSString *)familyuuid;
- (void)updateUpdateTime:(NSString *)familyuuid updatetime:(NSString *)updatetime;

- (NSArray *)getListTimePhotoData:(NSString *)date familyUUID:(NSString *)familyUUID;

- (void)saveUploadImgPath:(NSString *)localurl status:(NSString *)status family_uuid:(NSString *)family_uuid uuid:(NSString *)uuid;

+ (DBNetDaoService *)defaulService;

- (NSMutableArray *)queryLocalImg;

- (NSMutableArray *)queryUploadListLocalImg;

- (void)saveUploadImgListPath:(NSMutableArray *)localurls;

- (void)deleteUploadImg:(NSString *)localurl;
- (void)updateFPPhotoUpdateCountWithFamilyUUID:(NSString *)familyUUID  success:(void(^)(NSString * status))success faild:(void(^)(NSString * errorMsg))faild;
- (FPFamilyInfoDomain *)queryTimeByFamilyUUID:(NSString *)familyUUID;
- (void)updateMaxTime:(FPFamilyInfoDomain *)domain;

- (void)addPhotoToDatabase:(NSArray *)photos;

- (void)updateMaxTime:(NSString *)familyUUID maxTime:(NSString *)maxTime minTime:(NSString *)minTime uptime:(NSString *)updateTime;

- (NSArray *)queryPicDetailByDate:(NSString *)date pageNo:(NSString *)pageNo familyUUID:(NSString *)familyUUID;

- (BOOL)updatePhotoItemInfo:(FPFamilyPhotoNormalDomain *)domain;

- (void)deletePhotoItem:(NSString *)uuid;
#pragma mark - 查询分页查询
- (NSMutableArray *)getListTimePhotoDataByPage:(NSString *)date familyUUID:(NSString *)familyUUID pageNo: (NSInteger) pageNo  limit: (NSInteger) limit;

- (NSString *)getfp_upload_localurl:(NSString *)uuid
;
- (void)update_fp_uploadOfUuid:(NSString *)uuid; 
@end
