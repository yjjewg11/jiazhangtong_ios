//
//  EditFamilyMemberVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/24.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "EditFamilyMemberVC.h"

#import "KGHttpService.h"
#import "MBProgressHUD+HM.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "HZQDatePickerView.h"
#import "KGHUD.h"
@interface EditFamilyMemberVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField_tel;
@property (weak, nonatomic) IBOutlet UITextField *textField_name;


@end

@implementation EditFamilyMemberVC


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
}
- (IBAction)action_addFromAddressBook:(id)sender {
    ABPeoplePickerNavigationController *pNC = [[ABPeoplePickerNavigationController alloc] init];
    pNC.peoplePickerDelegate = self;
    
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        pNC.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    
    [self presentViewController:pNC animated:YES completion:nil];
    
    
}
#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
        phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //没有点击电话，则根据电话列表，遍历获取最合适的。
   
    
    

    NSLog(@"%@phoneNO=", phoneNO);
    
    
    
    //读取firstname
    //获取个人名字（可以通过以下两个方法获取名字，第一种是姓、名；第二种是通过全名）。
    //第一中方法
    //    CFTypeRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //    CFTypeRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    //    //姓
    //    NSString * nameString = (__bridge NSString *)firstName;
    //    //名
    //    NSString * lastString = (__bridge NSString *)lastName;
    //第二种方法：全名
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    NSString *fullname= [NSString stringWithFormat:@"%@",anFullName];
    
    NSLog(@"fullname=%@", fullname);
    
    

    
    [self dismissViewControllerAnimated:YES completion:^{
        _textField_tel.text=phoneNO;
        _textField_name.text=fullname;
        
    }];
}


- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    
    
    
      [self.navigationController pushViewController:personViewController animated:YES];
//    [peoplePicker pushViewController:personViewController animated:YES];
    
    
}



- (void)actionhandleSave{
    
    //修改模型数据
//    
//   if([self.textField_tel.text isEqualToString:@""]){
//        [MBProgressHUD showError:@"电话不能为空"];
//        return ;
//    }
    if([self.textField_name.text isEqualToString:@""]){
          [MBProgressHUD showError:@"家庭称呼不能空"];
        return ;
    }
    if( !self.fPFamilyMembers){
        [self setFPFamilyMembers:[[FPFamilyMembers alloc]init]];
    }
    
    
    self.fPFamilyMembers.tel= self.textField_tel.text;
    self.fPFamilyMembers.family_name=self.textField_name.text;
    [self showLoadView];
    
    [[KGHttpService sharedService] fPFamilyMembers_save:self.fPFamilyMembers success:^(NSString *msgStr) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self hidenLoadView];
                           [MBProgressHUD showSuccess:@"保存成功!" toView:self.view];
                           [self.editFamilyMemberVCDelegate updateFPFamilyMembers:self.fPFamilyMembers];
                           
                           [self.navigationController popViewControllerAnimated:YES];
                           
                       });
        
    } faild:^(NSString *errorMsg) {
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           
                           [self hidenLoadView];
                           [MBProgressHUD showError:errorMsg toView:self.view];
                       });
        
    }
     
     
     ];
    

}


- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person NS_DEPRECATED_IOS(2_0, 8_0)
{
    return YES;
}



- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_DEPRECATED_IOS(2_0, 8_0)
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    NSString *fullname= [NSString stringWithFormat:@"%@",anFullName];
    
    if (phone && phoneNO.length == 11) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            _textField_tel.text=phoneNO;
            _textField_name.text=fullname;
            
        }];

        return NO;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请选择正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"编辑家庭成员"];
  
    if(self.fPFamilyMembers!=nil){
        self.textField_tel.text=self.fPFamilyMembers.tel;
         self.textField_name.text=self.fPFamilyMembers.family_name;
    }
   

    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(actionhandleSave)];
    [rightItem setTintColor:[UIColor whiteColor]];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    
    
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
        
        // we're on iOS 6
        NSLog(@"on iOS 6 or later, trying to grant access permission");
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        
        NSLog(@"on iOS 5 or older, it is OK");
        accessGranted = YES;
    }
    
    if (accessGranted) {
        
        NSLog(@"we got the access right");
    }else{
        [MBProgressHUD showSuccess:@"请到设置>隐私>通讯录打开本应用的权限设置"];
   
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
