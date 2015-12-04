//
//  EnrolStudentMySchoolBtnCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentMySchoolBtnCell.h"

@interface EnrolStudentMySchoolBtnCell()

@property (weak, nonatomic) IBOutlet UIButton *btnJianJie;

@property (weak, nonatomic) IBOutlet UILabel *lblJianJie;

@property (weak, nonatomic) IBOutlet UIView *bottomView1;

@property (weak, nonatomic) IBOutlet UIView *bottomView2;

@property (weak, nonatomic) IBOutlet UIView *bottomView3;

@property (weak, nonatomic) IBOutlet UILabel *lblPingLun;

@property (weak, nonatomic) IBOutlet UIButton *btnPingLun;

@property (weak, nonatomic) IBOutlet UILabel *lblZhaoSheng;

@property (weak, nonatomic) IBOutlet UIButton *btnZhaoSheng;

@end

@implementation EnrolStudentMySchoolBtnCell

- (void)awakeFromNib
{
    
}

- (IBAction)btnClicked:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 0:
        {
            self.lblZhaoSheng.textColor = [UIColor redColor];
            self.bottomView1.backgroundColor = [UIColor redColor];
            
            self.lblJianJie.textColor = [UIColor darkGrayColor];
            self.bottomView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            self.lblPingLun.textColor = [UIColor darkGrayColor];
            self.bottomView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.delegate funcBtnClick:btn];
        }
            break;
        case 1:
        {
            self.lblZhaoSheng.textColor = [UIColor darkGrayColor];
            self.bottomView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            self.lblJianJie.textColor = [UIColor redColor];
            self.bottomView2.backgroundColor = [UIColor redColor];
            
            self.lblPingLun.textColor = [UIColor darkGrayColor];
            self.bottomView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self.delegate funcBtnClick:btn];
        }
            break;
            
        case 2:
        {
            self.lblZhaoSheng.textColor = [UIColor darkGrayColor];
            self.bottomView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            self.lblJianJie.textColor = [UIColor darkGrayColor];
            self.bottomView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            self.lblPingLun.textColor = [UIColor redColor];
            self.bottomView3.backgroundColor = [UIColor redColor];
            [self.delegate funcBtnClick:btn];
        }
            break;
            
        default:
            break;
    }
}

@end
