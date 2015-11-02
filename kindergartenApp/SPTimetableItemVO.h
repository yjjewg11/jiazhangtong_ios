//
//  SPTimetableItemVO.h
//  kindergartenApp
//
//  Created by Mac on 15/10/20.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface SPTimetableItemVO : KGBaseDomain

@property (strong, nonatomic) NSMutableArray * spTimetableMArray;
@property (assign, nonatomic) CGFloat  cellHeight;
@property (assign, nonatomic) BOOL     isDZReply;
@property (strong, nonatomic) UIView * dzReplyView;
@property (strong, nonatomic) NSString * headUrl;

@end
