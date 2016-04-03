//
//  FPTimeLineDetailVC.h
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//


#import "BaseReplyInputViewController.h"
#pragma 照片详细显示，可以左右滑动
@interface FPTimeLineDetailVC : BaseReplyInputViewController

@property (strong, nonatomic) NSString * daytimeStr;
@property (strong, nonatomic) NSString * familyUUID;
#pragma 照片详细列表 FPFamilyPhotoNormalDomain
@property (strong, nonatomic) NSMutableArray * fpPhotoNormalDomainArr;

#pragma 显示列表
@property  NSInteger  selectIndex;
- (void)setFpPhotoNormalDomainArrByDic:( NSMutableArray *) fpItemArrDic;

@end
