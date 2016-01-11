//
//  RouteDomain.h
//  kindergartenApp
//
//  Created by Mac on 16/1/8.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteDomain : NSObject

@property (strong, nonatomic) NSString * routeName;

@property (strong, nonatomic) NSString * routeTime;

@property (strong, nonatomic) NSString * routeFar;

@property (strong, nonatomic) NSString * routeWalkMiles;

@property (assign, nonatomic) NSInteger count;

@property (strong, nonatomic) NSMutableArray * instructionArr;

@property (assign, nonatomic) NSInteger type; //0 公交 , 1 开车 , 2步行

@property (strong, nonatomic) BMKRouteLine * plan;

@end
