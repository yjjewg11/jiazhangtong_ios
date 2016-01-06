//
//  SpCourseDetailInfoWeb.h
//  kindergartenApp
//
//  Created by Mac on 16/1/6.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpCourseDetailInfoWebDelegate <NSObject>

- (void)pullDownTopView;

@end

@interface SpCourseDetailInfoWeb : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *webview;

- (void)setData:(NSString *)url;

@property (weak, nonatomic) id<SpCourseDetailInfoWebDelegate> delegate;

@end
