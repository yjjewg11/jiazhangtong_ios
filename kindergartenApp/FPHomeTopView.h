//
//  FPHomeTopView.h
//  kindergartenApp
//
//  Created by Mac on 16/1/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPMyFamilyPhotoCollectionDomain.h"

typedef void(^OnTap)();

@protocol FPHomeTopViewDelegate <NSObject>
- (void)clickGiftwareBtn;


@end

@interface FPHomeTopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *warningLbl;
@property id<FPHomeTopViewDelegate> delegate;

- (void)setData:(FPMyFamilyPhotoCollectionDomain *)domain;


@property (strong, nonatomic) OnTap pushToMyAlbum;

@end
