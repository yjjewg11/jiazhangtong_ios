//
//  SPContactManager.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/21.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPContactManager.h"
#import "SPUtil.h"
#import "SPKitExample.h"
#import <WXOUIModule/YWIndicator.h>

#define __SPContactsOfEService \
@[ \
kSPEServicePersonId, \
]

#define __SPContactsOfDevelopers \
@[ \
@"uid1", \
@"uid2", \
@"uid3", \
@"uid4", \
@"uid5", \
@"uid6", \
@"uid7", \
@"uid8", \
@"uid9", \
@"uid10", \
]

#define __SPContactsOfSections \
@[ \
kSPEServicePersonIds, \
kSPWorkerPersonIds, \
__SPContactsOfDevelopers, \
]

@interface SPContactManager ()
@property (strong, nonatomic) NSMutableArray *contactIDs;
@end


@implementation SPContactManager

+ (instancetype)defaultManager {
    static SPContactManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[SPContactManager alloc] init];
    });
    return defaultManager;
}

- (NSMutableArray *)contactIDs {
    if (!_contactIDs) {
        _contactIDs = [NSMutableArray arrayWithContentsOfFile:[self storeFilePath]];
        if (!_contactIDs) {
            _contactIDs = [NSMutableArray array];
            for (NSArray *contacts in __SPContactsOfSections) {
                [_contactIDs addObjectsFromArray:contacts];
            }
            [_contactIDs writeToFile:[self storeFilePath] atomically:YES];
        }
    }
    return _contactIDs;
}

- (NSArray *)fetchContactPersonIDs {
    return self.contactIDs;
}

- (BOOL)existContact:(YWPerson *)person {
    return [self.contactIDs containsObject:person.personId];
}

- (BOOL)addContact:(YWPerson *)person {
    if (!person.personId) {
        return NO;
    }
        
    [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] addContact:person withIntroduction:@"" withResultBlock:^(NSError *error, YWAddContactRequestResult result) {
        NSString *title = nil;
        if(result == YWAddContactRequestResultError) {
            title = @"请求发送失败";
        } else if (result == YWAddContactRequestResultSuccess) {
            title = @"好友添加成功";
        } else {
            title = @"请求发送成功，等待对方验证";
        }
        [YWIndicator showTopToastTitle:title content:[NSString stringWithFormat:@"添加%@", person.personId] userInfo:nil withTimeToDisplay:1.5 andClickBlock:nil];
    }];
    return YES;

}
- (BOOL)removeContact:(YWPerson *)person {
    if (!person.personId) {
        return NO;
    }
    if (![self existContact:person]) {
        return NO;
    }

    [self.contactIDs removeObject:person.personId];

    return [self saveContactIDs];
}

- (BOOL)saveContactIDs {
    if (_contactIDs) {
        return [_contactIDs writeToFile:[self storeFilePath] atomically:YES];
    }
    return YES;
}
- (NSString *)storeFilePath {
    NSString* path = [[NSSearchPathForDirectoriesInDomains(
                                                           NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SPContacts.plist"];
    return path;
}

@end
