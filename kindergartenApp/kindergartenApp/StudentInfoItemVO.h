//
//  StudentInfoItemVO.h
//  kindergartenApp
//
//  Created by You on 15/7/23.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentInfoItemVO : NSObject

@property (strong, nonatomic) NSString * head;
@property (strong, nonatomic) NSMutableArray * contentMArray;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) CGFloat headHeight;
@property (assign, nonatomic) BOOL isNote;
@property (assign, nonatomic) BOOL isArrow;

@end
