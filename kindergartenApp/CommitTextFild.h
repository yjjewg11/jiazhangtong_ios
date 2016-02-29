//
//  CommitTextFild.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/2/25.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteCommite)();

@interface CommitTextFild : UIView
- (IBAction)completeBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *TF;

@property (strong, nonatomic)CompleteCommite completeCommite;

@end
