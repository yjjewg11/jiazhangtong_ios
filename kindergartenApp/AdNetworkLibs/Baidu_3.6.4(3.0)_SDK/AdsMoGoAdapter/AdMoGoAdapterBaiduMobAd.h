//
//  File: AdMoGoAdapterBaiduMobAd.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//Baidu v2.0

#import "AdMoGoAdNetworkAdapter.h"
#import "BaiduMobAdView.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoBaiduSingleton.h"
@interface AdMoGoAdapterBaiduMobAd : AdMoGoAdNetworkAdapter <AdMoGoBaiduSingletonDelegate>{
    NSTimer *timer;
    BOOL isStop;
    BaiduMobAdView* sBaiduAdview;
    BOOL isLocationOn;
    BOOL isLoad;
    BOOL isShow;
}
- (void)loadAdTimeOut:(NSTimer*)theTimer;
+ (AdMoGoAdNetworkType)networkType;
@end
