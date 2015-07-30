//
//  StudentOtherInfoViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/24.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentOtherInfoViewController.h"
#import "KGTextField.h"
#import "StudentInfoItemVO.h"
#import "KGNSStringUtil.h"
#import "KGHttpService.h"
#import "KGHUD.h"

@interface StudentOtherInfoViewController () {
    
    IBOutlet KGTextField * nameTextField;
    IBOutlet KGTextField * workTextField;
    IBOutlet KGTextField * telTextField;
    IBOutlet UIView * workView;
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
    [nameTextField setTextFielType:KGTextFielType_Empty];
    [nameTextField setMessageStr:@"姓名不能为空"];
    [textFieldMArray addObject:nameTextField];
    
    [telTextField setTextFielType:KGTextFielType_Empty];
    [telTextField setMessageStr:@"电话不能为空"];
    [textFieldMArray addObject:telTextField];
}


- (void)initViewData {
    StudentInfoItemVO * itemVO = [_dataSource objectAtIndex:_index];
    if(_index > Number_Two) {
        // 非爸爸 妈妈信息
        nameTextField.text = itemVO.head;
        workView.hidden = YES;
    }
    
    for(NSInteger i=Number_Zero; i < [itemVO.contentMArray count]; i++) {
        KGTextField * textField = (KGTextField *)[self.view viewWithTag:i+Number_Ten];
        NSString * str = [itemVO.contentMArray objectAtIndex:i];
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
    switch (_index) {
        case Number_One:
            _studentInfo.ba_name = [KGNSStringUtil trimString:nameTextField.text];
            _studentInfo.ba_tel  = [KGNSStringUtil trimString:telTextField.text];
            _studentInfo.ba_work = [KGNSStringUtil trimString:workTextField.text];
            break;
        case Number_Two:
            _studentInfo.ma_name = [KGNSStringUtil trimString:nameTextField.text];
            _studentInfo.ma_tel  = [KGNSStringUtil trimString:telTextField.text];
            _studentInfo.ma_work = [KGNSStringUtil trimString:workTextField.text];
            break;
        case Number_Three:
            _studentInfo.ye_tel  = [KGNSStringUtil trimString:telTextField.text];
            break;
        case Number_Four:
            _studentInfo.nai_tel  = [KGNSStringUtil trimString:telTextField.text];
            break;
        case Number_Five:
            _studentInfo.waigong_tel  = [KGNSStringUtil trimString:telTextField.text];
            break;
        case Number_Six:
            _studentInfo.waipo_tel  = [KGNSStringUtil trimString:telTextField.text];
            break;
    }
}



@end
