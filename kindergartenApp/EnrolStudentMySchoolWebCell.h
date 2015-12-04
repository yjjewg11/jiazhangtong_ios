//
//  EnrolStudentMySchoolWebCell.h
//  kindergartenApp
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnrolStudentMySchoolWebCellDelegate <NSObject>

- (void)pullDownTopView;

@end

@interface EnrolStudentMySchoolWebCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)setData:(NSString *)url;

@property (weak, nonatomic) id<EnrolStudentMySchoolWebCellDelegate> delegate;

@end
