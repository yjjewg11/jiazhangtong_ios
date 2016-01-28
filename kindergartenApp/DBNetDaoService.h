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

@interface DBNetDaoService : NSObject

- (void)getTimelinePhotos:(NSString *)familyUUID;

- (NSArray *)getListTimeHeadData:(NSString *)familyuuid;

- (NSArray *)getListTimePhotoData:(NSString *)date familyUUID:(NSString *)familyUUID;

@end
