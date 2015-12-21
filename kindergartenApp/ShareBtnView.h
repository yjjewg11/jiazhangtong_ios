//
//  ShareBtnView.h
//  kindergartenApp
//
//  Created by Mac on 15/12/21.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareBtnViewDelegate <NSObject>

- (void)openWeb:(NSString *)url;

@end

@interface ShareBtnView : UIView

@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (strong, nonatomic) NSString * url;

@property (weak, nonatomic) id<ShareBtnViewDelegate> delegate;

@end
