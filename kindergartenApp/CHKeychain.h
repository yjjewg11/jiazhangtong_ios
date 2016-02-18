//
//  CHKeychain.h
//  OPENUDID+KEYCHAIN
//
//  Created by Adan on 14/12/10.
//  Copyright (c) 2014年 Adan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface CHKeychain : NSObject

+ (void)saveByKey:(NSString *)key data:(id)data;
+ (id)readByKey:(NSString *)key;
+ (void)deleteByKey:(NSString *)key;

@end
