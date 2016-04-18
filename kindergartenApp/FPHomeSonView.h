//
//  FPHomeSonView.h
//  kindergartenApp
//
//  Created by Mac on 16/1/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^upLoadBtn)();
typedef void(^collegeBtn)();
typedef void(^albumIfonBtn)();
typedef void(^addMyCollectionBtn)();

@interface FPHomeSonView : UIView

@property(nonatomic, strong) upLoadBtn pushUpLoad;
@property(nonatomic, strong) collegeBtn pushCollege;
@property(nonatomic, strong) albumIfonBtn pushAlbunInfo;
@property(nonatomic, strong) addMyCollectionBtn addMyCollectionBtn;

@end
