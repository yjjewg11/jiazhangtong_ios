//
//  PhotoLargerViewController.h
//  OnlineRepairSystem
//
//  Created by 谢诚 on 15/11/20.
//  Copyright © 2015年 zs. All rights reserved.
//  图片浏览控制器(父类)

//kTopBorder取值是距离滚动视图距离原点的y值，举个例子如果视图中包含一个导航条和状态栏，则该值是20+33=53
#define kTopBorder 0
#define kLeftBorder 20
#import <UIKit/UIKit.h>
@class PhotoLargerViewController;

@interface PhotoLargerViewController : UIViewController<UIScrollViewDelegate>

//图片类数组
@property (nonatomic,strong) NSMutableArray *uploadImages;
//被选中的下标
@property (nonatomic,assign) int selectedIndex;
@property (nonatomic,retain) UIScrollView *imageScrollView;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,readonly) int width;
@property (nonatomic,readonly) int height;
@property (nonatomic,assign) float scale;
@property (nonatomic,assign) CGFloat offset;

- (void)setUploadImages:(NSMutableArray *)uploadImages selectedIndex:(int)selectedIndex;

- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center;

@end
