//
//  PickImgDayHeadView.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/25.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickImgDayHeadViewDelegate <NSObject>

-(void)clickAction_selImg:(NSString *)sectionName checked:(Boolean ) checked;

@end

@interface PickImgDayHeadView : UICollectionReusableView
- (void)setData:(NSString *)title checked:(BOOL)checked;

@property (weak, nonatomic) id<PickImgDayHeadViewDelegate> delegate;

@property (assign, nonatomic) NSInteger index;
@end
