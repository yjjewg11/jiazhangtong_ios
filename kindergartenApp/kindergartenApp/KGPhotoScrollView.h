//
//  FuniPhotoScrollView.h
//  funiApp
//
//  Created by You on 13-7-24.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGAttachment.h"

@protocol FuniPhotoScrollViewDelegate;

@interface KGPhotoScrollView : UIScrollView<UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    id<FuniPhotoScrollViewDelegate>  photoScrollViewDelegate;
    UIImageView    * photoImageView;
    NSString       * photoPath;
    NSString       * downPhotoSize;
    KGAttachment * attachment;
    NSString       * defImgName;
    BOOL             isSingle;      //是否显示单张图片
    UIImage        * singleImage;   //单张图片
}

@property(retain, nonatomic) id<FuniPhotoScrollViewDelegate>  photoScrollViewDelegate;
@property(retain, nonatomic) UIImageView    * photoImageView;
@property(retain, nonatomic) KGAttachment * attachment;

-(KGPhotoScrollView *)initWithPath:(CGRect)frame attach:(KGAttachment *)attach size:(NSString *)size;
-(KGPhotoScrollView *)initWithPath:(CGRect)frame attach:(KGAttachment *)attach size:(NSString *)size defImg:(NSString *)defImg;
-(KGPhotoScrollView *)initWithSingleImage:(CGRect)frame image:(UIImage *)image defImg:(NSString *)defImg;
@end


@protocol FuniPhotoScrollViewDelegate <NSObject>

//图片单击
-(void)singleTapEvent:(KGPhotoScrollView *)photoScrollView;

//图片双击
-(void)doubleTapEvent:(KGPhotoScrollView *)photoScrollView;

@end
