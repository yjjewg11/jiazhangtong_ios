//
//  StudentNoteInfoViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/24.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentNoteInfoViewController.h"
#import "UIView+Extension.h"
#import "KGNSStringUtil.h"
#import "KGHttpService.h"
#import "KGHUD.h"

@interface StudentNoteInfoViewController () {
    
    IBOutlet UITextView * noteTextView;
}

@end

@implementation StudentNoteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细信息";
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveStudentBaseInfo)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [noteTextView setBorderWithWidth:Number_One color:[UIColor grayColor] radian:5.0];
    noteTextView.text = _studentInfo.note;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//保存按钮点击
- (void)saveStudentBaseInfo {
    if([self validateInputInView]) {
        
        _studentInfo.note = [KGNSStringUtil trimString:noteTextView.text];
        
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


@end
