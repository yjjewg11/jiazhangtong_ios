//
//  GlobalMap.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/14.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "GlobalMap.h"

@implementation GlobalMap


+ (GlobalMap *)getGlobalMap
{
    static dispatch_once_t pred = 0;
    static GlobalMap * globalMap = nil;
    dispatch_once(&pred,^
                  {
                      globalMap = [[GlobalMap alloc] init];
                      globalMap.map=[[NSMutableDictionary alloc]init];
                  });
    return globalMap;
}

+ (NSString *)objectForKey:(id) key{
    
    return [[GlobalMap getGlobalMap].map objectForKey:key];
}
+ (void)setObject:(id)object forKey:(id)aKey{
    [[GlobalMap getGlobalMap].map  setObject:object forKey:aKey];
}

@end
