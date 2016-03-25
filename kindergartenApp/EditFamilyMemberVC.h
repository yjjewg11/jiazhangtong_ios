//
//  EditFamilyMemberVC.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/24.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "BaseViewController.h"

#import "FPFamilyMembers.h"
@protocol EditFamilyMemberVCDelegate <NSObject>

- (void)updateFPFamilyMembers:(FPFamilyMembers *)fPFamilyMembers;


@end
@interface EditFamilyMemberVC : BaseViewController<ABPeoplePickerNavigationControllerDelegate, UINavigationControllerDelegate>
@property  FPFamilyMembers* fPFamilyMembers;
@property (weak, nonatomic) id<EditFamilyMemberVCDelegate> editFamilyMemberVCDelegate;

@end
