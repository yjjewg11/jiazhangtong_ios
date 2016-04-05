//
//  FFMovieEditMainVC.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/4.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPMoive4QDomain.h"
#import "BaseViewController.h"
#import "JRSegmentControl.h"
#import "FFMoiveEditNoteSelectedVC.h"
#import "FFMovieShareData.h"
//编辑主文件
@interface FFMovieEditMainVC : BaseViewController
@property (strong, nonatomic) FPMoive4QDomain * domain;

@property (strong, nonatomic) NSMutableDictionary * selectDomainMap;

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, copy) NSArray *titles;

/** 指示视图的颜色 */
@property (nonatomic, strong) UIColor *indicatorViewColor;
/** segment的背景颜色 */
@property (nonatomic, strong) UIColor *segmentBgColor;
/**
 *  segment每一项的文字颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/** segment每一项的宽 */
@property (nonatomic, assign) CGFloat itemWidth;
/** segment每一项的高 */
@property (nonatomic, assign) CGFloat itemHeight;

@end
