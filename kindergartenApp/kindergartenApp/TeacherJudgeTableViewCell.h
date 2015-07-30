//
//  TeacherJudgeTableViewCell.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReFreshBaseCell.h"
#import "TeacherVO.h"

@interface TeacherJudgeTableViewCell : ReFreshBaseCell {
    NSInteger lastSelTag;
}

@property (strong, nonatomic) TeacherVO * teachVO;

@property (strong, nonatomic) IBOutlet UIImageView * headImageView;
@property (strong, nonatomic) IBOutlet UILabel * nameLabel;
@property (strong, nonatomic) IBOutlet UITextView * judgeTextView;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;


- (IBAction)judgeBtnClicked:(UIButton *)sender;

- (IBAction)submitBtnClicked:(UIButton *)sender;

@end
