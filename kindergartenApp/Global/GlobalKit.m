//
//  GlobalKit.m
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/10/27.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import "GlobalKit.h"

@implementation GlobalKit

+ (instancetype)shareKit
{
    static GlobalKit *kit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kit = [GlobalKit new];
    });
    return kit;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"EZOpenSDKAccessToken"];
        _deviceVerifyCodeBySerial = [NSMutableDictionary new];
    }
    return self;
}


- (void)setAccessToken:(NSString *)accessToken
{
    _accessToken = accessToken;
    [[NSUserDefaults standardUserDefaults] setObject:accessToken?:@"" forKey:@"EZOpenSDKAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearSession
{
    _accessToken = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EZOpenSDKAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearDeviceInfo
{
    self.deviceVerifyCode = nil;
    self.deviceSerialNo = nil;
    self.deviceModel = nil;
}

@end
