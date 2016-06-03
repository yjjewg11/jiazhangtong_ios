//
//  EZCamrea.h
//  kindergartenApp
//
//  Created by liumingquan on 16/6/1.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface EZCamrea : KGBaseDomain
@property (copy, nonatomic) NSString * cameraId;
@property (copy, nonatomic) NSString * cameraName;

@property (copy, nonatomic) NSString * picUrl;
@property (assign, nonatomic) Boolean isOnline;

@property (copy, nonatomic) NSString * channelNo;
@property (copy, nonatomic) NSString * deviceSerial;
@end
