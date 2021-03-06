//
//  FFMovieShareData.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/5.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPMoive4QDomain.h"
#import "FPImagePickerImageDomain.h"
#import "FFMoiveSubmitView.h"
@interface FFMovieShareData : NSObject
@property (strong, nonatomic) FPMoive4QDomain * domain;
//<string ,FPImagePickerImageDomain>
@property (strong, nonatomic) NSMutableDictionary * selectDomainMap;
@property   CGFloat vcHeight;
//精品相册多个操作步骤，共享数据。
+ (FFMovieShareData *)getFFMovieShareData;

+ (NSString *)getFFMovie_photo_uuids;

+ (FFMoiveSubmitView *)createBottomView:(UIView *) view;
@end
