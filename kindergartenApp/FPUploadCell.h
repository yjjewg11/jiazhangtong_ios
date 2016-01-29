//
//  FPUploadCell.h
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPFamilyPhotoUploadDomain.h"

@interface FPUploadCell : UITableViewCell

@property (assign, nonatomic) NSInteger index;

- (void)setData:(FPFamilyPhotoUploadDomain *)domain;

@end
