//
//  ImageCollectionView.h
//  testcollectionview
//
//  Created by ios2 on 14-9-25.
//  Copyright (c) 2014年 yhr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemResource.h"

@protocol  ImageCollectionViewDelegate<NSObject>

//单击回调
-(void)singleTapEvent:(NSString *)pType;

@end

@interface ImageCollectionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>{
    UICollectionView * myCollectionView;
    UIPageControl * pageControl;

}
@property (strong, nonatomic)NSMutableArray * dataSource;
@property (strong, nonatomic)id<ImageCollectionViewDelegate> _delegate;

-(void)showImageCollectionView;

@end
