//
//  AddressbookTableViewCell.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/5.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReFreshBaseCell.h"
#import "AddressBookDomain.h"

@interface AddressbookTableViewCell : UITableViewCell {
    
    IBOutlet UIImageView * headImageView;
    IBOutlet UILabel * nameLabel;
    IBOutlet UIButton * telBtn;
    AddressBookDomain * domain;
    
    IBOutlet UIButton *chatBtn;
    
    
    IBOutlet NSLayoutConstraint *spaceWidth;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (IBAction)addressbookFunBtnClicked:(UIButton *)sender;
- (void)resetValue:(id)baseDomain parame:(NSMutableDictionary *)parameterDic;
@end
