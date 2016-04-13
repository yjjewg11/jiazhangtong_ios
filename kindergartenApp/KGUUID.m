//
//  KGUUID.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/13.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGUUID.h"
#import "KeyChainStore.h"
@implementation KGUUID

+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[KeyChainStore load:KEY_USERNAME_PASSWORD];
   
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
         NSLog(@"createv KGUUID=%@",strUUID);
        //将该uuid保存到keychain
         [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
     NSLog(@"KGUUID=%@",strUUID);
    return strUUID;
}
@end
