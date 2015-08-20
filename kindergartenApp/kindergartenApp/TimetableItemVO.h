//
//  TimetableItemVO.h
//  kindergartenApp
//
//  Created by You on 15/8/11.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimetableItemVO : NSObject

@property (strong, nonatomic) NSString * classuuid; //
@property (strong, nonatomic) NSString * headUrl; //
@property (strong, nonatomic) NSMutableArray * timetableMArray;
@property (assign, nonatomic) CGFloat  cellHeight;
@property (assign, nonatomic) BOOL     isDZReply;
@property (strong, nonatomic) UIView * dzReplyView;
@property (assign, nonatomic) NSInteger   weekday;

@end
