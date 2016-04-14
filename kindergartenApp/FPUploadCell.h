//
//  FPUploadCell.h
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPFamilyPhotoUploadDomain.h"
#import "UploadPhotoToRemoteService.h"

@interface FPUploadCell : UITableViewCell

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) float percent;

- (void)setData:(FPFamilyPhotoUploadDomain *)domain;

@end
