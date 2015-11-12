//
//  AdMoGoBaiduSingleton.m
//  AdsMoGoSample
//
//  Created by hale on 15/9/22.
//  Copyright (c) 2015年 MOGO. All rights reserved.
//

#define kAdMoGoBaiduAppIDKey @"AppID"
#define kAdMoGoBaiduAppSecretKey @"AppSEC"
#define kAdMoGoBaiduAdPlaceID @"AdPlaceID"
#import "AdMoGoBaiduSingleton.h"
#import "BaiduMobAdView.h"
@interface AdMoGoBaiduSingleton()<BaiduMobAdViewDelegate>{
   
}
@property (nonatomic,retain) NSString *appid;
@property (nonatomic,retain) NSString *adPlaceID;
@property (nonatomic,retain) BaiduMobAdView *baiduBanner;
@end

@implementation AdMoGoBaiduSingleton
static AdMoGoBaiduSingleton *sharedInstance_ = nil;
static BOOL isFirst = YES;
+(id) singleton{
    if(!sharedInstance_)
    {
        sharedInstance_ = [NSAllocateObject([self class], 0, NULL) init];
        
    }
    return sharedInstance_;
}

+ (id) allocWithZone:(NSZone *)zone
{
    
    return [[self singleton] retain];
}


- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax; // denotes an object that cannot be released
}

/*
 如果使用 Apple LLVM complier 3.1 编译器 要添加在放回类型中添加oneway
 */
- (oneway void) release
{
    // do nothing
}

- (id) autorelease
{
    return self;
}


- (void)dealloc{
    [super dealloc];
}

- (void)createBaiduBannerWithConfig:(NSDictionary *)key_dict withSize:(CGSize) size withView:(UIView *)view{
    NSString *ad_place_id = [self getAdPlaceID:key_dict];
    NSString *ad_app_id = [self getAppID:key_dict];
    if (self.baiduBanner==NULL ||
        ![self.appid isEqualToString:ad_app_id] ||
        ![self.adPlaceID isEqualToString:ad_place_id]) {
        [self destoryBanner];
        self.appid = ad_app_id;
        self.adPlaceID = ad_place_id;
    }
    [self buildBaiduBanner:size withView:view];
    if (isFirst) {
        isFirst = NO;
        return;
    }
    [self loadBaiduBanner];
}

- (void)hiddenBaiduBanner{
    if (self.baiduBanner) {
        self.baiduBanner.hidden = YES;
        [self.baiduBanner removeFromSuperview];
    }
    
}

- (void)buildBaiduBanner:(CGSize) size withView:(UIView *)view{
    if (self.baiduBanner==NULL) {
        _baiduBanner = [[BaiduMobAdView alloc] init];
        
        _baiduBanner.hidden = YES;
        _baiduBanner.autoplayEnabled = NO;
        
        //把在mssp.baidu.com上新建获得的广告位id设置到这里
        
        if (self.adPlaceID && ![self.adPlaceID isEqualToString:@""]) {
            _baiduBanner.AdUnitTag = self.adPlaceID;
        } else {
            _baiduBanner.AdUnitTag = @"";
        }
        
        _baiduBanner.frame = CGRectMake(0.0, -500.0,size.width,size.height);
        [view addSubview:_baiduBanner];
        _baiduBanner.delegate = self;
        [_baiduBanner start];
        
    }else{
        _baiduBanner.frame = CGRectMake(0.0, -500.0,size.width,size.height);
        [view addSubview:_baiduBanner];
        self.baiduBanner.hidden = NO;
        self.baiduBanner.delegate = self;
    }
}

- (void)loadBaiduBanner{
    if(self.baiduBanner){
        NSLog(@"baidu version %@",[self.baiduBanner Version]);
        [self.baiduBanner start];
    }
}

- (void)destoryBanner{
    if (self.baiduBanner) {
        self.baiduBanner.delegate = nil;
        [self.baiduBanner removeFromSuperview];
        self.baiduBanner = nil;
    }
}

- (NSString *)getAppID:(NSDictionary *)key_dict{
    id key =  [key_dict objectForKey:@"key"];
    id appID;
    NSString *appIDStr = NULL;
    if (key != nil && ([key isKindOfClass:[NSDictionary class]])) {
        appID = [key objectForKey:kAdMoGoBaiduAppIDKey];
        if (appID != nil && ([appID isKindOfClass:[NSString class]])) {
            appIDStr = [NSString stringWithString:appID];
        }
    }
    return appIDStr;
}

- (NSString *)getAdPlaceID:(NSDictionary *)key_dict{
    id key =  [key_dict objectForKey:@"key"];
    id appID;
    NSString *adPlaceIDStr = NULL;
    if (key != nil && ([key isKindOfClass:[NSDictionary class]])) {
        appID = [key objectForKey:kAdMoGoBaiduAdPlaceID];
        if (appID != nil && ([appID isKindOfClass:[NSString class]])) {
            adPlaceIDStr = [NSString stringWithString:appID];
        }
    }
    return adPlaceIDStr;
}


/**
 *  应用的APPID
 */
- (NSString *)publisherId{
    return self.appid;
}

/**
 *  设置成聚合平台的渠道id
 */
- (NSString*) channelId
{
    return @"13b50d6f";
}

/**
 *  广告将要被载入
 */
-(void) willDisplayAd:(BaiduMobAdView*) adview {
    adview.frame = CGRectOffset(adview.frame, 0.0f, 500.0f);

    if ([adview superview] != NULL) {
        [adview removeFromSuperview];
    }
    adview.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(willDisplayAd:)]) {
        [self.delegate willDisplayAd:adview];
    }
}


-(void) didAdImpressed {
    if ([self.delegate respondsToSelector:@selector(didAdImpressed)]) {
        [self.delegate didAdImpressed];
    }
}


-(void) didAdClicked{
    if ([self.delegate respondsToSelector:@selector(clickAd)]) {
        [self.delegate clickAd];
    }
}

-(void) didDismissLandingPage {
    
}

-(void) failedDisplayAd:(BaiduMobFailReason) reason {
    if ([_baiduBanner superview] != NULL) {
        [_baiduBanner removeFromSuperview];
    }
    
    if ([self.delegate respondsToSelector:@selector(failDisplayAd)]) {
        [self.delegate failDisplayAd];
    }
}

@end
