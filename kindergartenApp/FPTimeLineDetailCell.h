//
//  FPTimeLineDetailCell.h
//  kindergartenApp
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPFamilyPhotoNormalDomain.h"
#import "FPTimeLineDetailCommentDomain.h"

@interface FPTimeLineDetailCell : UICollectionViewCell

- (void)setData:(FPFamilyPhotoNormalDomain *)domain hideInfo:(BOOL)hideInfoView;

@end
