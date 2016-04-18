//
//  SPTabBarViewController.m
//  WXOpenIMSampleDev
//
//  Created by shili.nzy on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPTabBarViewController.h"
#import "SPKitExample.h"


#import "SPContactListController.h"
#import "SPTribeListViewController.h"
#import "SPSettingController.h"
#import "SPTribeSystemConversationViewController.h"
#import "SPUtil.h"
#import <YWExtensionForCustomerServiceFMWK/YWExtensionForCustomerServiceFMWK.h>

#import "YWConversationListViewController+UIViewControllerPreviewing.h"

#define kTabbarItemCount    4

@interface SPTabBarViewController ()

@end

@implementation SPTabBarViewController


#pragma mark - private

- (UITabBarItem *)_makeItemWithTitle:(NSString *)aTitle normalName:(NSString *)aNormal selectedName:(NSString *)aSelected tag:(NSInteger)aTag
{
    UITabBarItem *result = nil;
    
    UIImage *nor = [UIImage imageNamed:aNormal];
    UIImage *sel = [UIImage imageNamed:aSelected];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.f) {
        result = [[UITabBarItem alloc] initWithTitle:aTitle image:nor selectedImage:sel];
        [result setTag:aTag];
    } else {
        result = [[UITabBarItem alloc] initWithTitle:aTitle image:nor tag:aTag];
    }
    
    return result;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tabBar.translucent = NO;

    NSMutableArray *aryControllers = [NSMutableArray array];
    
    /// 会话列表页面
    {

        YWConversationListViewController *conversationListController = [[SPKitExample sharedInstance].ywIMKit makeConversationListViewController];
        [[SPKitExample sharedInstance] exampleCustomizeConversationCellWithConversationListController:conversationListController];

        __weak __typeof(conversationListController) weakConversationListController = conversationListController;
        conversationListController.didSelectItemBlock = ^(YWConversation *aConversation) {
            if ([aConversation isKindOfClass:[YWCustomConversation class]]) {
                YWCustomConversation *customConversation = (YWCustomConversation *)aConversation;
                [customConversation markConversationAsRead];

                if ([customConversation.conversationId isEqualToString:SPTribeSystemConversationID]) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tribe" bundle:nil];
                    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SPTribeSystemConversationViewController"];
                    [weakConversationListController.navigationController pushViewController:controller animated:YES];
                } 
                else if ([customConversation.conversationId isEqualToString:kSPCustomConversationIdForFAQ]) {
                    YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"http://bbs.aliyun.com/searcher.php?step=2&method=AND&type=thread&verify=d26d3c6e63c0b37d&sch_area=1&fid=285&sch_time=all&keyword=汇总" andImkit:[SPKitExample sharedInstance].ywIMKit];
                    [controller setHidesBottomBarWhenPushed:YES];
                    [controller setTitle:@"云旺iOS精华问题"];
                    [weakConversationListController.navigationController pushViewController:controller animated:YES];
                }
                else {
                    YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"http://im.baichuan.taobao.com/" andImkit:[SPKitExample sharedInstance].ywIMKit];
                    [controller setHidesBottomBarWhenPushed:YES];
                    [controller setTitle:@"功能介绍"];
                    [weakConversationListController.navigationController pushViewController:controller animated:YES];
                }
            }
            else {
                [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithConversation:aConversation
                                                                            fromNavigationController:weakConversationListController.navigationController];
            }
        };

        conversationListController.ywcsTrackTitle = @"会话列表";
        
        // 会话列表空视图
        if (conversationListController)
        {
            CGRect frame = CGRectMake(0, 0, 100, 100);
            UIView *viewForNoData = [[UIView alloc] initWithFrame:frame];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
            imageView.center = CGPointMake(viewForNoData.frame.size.width/2, viewForNoData.frame.size.height/2);
            [imageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
            
            [viewForNoData addSubview:imageView];
            
            conversationListController.viewForNoData = viewForNoData;
        }
        
        {
            __weak typeof(conversationListController) weakController = conversationListController;
            [conversationListController setViewDidLoadBlock:^{
//                weakController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:weakSelf action:@selector(addCustomConversation)];

//                // 加入搜索栏
//                weakController.tableView.tableHeaderView = weakController.searchBar;
//                CGPoint contentOffset = CGPointMake(0, weakController.searchBar.frame.size.height);
//                [weakController.tableView setContentOffset:contentOffset animated:NO];

                if ([weakController respondsToSelector:@selector(traitCollection)]) {
                    UITraitCollection *traitCollection = weakController.traitCollection;
                    if ( [traitCollection respondsToSelector:@selector(forceTouchCapability)] ) {
                        if (traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                            [weakController registerForPreviewingWithDelegate:weakController sourceView:weakController.tableView];
                        }
                    }
                }
            }];
        }


        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:conversationListController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"消息" normalName:@"news_nor" selectedName:@"news_pre" tag:100];
        [naviController setTabBarItem:item];

        [aryControllers addObject:naviController];


        __weak typeof(naviController) weakController = naviController;
        [[SPKitExample sharedInstance].ywIMKit setUnreadCountChangedBlock:^(NSInteger aCount) {
            NSString *badgeValue = aCount > 0 ?[ @(aCount) stringValue] : nil;
            weakController.tabBarItem.badgeValue = badgeValue;
        }];
    }
    
    /// 联系人列表页面
    {
        SPContactListController *contactListController = [[SPContactListController alloc] initWithNibName:@"SPContactListController" bundle:nil];
        
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:contactListController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"联系人" normalName:@"contact_nor" selectedName:@"contact_pre" tag:101];
        [naviController setTabBarItem:item];

        [aryControllers addObject:naviController];
    }
    
    /// 群页面
    {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tribe" bundle:nil];
        UINavigationController *navigationController = [storyboard instantiateInitialViewController];

//        SPTribeListViewController *tribeController
//        SPTribeListViewController *tribeController = [[SPTribeListViewController alloc] init];
//        
//        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:tribeController];

        UITabBarItem *item = [self _makeItemWithTitle:@"群列表" normalName:@"group_nor" selectedName:@"group_pre" tag:102];
        [navigationController setTabBarItem:item];

        [aryControllers addObject:navigationController];
    }
    
    /// 设置页面
    {
        SPSettingController *settingController = [[SPSettingController alloc] initWithNibName:@"SPSettingController" bundle:nil];
        
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:settingController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"更多" normalName:@"set_nor" selectedName:@"set_pre" tag:103];
        [naviController setTabBarItem:item];

        [aryControllers addObject:naviController];
    }
    
    self.viewControllers = aryControllers;

}

- (void)addCustomConversation
{
    [[SPKitExample sharedInstance] exampleAddOrUpdateCustomConversation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
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
