//
//  FuniImageBrowseView.h
//  funiApp
//
//  Created by You on 13-7-24.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGPhotoScrollView.h"
#import "KGAttachment.h"

@protocol FuniImageBrowseViewDelegate <NSObject>

//单击回调
-(void)singleTapEvent:(KGAttachment *)attachment;

//当前浏览的图片index
@optional
- (void)browseIndex:(NSInteger)index attach:(KGAttachment *)attach;

@end

@interface KGImageBrowseView : UIView<FuniPhotoScrollViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    id<FuniImageBrowseViewDelegate> _delegate;
    UITableView      * photoTableView; //图片表格
    NSMutableArray   * attachArray;    //图片集合
    NSString         * downImgSize;    //下载的图片大小
    bool               isPagngEnabled; //是否分页模式浏览
    NSInteger          currentIndex;   //当前页码
    NSInteger          totalPage;      //总页数
    NSString         * defImgName;     //默认图片名
    BOOL               isSingle;       //是否展示单张图片
    UIImage          * singleImage;    //单张图片
}

@property(retain, nonatomic)id<FuniImageBrowseViewDelegate> _delegate;
@property (strong, nonatomic) KGPhotoScrollView * photoScrollView;

//获取当前图片
- (UIImage *)getCurrentImage;

- (id)initImageBrowse:(CGRect)frame attach:(NSMutableArray *)attachAry size:(NSString *)imageSize;

- (id)initImageBrowse:(CGRect)frame attach:(NSMutableArray *)attachAry size:(NSString *)imageSize isPageing:(bool)isPageing;

- (id)initImageBrowse:(CGRect)frame attach:(NSMutableArray *)attachAry size:(NSString *)imageSize isPageing:(bool)isPageing  defImg:(NSString *)defImg;

- (id)initWithSingleImage:(CGRect)frame image:(UIImage *)image defImg:(NSString *)defImg;

- (NSInteger)getCurrentIndex;

//设置当前展示的图片
- (void)resetTableViewCellIndex:(NSInteger)index;
@end
