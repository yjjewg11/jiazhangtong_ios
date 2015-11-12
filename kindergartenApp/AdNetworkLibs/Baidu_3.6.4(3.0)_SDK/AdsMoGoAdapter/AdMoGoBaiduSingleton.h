//
//  AdMoGoBaiduSingleton.h
//  AdsMoGoSample
//
//  Created by hale on 15/9/22.
//  Copyright (c) 2015年 MOGO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaiduMobAdView;
@protocol AdMoGoBaiduSingletonDelegate <NSObject>
- (void)willDisplayAd:(BaiduMobAdView*)adView;
- (void)didAdImpressed;
- (void)clickAd;
- (void)failDisplayAd;
@end

@interface AdMoGoBaiduSingleton : NSObject
@property (nonatomic,assign) id<AdMoGoBaiduSingletonDelegate> delegate;
+ (id) singleton;

- (void)createBaiduBannerWithConfig:(NSDictionary *)key_dict withSize:(CGSize) size withView:(UIView *)view;
- (void)hiddenBaiduBanner;
@end
