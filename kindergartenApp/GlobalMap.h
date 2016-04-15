//
//  GlobalMap.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/14.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NSUserDefaults_Key_FPMyFamilyPhotoCollection   @"FPMyFamilyPhotoCollection"     //用户偏好存储key
//内存全局数据存放。重启后失效
@interface GlobalMap : NSObject
    @property (strong, nonatomic) NSMutableDictionary * map;

+ (NSString *)objectForKey:(id) key;
+ (void)setObject:(id)object forKey:(id)aKey;
@end
