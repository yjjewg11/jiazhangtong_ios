//
//  StudentOtherInfoViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentOtherInfoViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "KGNSStringUtil.h"
#import "KGTextField.h"
#import "KGNSStringUtil.h"
#import "KGFormVerify.h"

#define phoneValMsg  @"手机号格式不正确"

@interface StudentOtherInfoViewController () {
    
    IBOutlet KGTextField * yeyeTextField;
    IBOutlet KGTextField * naiTextField;
    IBOutlet KGTextField * waigongTextField;
    IBOutlet KGTextField * waipoTextField;
}

@end

@implementation StudentOtherInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细信息";
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveStudentBaseInfo)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self initViewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  添加输入框到array统一管理验证
 */
- (void)addTextFieldToMArray
{
//    [yeyeTextField setTextFielType:KGTextFielType_Phone];
//    [yeyeTextField setMessageStr:phoneValMsg];
//    [textFieldMArray addObject:yeyeTextField];
//    
//    [naiTextField setTextFielType:KGTextFielType_Phone];
//    [naiTextField setMessageStr:phoneValMsg];
//    [textFieldMArray addObject:naiTextField];
//    
//    [waigongTextField setTextFielType:KGTextFielType_Phone];
//    [waigongTextField setMessageStr:phoneValMsg];
//    [textFieldMArray addObject:waigongTextField];
//    
//    [waipoTextField setTextFielType:KGTextFielType_Phone];
//    [waipoTextField setMessageStr:phoneValMsg];
//    [textFieldMArray addObject:waipoTextField];
}

- (void)initViewData {
    for(NSInteger i=Number_Zero; i < [_itemVO.contentMArray count]; i++) {
        KGTextField * textField = (KGTextField *)[self.view viewWithTag:i+Number_Ten];
        NSString * str = [_itemVO.contentMArray objectAtIndex:i];
        NSArray * strArray = [str componentsSeparatedByString:@":"];
        textField.text = [strArray objectAtIndex:Number_One];
    }
}

//保存按钮点击
- (void)saveStudentBaseInfo {
    if([self validateInputInView]) {
        
        [self packageData];
        
        //提交数据
        [[KGHttpService sharedService] saveStudentInfo:_studentInfo success:^(NSString *msgStr) {
            
            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
            
            if(_StudentUpdateBlock) {
                _StudentUpdateBlock(_studentInfo);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
}

//封装数据
- (void)packageData {
    _studentInfo.ye_tel  = [KGNSStringUtil trimString:yeyeTextField.text];
    _studentInfo.nai_tel  = [KGNSStringUtil trimString:naiTextField.text];
    _studentInfo.waigong_tel  = [KGNSStringUtil trimString:waigongTextField.text];
    _studentInfo.waipo_tel  = [KGNSStringUtil trimString:waipoTextField.text];
}

- (BOOL)validateInputInView {
    BOOL judgeInput = YES;
    BOOL isAllEmpty = YES;
    NSMutableArray * tempTextFieldMArray = [[NSMutableArray alloc] init];
    for(NSInteger i=Number_Zero; i<Number_Four; i++) {
        KGTextField * textField = (KGTextField *)[self.view viewWithTag:i+Number_Ten];
        if([KGNSStringUtil trimString:textField.text].length > Number_Zero) {
            [tempTextFieldMArray addObject:textField];
            isAllEmpty = NO;
        }
    }
    
    if(isAllEmpty) {
        //都为空
        [self showMessage];
        judgeInput = NO;
    } else {
        BOOL judge = YES;
        for(KGTextField * textField in tempTextFieldMArray) {
            judge = [KGFormVerify validateMobile:textField.text];
            if(!judge) {
                [textField becomeFirstResponder];
                break;
            }
        }
        
        if(!judge) {
            NSDictionary * dic = [NSDictionary dictionaryWithObject:phoneValMsg forKey:Key_Notification_MessageText];
            [[NSNotificationCenter defaultCenter]postNotificationName:Key_Notification_Message object:self userInfo:dic];
        }
        
        judgeInput = judge;
    }
    
    return judgeInput;
}

//提示都为空
- (void)showMessage {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请至少输入一个手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


@end
