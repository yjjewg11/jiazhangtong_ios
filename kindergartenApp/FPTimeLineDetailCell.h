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
#import "FPUploadVC.h"
@interface FPTimeLineDetailCell : UICollectionViewCell

- (void)setData:(FPFamilyPhotoNormalDomain *)domain indexOfDomain:(NSInteger)indexOfDomain dataArray :(NSArray*) dataArray;
- (void)setDataByMap:(id) map  indexOfDomain:(NSInteger)indexOfDomain dataArray: (NSArray*) dataArray;

@end
