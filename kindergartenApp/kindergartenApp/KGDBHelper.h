//
//  FuniDBHelper.h
//  FuniDBHelper
//
//  Created by You on 14/11/10.
//  Copyright (c) 2014年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDbId @"id__"
#define kDbData @"modelData"
#define appDataBaseName   @"dbhelper.sqlite"
#define wherePage    @"page"
#define wherePageSize  @"pageSize"

@protocol KGDBHelper

@required

/**
 *	@brief	对象id，唯一标志
 */
//@property (assign, nonatomic, readonly) NSInteger    id__;


/**
 *	@brief	插入到数据库中
 */
- (BOOL)save;

/**
 *	@brief	更新某些数据
 *
 *	@param 	where 	条件
 *
 */
- (BOOL)updateByWhere:(NSMutableDictionary *)whereMDict NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

/**
 *	@brief	更新数据到数据库中
 *
 *	@return	更新成功YES,否则NO
 */
- (BOOL)update;

/**
 *	@brief	从数据库删除对象
 *
 *	@return	更新成功YES,否则NO
 */
- (BOOL)deleteObj;


/**
 *  清空表
 *
 *  @return 是否操作成功
 */
+ (BOOL)deleteAll;


/**
 *	@brief	查看是否包含对象
 *
 *	@param 	where 	条件
 *
 *	@return	包含YES,否则NO
 */
+ (BOOL)existObjByWhere:(NSMutableDictionary *)whereMDict;

/**
 *	@brief	删除某些数据
 *
 *	@param 	where 	条件
 *
 *	@return 成功YES,否则NO
 */
+ (BOOL)deleteObjByWhere:(NSMutableDictionary *)whereMDict;


/**
 *	@brief	根据条件取出某些数据
 *
 *	@param 	where 	条件
 *
 *	@param 	orderby 	排序
 *          例：name and age
 *
 *	@return	数据
 */
+ (NSMutableArray *)selectObjsByWhere:(NSMutableDictionary *)whereMDict orderby:(NSString *)orderby;


/**
 *  根据主键id加载
 *
 *  @param uid
 *
 *  @return
 */
+ (instancetype)initObjById:(NSString *)uid;



/**
 *	@brief	取出所有数据
 *
 *	@return	数据
 */
+ (NSMutableArray *)selectAll;


@end

@interface KGDBHelper : NSObject<KGDBHelper>

/**
 *	@brief	对象id，唯一标志
 */
@property (assign, nonatomic) NSInteger id__;


/**
 *  model对象数据
 */
@property (strong, nonatomic) NSData * modelData;


/**
 *	@brief	失效日期
 */
@property (assign, nonatomic) NSDate *expireDate;


/**
 *  属性copy
 *
 *  @param obj 源对象
 */
- (void)copyPerperties:(KGDBHelper *)obj;

@end
