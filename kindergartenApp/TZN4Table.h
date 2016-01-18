//
//  TZN4Table.h
//  kindergartenApp
//
//  Created by Mac on 16/1/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZN4Table : UIView

@property (nonatomic, strong) UIScrollView*  scrollView;
@property (nonatomic, strong) UIView * scrollContentView;
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UITableView * tableView;

- (TZN4Table *)initWithTableViewWithHeaderImage:(UIImage *)headerImage withOTCoverHeight:(CGFloat)height;
- (TZN4Table *)initWithScrollViewWithHeaderImage:(UIImage *)headerImage withOTCoverHeight:(CGFloat)height withScrollContentViewHeight:(CGFloat)height;
- (void)setHeaderImage:(UIImage *)headerImage;

@end

@interface UIImage (Blur)

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;

@end