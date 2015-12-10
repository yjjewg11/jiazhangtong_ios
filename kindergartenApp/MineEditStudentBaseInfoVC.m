//
//  MineEditStudentBaseInfoVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/10.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MineEditStudentBaseInfoVC.h"

@interface MineEditStudentBaseInfoVC ()
{
    BOOL _isCreateStudent;
}

@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UITextField *nickNameText;

@property (weak, nonatomic) IBOutlet UITextField *sexText;

@property (weak, nonatomic) IBOutlet UITextField *birthdayText;

@property (weak, nonatomic) IBOutlet UITextField *idNumText;

@property (weak, nonatomic) IBOutlet UITextField *roleText;


@end

@implementation MineEditStudentBaseInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化数据
    [self initDatas];
    
}

- (void)initDatas
{
    if (self.student == nil)
    {
        _isCreateStudent = YES;
    }
    else
    {
        _isCreateStudent = NO;
        
        self.nameText.text = self.student.name;
        
        self.nickNameText.text = self.student.nickname;
        
        self.sexText.text = self.student.sex == YES ? @"女" : @"男";
        
        self.birthdayText.text = self.student.birthday;
        
        self.idNumText.text = self.student.idcard;
        
//        self.roleText.text = 
    }
}

- (IBAction)btnClicked:(UIButton *)sender
{
    
}

@end
