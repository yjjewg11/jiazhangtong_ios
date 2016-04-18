//
//  SPLoginController.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPLoginController.h"

#import "SPKitExample.h"
#import "SPUtil.h"

#import "SPTabBarViewController.h"
#import <YWExtensionForCustomerServiceFMWK/YWExtensionForCustomerServiceFMWK.h>



@interface SPLoginController ()
<UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UIView *viewOperator;
@property (weak, nonatomic) IBOutlet UIView *viewInput;

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserID;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *buttonFeedback;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

/**
 *  获取随机游客账号
 */
- (void)_getVisitorUserID:(NSString **)aGetUserID password:(NSString **)aGetPassword;


@end


/// for iPad
@interface SPLoginController ()
<UISplitViewControllerDelegate>

@property (nonatomic, weak) UINavigationController *weakDetailNavigationController;

@end

@implementation SPLoginController

#pragma mark - public

+ (void)getLastUserID:(NSString *__autoreleasing *)aUserID lastPassword:(NSString *__autoreleasing *)aPassword
{
    if (aUserID) {
        *aUserID = [self lastUserID];
    }
    
    if (aPassword) {
        *aPassword = [self lastPassword];
    }
}

#pragma mark - private

- (void)_getVisitorUserID:(NSString *__autoreleasing *)aGetUserID password:(NSString *__autoreleasing *)aGetPassword
{
    if (aGetUserID) {
        *aGetUserID = [NSString stringWithFormat:@"visitor%d", arc4random()%1000+1];
    }
    
    if (aGetPassword) {
        *aGetPassword = [NSString stringWithFormat:@"taobao1234"];
    }
}

- (void)_presentSplitControllerAnimated:(BOOL)aAnimated
{
    if ([self.view.window.rootViewController isKindOfClass:[UISplitViewController class]]) {
        /// 已经进入主页面
        return;
    }

    UISplitViewController *splitController = [[UISplitViewController alloc] init];
    
    if ([splitController respondsToSelector:@selector(setPreferredDisplayMode:)]) {
        [splitController setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
    }
    
    /// 各个页面
    
    UINavigationController *masterController = nil, *detailController = nil;
    
    {
        /// 消息列表页面
        
        UIViewController *viewController = [[UIViewController alloc] init];
        [viewController.view setBackgroundColor:[UIColor whiteColor]];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        detailController = nvc;
    }
    
    
    
    
    {
        /// 会话列表页面
        __weak typeof(self) weakSelf = self;
        self.weakDetailNavigationController = detailController;
        
        YWConversationListViewController *conversationListController = [[SPKitExample sharedInstance] exampleMakeConversationListControllerWithSelectItemBlock:^(YWConversation *aConversation) {
            
            if ([weakSelf.weakDetailNavigationController.viewControllers.lastObject isKindOfClass:[YWConversationViewController class]]) {
                YWConversationViewController *oldConvController = weakSelf.weakDetailNavigationController.viewControllers.lastObject;
                if ([oldConvController.conversation.conversationId isEqualToString:aConversation.conversationId]) {
                    return;
                }
            }

            
            YWConversationViewController *convController = [[SPKitExample sharedInstance] exampleMakeConversationViewControllerWithConversation:aConversation];
            if (convController) {
                [weakSelf.weakDetailNavigationController popToRootViewControllerAnimated:NO];
                [weakSelf.weakDetailNavigationController pushViewController:convController animated:NO];
                
                /// 关闭按钮
                UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(actionCloseiPad:)];
                [convController.navigationItem setLeftBarButtonItem:closeItem];
            }
        }];
        
        masterController = [[UINavigationController alloc] initWithRootViewController:conversationListController];
        
        /// 注销按钮
        UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(actionLogoutiPad:)];
        [conversationListController.navigationItem setLeftBarButtonItem:logoutItem];
    }

    [splitController setViewControllers:@[masterController, detailController]];
    
    splitController.view.frame = self.view.window.bounds;
    [UIView transitionWithView:self.view.window
                      duration:0.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.view.window.rootViewController = splitController;
                    }
                    completion:nil];
}

- (void)_addNotifications
{
    /// 监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)_pushMainControllerAnimated:(BOOL)aAnimated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self _presentSplitControllerAnimated:aAnimated];
    } else {
        if ([self.view.window.rootViewController isKindOfClass:[SPTabBarViewController class]]) {
            /// 已经进入主页面
            return;
        }

        SPTabBarViewController *tabController = [[SPTabBarViewController alloc] init];
        tabController.view.frame = self.view.window.bounds;
        [UIView transitionWithView:self.view.window
                          duration:0.25
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.view.window.rootViewController = tabController;
                        }
                        completion:nil];
    }
}

