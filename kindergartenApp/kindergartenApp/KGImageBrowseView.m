//
//  FuniImageBrowseView.m
//  funiApp
//
//  Created by You on 13-7-24.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import "KGImageBrowseView.h"
#import "KGHUD.h"
#import "UIImageView+WebCache.h"
//#import "FuniNSStringUtil.h"
#import "SystemResource.h"

#define PhotoBrowseSpace   30.0f
#define tableViewCellIden  @"Cell"
#define pageControlWidth  50
#define pageControlY      50
#define pageControlHeight 100

@implementation KGImageBrowseView

@synthesize _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initImageBrowse:(CGRect)frame attach:(NSMutableArray *)attachAry size:(NSString *)imageSize{
    self = [self initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        attachArray  = attachAry;
        downImgSize  = imageSize;
        [self initImageBrowseTableView];
    }
    return self;
}
- (id)initImageBrowse:(CGRect)frame attach:(NSMutableArray *)attachAry size:(NSString *)imageSize isPageing:(bool)isPageing{
    isPagngEnabled = isPageing;
    return [self initImageBrowse:frame attach:attachAry size:imageSize];
}

- (id)initImageBrowse:(CGRect)frame attach:(NSMutableArray *)attachAry size:(NSString *)imageSize isPageing:(bool)isPageing defImg:(NSString *)defImg{
    defImgName = defImg;
    return [self initImageBrowse:frame attach:attachAry size:imageSize isPageing:isPageing];
}

- (id)initWithSingleImage:(CGRect)frame image:(UIImage *)image defImg:(NSString *)defImg{
    self = [self initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        isSingle       = YES;
        defImgName     = defImg;
        isPagngEnabled = YES;
        singleImage    = [[UIImage alloc]init];
        singleImage    = image;
        [self initImageBrowseTableView];
    }
    self.backgroundColor = [UIColor redColor];
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isPagngEnabled = YES;
        [self initImageBrowseTableView];
    }
    return self;
}

- (void)initImageBrowseTableView{
    //Table
    photoTableView = [[UITableView alloc] initWithFrame:CGRectMake(Number_Zero, self.frame.size.height, self.frame.size.height, self.frame.size.width) style:UITableViewStylePlain];
    photoTableView.delegate = self;
    photoTableView.dataSource = self;
    if(isPagngEnabled)
        photoTableView.pagingEnabled = YES;
    photoTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    photoTableView.center = CGPointMake(self.frame.size.width/ Number_Two, self.frame.size.height / Number_Two);
    photoTableView.backgroundColor = [UIColor blackColor];
    photoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    photoTableView.separatorColor = [UIColor clearColor];
    
    [photoTableView.layer setAnchorPoint:CGPointMake(Number_Zero, Number_Zero)];
    photoTableView.transform = CGAffineTransformMakeRotation(M_PI/-Number_Two);
    photoTableView.showsVerticalScrollIndicator = NO;
    photoTableView.frame = CGRectMake(Number_Zero, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self addSubview:photoTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return Number_One;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return isPagngEnabled ? self.frame.size.width : self.frame.size.width+PhotoBrowseSpace;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isSingle){
        return Number_One;
    }
    totalPage = (attachArray && [attachArray count]>Number_Zero) ? [attachArray count] : Number_Zero;
    return totalPage;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = tableViewCellIden;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for(UIView * view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    if(isSingle){
        KGPhotoScrollView * photoScrollView = [[KGPhotoScrollView alloc] initWithSingleImage:CGRectMake(Number_Zero, Number_Zero, self.frame.size.width, self.frame.size.height) image:singleImage defImg:defImgName];
        photoScrollView.photoScrollViewDelegate = self;
        photoScrollView.delegate = self;
        //顺时针旋转90度
        photoScrollView.transform = CGAffineTransformMakeRotation(M_PI / Number_Two);
        photoScrollView.frame = CGRectMake(Number_Zero, Number_Zero, photoScrollView.frame.size.width, photoScrollView.frame.size.height);
        photoScrollView.backgroundColor = [UIColor blackColor];
        photoScrollView.multipleTouchEnabled = YES;
        photoScrollView.minimumZoomScale = Number_One;
        photoScrollView.maximumZoomScale = Number_Eight;
        [cell.contentView addSubview:photoScrollView];
    }
    else if(attachArray && [attachArray count]>Number_Zero){
        KGPhotoScrollView * photoScrollView = [[KGPhotoScrollView alloc] initWithPath:CGRectMake(Number_Zero, Number_Zero, self.frame.size.width, self.frame.size.height)
                 attach:[attachArray objectAtIndex:indexPath.row]
                 size:downImgSize defImg:defImgName];
        photoScrollView.photoScrollViewDelegate = self;
        photoScrollView.delegate = self;
        //顺时针旋转90度
        photoScrollView.transform = CGAffineTransformMakeRotation(M_PI / Number_Two);
        photoScrollView.frame = CGRectMake(Number_Zero, Number_Zero, photoScrollView.frame.size.width, photoScrollView.frame.size.height);
        photoScrollView.backgroundColor = [UIColor blackColor];
        photoScrollView.multipleTouchEnabled = YES;
        photoScrollView.minimumZoomScale = Number_One;
        photoScrollView.maximumZoomScale = Number_Eight;
        [cell.contentView addSubview:photoScrollView];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
}

//获得当前浏览的图片位置
- (NSInteger)getCurrentIndex{
    return currentIndex;
}

//view有滚动（不管是拖、拉、放大、缩小等导致）都会执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	// Calculate current page
	CGRect visibleBounds = photoTableView.bounds;
	int index = (int)(floorf(CGRectGetMidY(visibleBounds) / CGRectGetHeight(visibleBounds)));
    if (index > totalPage - Number_One) index = (int)totalPage - Number_One;
    if (index < Number_Zero) index = Number_Zero;
	NSUInteger previousCurrentPage = currentIndex;
	currentIndex = index;
	if (currentIndex != previousCurrentPage && !isSingle) {
        [_delegate browseIndex:currentIndex attach:[attachArray objectAtIndex:currentIndex]];
    }
}

//已经结束拖拽，手指刚离开view的那一刻
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

}

//单击回调
-(void)singleTapEvent:(KGPhotoScrollView *)photoScrollView{
    if(_delegate)
        [_delegate singleTapEvent:photoScrollView.attachment];
}

// 双击回调
-(void)doubleTapEvent:(KGPhotoScrollView *)photoScrollView{
    if (photoScrollView.zoomScale == photoScrollView.maximumZoomScale) {
        // Zoom out
        [photoScrollView setZoomScale:photoScrollView.minimumZoomScale animated:YES];
    }
    else{
        // Zoom in
        [photoScrollView setZoomScale:photoScrollView.zoomScale + 2 animated:YES];
    }
}

//实现图片在缩放过程中居中
- (void)scrollViewDidZoom:(KGPhotoScrollView *)scrollView{
     CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/Number_Two : Number_Zero;
     CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/Number_Two : Number_Zero;
     scrollView.photoImageView.center = CGPointMake(scrollView.contentSize.width/Number_Two + offsetX,scrollView.contentSize.height/Number_Two + offsetY);
}


- (UIView *)viewForZoomingInScrollView:(KGPhotoScrollView *)scrollView {
    return scrollView.photoImageView;
}


//设置当前展示的图片
- (void)resetTableViewCellIndex:(NSInteger)index{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:Number_Zero];
    [photoTableView scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

@end
