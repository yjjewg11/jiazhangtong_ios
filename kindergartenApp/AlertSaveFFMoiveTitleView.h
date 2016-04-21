//
//  AlertSaveFFMoiveTitleView.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/21.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^okBtn)();

@interface AlertSaveFFMoiveTitleView : UIView
@property (weak, nonatomic) IBOutlet UITextField *title_tf;
- (IBAction)touchinside_check1:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck1;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck2;
- (IBAction)touchInside_cancel:(id)sender;
- (IBAction)touchInside_Ok:(id)sender;

-(void)setTitleAndStatus:(NSString *)title status:(NSString *) status;

@property(nonatomic, strong) okBtn okBtn;
@property(nonatomic, strong) NSString * title;
@property(nonatomic, assign) NSString * status;
@end
