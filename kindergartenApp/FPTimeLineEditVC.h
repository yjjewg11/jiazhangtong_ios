//
//  FPTimeLineEditVC.h
//  kindergartenApp
//
//  Created by Mac on 16/2/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import "FPFamilyPhotoNormalDomain.h"

@protocol UpdateFPFamilyPhotoNormalDomainDelegate <NSObject>

//更新
- (void)updateFPFamilyPhotoNormalDomain:(FPFamilyPhotoNormalDomain *)domain
;

@end

@interface FPTimeLineEditVC : BaseViewController

@property (strong, nonatomic) FPFamilyPhotoNormalDomain * domain;
@property (strong, nonatomic) id<UpdateFPFamilyPhotoNormalDomainDelegate>  delegate;

@end