- (void)_tryLogin
{
    __weak typeof(self) weakSelf = self;
    
    [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:self.description];
    
    //这里先进行应用的登录
    
    //应用登陆成功后，登录IMSDK
    [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:self.textFieldUserID.text
                                                                           passWord:self.textFieldPassword.text
                                                                    preloginedBlock:^{
                                                                        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
                                                                        [weakSelf _pushMainControllerAnimated:YES];
                                                                    } successBlock:^{
                                                                        
                                                                        //  到这里已经完成SDK接入并登录成功，你可以通过exampleMakeConversationListControllerWithSelectItemBlock获得会话列表
                                                                        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
                                                                        
                                                                        [weakSelf _pushMainControllerAnimated:YES];
#if DEBUG
                                                                        // 自定义轨迹参数均为透传
//                                                                        [YWExtensionServiceFromProtocol(IYWExtensionForCustomerService) updateExtraInfoWithExtraUI:@"透传内容" andExtraParam:@"透传内容"];
#endif
                                                                    } failedBlock:^(NSError *aError) {
                                                                        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
                                                                        
                                                                        if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
                                                                            
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"登录失败, 可以使用游客登录。\n（如在调试，请确认AppKey、帐号、密码是否正确。）" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"游客登录", nil];
                                                                                [as showInView:weakSelf.view];
                                                                            });
                                                                        }
                                                                        
                                                                    }];
}

#pragma mark - properties

+ (NSString *)lastUserID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUserID"];
}

+ (void)setLastUserID:(NSString *)lastUserID
{
    [[NSUserDefaults standardUserDefaults] setObject:lastUserID forKey:@"lastUserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)lastPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPassword"];
}

+ (void)setLastPassword:(NSString *)lastPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:lastPassword forKey:@"lastPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - life circle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // 初始化
        self.ywcsTrackTitle = @"登录界面";
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Login"];

    BOOL shouldAutoLogin = NO;
    NSString *userID = [SPLoginController lastUserID];
    NSString *password = nil;
    if (userID) {
        password = [SPLoginController lastPassword];
    }
    else {
        shouldAutoLogin = NO;
        [self _getVisitorUserID:&userID password:&password];
    }
    
    if ([SPKitExample sharedInstance].lastConnectionStatus == YWIMConnectionStatusForceLogout || [SPKitExample sharedInstance].lastConnectionStatus == YWIMConnectionStatusMannualLogout) {
        /// 被踢或者登出后，不要自动登录
        shouldAutoLogin = NO;
    }

    [self.textFieldUserID setText:userID];
    [self.textFieldPassword setText:password];

    [self.viewInput.layer setBorderWidth:1.f];
    [self.viewInput.layer setCornerRadius:5.f];
    [self.viewInput.layer setBorderColor:[UIColor colorWithRed:0.f green:180.f/255.f blue:255.f/255.f alpha:1.f].CGColor];
    
    [self.buttonLogin.layer setCornerRadius:5.f];
    [self.buttonFeedback.layer setCornerRadius:5.f];
    
    [self _addNotifications];
    

    if (shouldAutoLogin && self.textFieldUserID.text.length > 0 && self.textFieldPassword.text.length > 0) {
        [self _tryLogin];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[SPKitExample sharedInstance] exampleGetFeedbackUnreadCount:YES inViewController:self];
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


#pragma mark - actions

- (IBAction)actionLogin:(id)sender
{
    [self.view endEditing:YES];
    
    [SPLoginController setLastUserID:self.textFieldUserID.text];
    [SPLoginController setLastPassword:self.textFieldPassword.text];
    
    [self _tryLogin];
}

- (IBAction)actionBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)actionLogoutiPad:(id)sender
{
    [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)actionCloseiPad:(id)sender
{
    [self.weakDetailNavigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)actionVisitor:(id)sender {
    NSString *userID = nil, *password = nil;
    [self _getVisitorUserID:&userID password:&password];
    
    [self.textFieldUserID setText:userID];
    [self.textFieldPassword setText:password];
    
    [self actionLogin:nil];
}

- (IBAction)actionOpenFeedback:(UIButton *)sender
{
    [[SPKitExample sharedInstance] exampleSetProfile];
    
    [[SPKitExample sharedInstance] exampleOpenFeedbackViewController:YES fromViewController:self];
}

#pragma mark - notifications

static NSValue *sOldCenter = nil;

- (void)onKeyboardWillShowNotification:(NSNotification *)aNote
{
    if (sOldCenter == nil) {
        sOldCenter = [NSValue valueWithCGPoint:self.viewOperator.center];
    }
    
    CGRect keyboardFrame = [aNote.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGPoint toPoint = CGPointMake(self.view.center.x, self.view.center.y - keyboardFrame.size.height + 50);
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.viewOperator setCenter:toPoint];
    }];
}

- (void)onKeyboardWillHideNotification:(NSNotification *)aNote
{
    if (sOldCenter) {
        [UIView animateWithDuration:0.25f animations:^{
            [self.viewOperator setCenter:sOldCenter.CGPointValue];
        }];
    }
}

- (void)onApplicationDidBecomeActiveNotification:(NSNotification *)aNote
{
    [[SPKitExample sharedInstance] exampleGetFeedbackUnreadCount:YES inViewController:self];
}

#pragma mark - UISplitViewController delegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation  NS_DEPRECATED_IOS(5_0, 8_0, "Use preferredDisplayMode instead")
{
    return NO;
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self actionVisitor:nil];
    }
}

@end
