//
//  FuniPhotoScrollView.m
//  funiApp
//
//  Created by You on 13-7-24.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import "KGPhotoScrollView.h"
#import "KGHUD.h"
//#import "FuniNSStringUtil.h"
#import "UIImageView+WebCache.h"
#import "SystemResource.h"

@implementation KGPhotoScrollView

@synthesize photoScrollViewDelegate;
@synthesize photoImageView;
@synthesize attachment;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(KGPhotoScrollView *)initWithPath:(CGRect)frame attach:(KGAttachment *)attach size:(NSString *)size{
    self = [self initWithFrame:frame];
    if(self){
        attachment      = attach;
        downPhotoSize   = size;
        [self loadPhoto];
        [self addGesture];
    }
    return self;
}

-(KGPhotoScrollView *)initWithPath:(CGRect)frame attach:(KGAttachment *)attach size:(NSString *)size defImg:(NSString *)defImg{
    defImgName = defImg;
    return [self initWithPath:frame attach:attach size:size];
}

//加载单张图片
-(KGPhotoScrollView *)initWithSingleImage:(CGRect)frame image:(UIImage *)image defImg:(NSString *)defImg{
    self = [self initWithFrame:frame];
    if(self){
        isSingle    = YES;
        defImgName  = defImg;
        singleImage = [[UIImage alloc]init];
        singleImage = image;
        [self loadPhoto];
        [self addGesture];
    }
    return self;
}


//加载图片
- (void)loadPhoto{
    CGSize photosize = self.frame.size;

    photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(photosize.width/Number_Four, photosize.height/Number_Four, photosize.width/Number_Two, photosize.height/Number_Two)];
    photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    photoImageView.backgroundColor = [UIColor blackColor];
    [self addSubview:photoImageView];
    
    if(isSingle){
        UIImageView * imageview = photoImageView;
        photoImageView.image    = singleImage;
        imageview.frame         = CGRectMake(Number_Zero, Number_Zero, photosize.width, photosize.height);
    }
    else if(attachment && attachment.image){
        photoImageView.image = attachment.image;
        photoImageView.frame = CGRectMake(Number_Zero, Number_Zero, APPWINDOWWIDTH,APPWINDOWHEIGHT - 64);
    }
}

- (void)setScrollViewZoomScale{
    // Sizes
    UIImage * mapImage = photoImageView.image;
    CGSize mainViewSize = self.bounds.size;
    CGFloat imageView_X = (mapImage.size.width > mainViewSize.width ? mainViewSize.width : mapImage.size.width);
    CGFloat imageView_Y = (mapImage.size.height > mainViewSize.height ? mainViewSize.height : mapImage.size.height);
    if (mapImage.size.width > mainViewSize.width) {
             imageView_Y = mapImage.size.height * (mainViewSize.width / mapImage.size.width);
         }
    
    photoImageView.frame = CGRectMake((mainViewSize.width - imageView_X) / Number_Two, (mainViewSize.height - imageView_Y) / Number_Two, imageView_X, imageView_Y);
    [self setNeedsLayout];
}


#pragma mark - Override layoutSubviews to center content
#pragma mark - Setup

- (void)setMaxMinZoomScalesForCurrentBounds {
	
	// Reset
	self.maximumZoomScale = Number_One;
	self.minimumZoomScale = Number_One;
	self.zoomScale = Number_One;
	
	// Bail
	if (photoImageView.image == nil) return;
	
	// Sizes
    CGSize boundsSize = self.bounds.size;
    
    CGSize imageSize = photoImageView.image.size;
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
	
	// If image is smaller than the screen then ensure we show it at
	// min scale of 1
	if (xScale > Number_One && yScale > Number_One) {
		minScale = Number_One;
	}
    
	// Calculate Max
	CGFloat maxScale = Number_Two; // Allow double scale
    // maximum zoom scale to 0.5.
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	
	// Set
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
	
	// Reset position
    photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentSize = CGSizeMake(photoImageView.frame.size.width, photoImageView.frame.size.height);
    self.contentMode = UIViewContentModeScaleAspectFit;
	[self setNeedsLayout];
    
}

//添加手势
- (void) addGesture {
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    singleTapGesture.delegate = self;
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:doubleTapGesture];
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
}

//手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}


//单击响应
-(void)singleTap{
    if (photoScrollViewDelegate)
    {
        [photoScrollViewDelegate singleTapEvent:self];
    }
}

//双击响应
-(void)doubleTap{
	if (photoScrollViewDelegate)
    {
        [photoScrollViewDelegate doubleTapEvent:self];
    }
}

- (UIView *)viewForZoomingInScrollView:(KGPhotoScrollView *)scrollView
{
    return scrollView.photoImageView;
}

@end
