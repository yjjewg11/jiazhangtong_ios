//
//  EnrolStudentWebViewCell.h
//  kindergartenApp
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnrolStudentWebViewCellDelegate <NSObject>

- (void)pullDownTopView;

@end


@interface EnrolStudentWebViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)setData:(NSString *)url;


@property (weak, nonatomic) id<EnrolStudentWebViewCellDelegate> delegate;

@end
