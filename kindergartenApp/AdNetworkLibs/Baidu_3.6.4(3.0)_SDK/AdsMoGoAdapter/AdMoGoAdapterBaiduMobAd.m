//
//  File: AdMoGoAdapterBaiduMobAd.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterBaiduMobAd.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdSDKBannerNetworkRegistry.h"

#define kAdMoGoBaiduAppIDKey @"AppID"
#define kAdMoGoBaiduAppSecretKey @"AppSEC"


@implementation AdMoGoAdapterBaiduMobAd

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeBaiduMobAd;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd{
    [self performSelectorOnMainThread:@selector(baidugetAd) withObject:nil waitUntilDone:NO];
}

- (void)baidugetAd{
    isStop = NO;
    isLoad = NO;
    isShow = NO;
    [adMoGoCore adDidStartRequestAd];
    
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    isLocationOn = [configData islocationOn];
    AdViewType type = [configData.ad_type intValue];
    CGSize size = CGSizeZero;
    
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = kBaiduAdViewBanner320x48;
            break;
        case AdViewTypeiPhoneRectangle:
            size = kBaiduAdViewSquareBanner300x250;
            break;
        case AdViewTypeMediumBanner:
            size = kBaiduAdViewBanner468x60;
            break;
        case AdViewTypeLargeBanner:
            size = kBaiduAdViewBanner728x90;
            break;
        case AdViewTypeRectangle:
            size = kBaiduAdViewSquareBanner600x500;
            break;
        default:
            [adMoGoCore adapter:self didGetAd:@"baidu"];
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    AdMoGoBaiduSingleton *baiduSingleton = [AdMoGoBaiduSingleton singleton];
    baiduSingleton.delegate = self;
    UIViewController *viewcontroller = [adMoGoDelegate viewControllerForPresentingModalView];
    
    [baiduSingleton createBaiduBannerWithConfig:self.ration withSize:size withView:viewcontroller.view];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopBeingDelegate{

    
    
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}

- (BOOL)isSDKSupportClickDelegate{
    return YES;
}



- (void)stopAd{
    isStop = true;
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    
    [[AdMoGoBaiduSingleton singleton] hiddenBaiduBanner];
}

- (void)willDisplayAd:(BaiduMobAdView*)adView{
    [self stopTimer];
    [adMoGoCore adapter:self didGetAd:@"baidu"];
    [adMoGoCore baiduAddAdViewAdapter:self didReceiveAdView:adView];
}
- (void)didAdImpressed{
    if (isStop) {
        return;
    }
    if (!isLoad) {
        isLoad = YES;
    }else{
        return;
    }
    [self stopTimer];
    [adMoGoCore baiduSendRIB];
}
- (void)clickAd{
    if (isStop) {
        return;
    }
    
    [adMoGoCore performSelectorOnMainThread:@selector(sdkplatformSendCLK:) withObject:self waitUntilDone:NO];
}

- (void)failDisplayAd{
    
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didFailAd:nil];
}



- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}



@end