//
//  FuniDBHelper.m
//  FuniDBHelper
//
//  Created by You on 14/11/10.
//  Copyright (c) 2014年 funi. All rights reserved.
//

#import "KGDBHelper.h"
#import "KGDBHelperHandle.h"
#import "objc/runtime.h"
#import "MJExtension.h"

@implementation KGDBHelper

- (id)init
{
    self = [super init];
    if (self) {
        [KGDBHelperHandle shareDb].dataBaseName = appDataBaseName;
    }
    return self;
}


//- (void)encodeWithCoder:(NSCoder *)encoder {
//    Class cls = [self class];
//    while (cls != [NSObject class]) {
//        unsigned int outCount = 0;
//        objc_property_t *properties = class_copyPropertyList(cls, &outCount);
//        for (int i = 0; i < outCount; i++) {
//            
//            objc_property_t property = properties[i];
//            NSString *key=[[NSString alloc] initWithCString:property_getName(property)
//                                                   encoding:NSUTF8StringEncoding];
//            
//            id value=[self valueForKey:key];
//            if (value && key) {
//                if ([value isKindOfClass:[NSObject class]]) {
//                    [encoder encodeObject:value forKey:key];
//                } else {
//                    NSNumber * v = [NSNumber numberWithInt:(int)value];
//                    [encoder encodeObject:v forKey:key];
//                }
//            }
//        }
//        free(properties);
//        properties = NULL;
//        cls = class_getSuperclass(cls);
//    }
//    
//    
//}
//
//- (id)initWithCoder:(NSCoder *)decoder {
//    self = [self init];
//    
//    if (self) {
//        Class cls = [self class];
//        while (cls != [NSObject class]) {
//            unsigned int outCount = 0;
//            objc_property_t *properties = class_copyPropertyList(cls, &outCount);
//            
//            @try {
//                for (int i = 0; i < outCount; i++) {
//                    objc_property_t property = properties[i];
//                    NSString *key=[[NSString alloc] initWithCString:property_getName(property)
//                                                           encoding:NSUTF8StringEncoding];
//                    id value = [decoder decodeObjectForKey:key];
//                    [self setValue:value forKey:key];
//                }
//            }
//            @catch (NSException *exception) {
//                NSLog(@"Exception: %@", exception);
//                return nil;
//            }
//            @finally {
//                
//            }
//            
//            free(properties);
//            
//            cls = class_getSuperclass(cls);
//        }
//    }
//    
//    return self;
//}


- (NSData *)selfConvertData {
    NSDictionary * dict = self.keyValues;
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:dict];
//    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;
}


/**
 *	@brief	插入到数据库中
 */
- (BOOL)save
{
    self.modelData = [self selfConvertData];
    BOOL isSuccess = [KGDBHelperHandle insertDbObject:self];
    return isSuccess;
}

/**
 *	@brief	更新某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 */
- (BOOL)updateByWhere:(NSMutableDictionary *)whereMDict NS_DEPRECATED(10_0, 10_4, 2_0, 2_0)
{
    self.modelData = [self selfConvertData];
    return [KGDBHelperHandle updateDbObject:self conditionMDict:whereMDict];
}

/**
 *	@brief	更新数据到数据库中
 *
 *	@return	更新成功YES,否则NO
 */
- (BOOL)update
{
    self.modelData = [self selfConvertData];
    NSString *condition = [NSString stringWithFormat:@"%@=%ld", kDbId, (long)self.id__];
    return [KGDBHelperHandle updateDbObject:self condition:condition];
}

/**
 *	@brief	从数据库删除对象
 *
 *	@return	更新成功YES,否则NO
 */
- (BOOL)deleteObj
{
    NSString * where = [NSString stringWithFormat:@"%@=%ld", kDbId, (long)self.id__];
    return [KGDBHelperHandle removeDbObjects:[self class] condition:where];
}


/**
 *  清空表
 *
 *  @return 是否操作成功
 */
+ (BOOL)deleteAll {
    return [KGDBHelperHandle removeDbObjects:[self class] condition:nil];
}


/**
 *	@brief	查看是否包含对象
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 *	@return	包含YES,否则NO
 */
+ (BOOL)existObjByWhere:(NSMutableDictionary *)whereMDict
{
    [KGDBHelperHandle shareDb].dataBaseName = appDataBaseName;
    NSArray *objs = [KGDBHelperHandle selectDbObjects:[self class] condition:whereMDict orderby:nil];
    if ([objs count] > 0) {
        return YES;
    }
    return NO;
}

/**
 *	@brief	删除某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *          填入 all 为全部删除
 *
 *	@return 成功YES,否则NO
 */
+ (BOOL)deleteObjByWhere:(NSMutableDictionary *)whereMDict
{
    [KGDBHelperHandle shareDb].dataBaseName = appDataBaseName;
    return [KGDBHelperHandle removeDbObjects:[self class] conditionMDict:whereMDict];
}


/**
 *	@brief	根据条件取出某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *          填入 all 为全部
 *
 *	@param 	orderby 	排序
 *          例：name and age
 *
 *	@return	数据
 */
+ (NSArray *)selectObjsByWhere:(NSMutableDictionary *)whereMDict orderby:(NSString *)orderby
{
    [KGDBHelperHandle shareDb].dataBaseName = appDataBaseName;
    return [KGDBHelperHandle selectDbObjects:[self class] condition:whereMDict orderby:orderby];
}


/**
 *  根据主键id加载
 *
 *  @param uid
 *
 *  @return
 */
+ (instancetype)initObjById:(NSString *)uid {
    NSMutableDictionary * mdict = [[NSMutableDictionary alloc] init];
    [mdict setValue:uid forKey:@"id"];
    NSArray * array = [KGDBHelper selectObjsByWhere:mdict orderby:nil];
    if([array count] > 0) {
        return [array objectAtIndex:0];
    }
    
    return [[KGDBHelper alloc] init];
}



/**
 *	@brief	取出所有数据
 *
 *	@return	数据
 */
+ (NSMutableArray *)selectAll
{
    [KGDBHelperHandle shareDb].dataBaseName = appDataBaseName;
//    return [FuniDBHelperHandle selectDbObjects:[self class] condition:@"all" orderby:nil];
    return [KGDBHelperHandle selectDbObjects:[self class] condition:nil orderby:nil];
}


/**
 *  属性copy
 *
 *  @param obj 源对象
 */
- (void)copyPerperties:(KGDBHelper *)obj {
    
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                               encoding:NSUTF8StringEncoding];
        
        id value=[obj valueForKey:key];
        if (value && key && ![key isEqualToString:kDbId]) {
            [self setValue:value forKey:key];
        }
    }
    free(properties);
    properties = NULL;
}


@end
