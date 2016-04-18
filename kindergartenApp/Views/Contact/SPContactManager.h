//
//  SPContactManager.h
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/21.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXOpenIMSDKFMWK/YWPerson.h>

@interface SPContactManager : NSObject

+ (instancetype)defaultManager;

- (NSArray *)fetchContactPersonIDs;

- (BOOL)existContact:(YWPerson *)person;
- (BOOL)addContact:(YWPerson *)person;
- (BOOL)removeContact:(YWPerson *)person;

@end
