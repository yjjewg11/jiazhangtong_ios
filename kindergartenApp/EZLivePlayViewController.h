//
//  EZLivePlayViewController.h
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/10/28.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZDeviceInfo.h"
#import "EZCamrea.h"
@interface EZLivePlayViewController : UIViewController

@property (nonatomic, strong) EZDeviceInfo *deviceInfo;
@property (nonatomic) NSInteger cameraIndex;

@property (nonatomic, copy) NSString *cameraId;
@property (nonatomic, copy) NSString *cameraName;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) EZCamrea * domain;

- (void)imageSavedToPhotosAlbum:(UIImage *)image
       didFinishSavingWithError:(NSError *)error
                    contextInfo:(void *)contextInfo;


- (void)setDomain:(EZCamrea *)domain;

@end
