//
//  SPCustomerService.m
//  WXOpenIMSampleDev
//
//  Created by sidian on 15/10/20.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPCustomerService.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

#import <YWExtensionForCustomerServiceFMWK/YWExtensionForCustomerServiceFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

@implementation SPCustomerService

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{// 这些操作需要等待SDK初始化完成
            
            YWPerson *person = [[YWPerson alloc] initWithPersonId:@"testpro55"];
            // 所有的轨迹都需要指定一个person对象，如果不指定，将会使用YWSDKTypeFree类型的YWIMCore登录成功之后获取的person对象
            [YWExtensionServiceFromProtocol(IYWExtensionForCustomerService) setYWCSPerson:person];
            
            // 在需要更新信息的地方可以调用
            [YWExtensionServiceFromProtocol(IYWExtensionForCustomerService) updateExtraInfoWithExtraUI:@"{\"Key1\":\"Value1\"}" andExtraParam:@"透传内容" withCompletionBlock:nil];
        });
        

        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
    }];
}

@end
