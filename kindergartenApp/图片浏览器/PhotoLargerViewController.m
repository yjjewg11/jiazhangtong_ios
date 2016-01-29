//
//  PhotoLargerViewController.m
//  OnlineRepairSystem
//
//  Created by 谢诚 on 15/11/20.
//  Copyright © 2015年 zs. All rights reserved.

#import "PhotoLargerViewController.h"
#import "UploadImage.h"

@implementation PhotoLargerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _currentPage = _selectedIndex;
}

#pragma mark 设置图片组和选中的图片下标
- (void)setUploadImages:(NSMutableArray *)uploadImages selectedIndex:(int)selectedIndex
{
    _selectedIndex = selectedIndex;
    _uploadImages = uploadImages;
    _offset = 0.0;
    _scale = 1.0;
    _width = [UIScreen mainScreen].bounds.size.width + (kLeftBorder);
    _height = [UIScreen mainScreen].bounds.size.height - kTopBorder;
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-kLeftBorder, kTopBorder, _width, _height)];
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    self.imageScrollView.scrollEnabled = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    self.imageScrollView.contentSize = CGSizeMake(_width * uploadImages.count, _height);
    [self.view addSubview:self.imageScrollView];
    
    for (int i = 0; i < uploadImages.count; i++)
    {
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UITapGestureRecognizer *sTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlesTap:)];
        [sTap setNumberOfTapsRequired:1];
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(_width * i, 0, _width, _height)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(_width, _height);
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.tag = i+1;
        [s setZoomScale:1.0];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        UploadImage *_upload = uploadImages[i];
        imageview.image = [_upload image];
        imageview.frame = CGRectMake(kLeftBorder, 0, _width - kLeftBorder, _height);
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.userInteractionEnabled = YES;
        imageview.tag = i+1;
        [imageview addGestureRecognizer:doubleTap];
        [imageview addGestureRecognizer:sTap];
        [s addSubview:imageview];
        [self.imageScrollView addSubview:s];
    }
    //设置显示区域
    [_imageScrollView setContentOffset:CGPointMake(_selectedIndex * _width, kTopBorder)];
}

#pragma mark - ScrollView缩放完成时间
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *v in scrollView.subviews)
    {
        return v;
    }
    return nil;
}

#pragma mark 当结束滚动时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.imageScrollView)
    {
        CGFloat x = scrollView.contentOffset.x;
        if (x != _offset)
        {
            _offset = x;
            //设置当前页面的下标
            self.currentPage = _offset / _width;
            for (UIScrollView *s in scrollView.subviews)
            {
                if ([s isKindOfClass:[UIScrollView class]])
                {
                    //还原视图比例
                    [s setZoomScale:1.0];
                }
            }
        }
    }
}

#pragma mark - 双击放大事件
- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView *)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    UIView *view = gesture.view.superview;
    if ([view isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *s = (UIScrollView *)view;
        [s zoomToRect:zoomRect animated:YES];
    }
}

- (void)handlesTap:(UIGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 放大方法
- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

@end
