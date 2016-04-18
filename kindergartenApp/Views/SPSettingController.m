//
//  SPSettingController.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPSettingController.h"

#import "SPKitExample.h"

#import "SPUtil.h"
#import "SPBlackListViewController.h"

@interface SPSettingItem : NSObject

- (id)initWithTitle:(NSString *)aTitle selector:(SEL)aItemSelector;

@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, assign) SEL itemSelector;

@end

@implementation SPSettingItem

- (id)initWithTitle:(NSString *)aTitle selector:(SEL)aItemSelector
{
    self = [super init];
    
    if (self) {
        self.itemTitle = aTitle;
        self.itemSelector = aItemSelector;
    }
    
    return self;
}

@end

@interface SPSettingController ()
<UITableViewDataSource, UITableViewDelegate,
UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, readonly) NSArray *arraySections;

@property (nonatomic, readonly) NSArray *arraySectionAbout, *arraySectionSetting, *arraySectionLogout;

@end

@implementation SPSettingController


#pragma mark - properties

- (NSArray *)arraySections
{
    return @[
             self.arraySectionSetting,
             self.arraySectionAbout,
             self.arraySectionLogout,
             ];
}

- (NSArray *)arraySectionSetting
{
    return @[
             [[SPSettingItem alloc] initWithTitle:@"黑名单" selector:@selector(actionBlackList)]
             ];
}

- (NSArray *)arraySectionAbout
{
    return @[
             [[SPSettingItem alloc] initWithTitle:@"联系我们" selector:@selector(actionContactUs)],
             [[SPSettingItem alloc] initWithTitle:@"功能介绍" selector:@selector(actionIntro)],
             [[SPSettingItem alloc] initWithTitle:@"反馈" selector:@selector(actionFeedback)],
             [[SPSettingItem alloc] initWithTitle:@"关于" selector:@selector(actionAbout)],
             ];
}


- (NSArray *)arraySectionLogout
{
    return @[
             [[SPSettingItem alloc] initWithTitle:@"注销" selector:@selector(actionLogout)],
             ];
}


#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"更多"];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [[SPKitExample sharedInstance] exampleGetFeedbackUnreadCount:NO inViewController:self];
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

- (void)actionBlackList
{
    SPBlackListViewController *blackList = [[SPBlackListViewController alloc] init];
    [self.navigationController pushViewController:blackList animated:YES];
}

- (void)actionContactUs
{
    [[SPKitExample sharedInstance] exampleOpenEServiceConversationWithPersonId:kSPEServicePersonIds[0] fromNavigationController:self.navigationController];
}

- (void)actionIntro
{
    YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"http://im.baichuan.taobao.com/" andImkit:[SPKitExample sharedInstance].ywIMKit];
    [controller setHidesBottomBarWhenPushed:YES];
    [controller setTitle:@"功能介绍"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)actionFeedback
{
    [[SPKitExample sharedInstance] exampleOpenFeedbackViewController:NO fromViewController:self];
}

typedef enum : NSUInteger {
    kActionSheetTagLogout,
    kActionSheetTagEnvironment,
} kActionSheetTag;

- (void)setLastEnvironment:(NSNumber *)lastEnvironment
{
    [[NSUserDefaults standardUserDefaults] setObject:lastEnvironment forKey:@"lastEnvironment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)actionSwitchEnvironment {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"切换环境" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"测试环境", @"开发环境", @"预发环境", @"线上环境", @"沙箱环境", nil];
    [as setTag:kActionSheetTagEnvironment];
    [as showInView:self.tabBarController.view];
}

- (void)actionAbout
{
    YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"http://chuye.cloud7.com.cn/7086991" andImkit:[SPKitExample sharedInstance].ywIMKit];
    [controller setHidesBottomBarWhenPushed:YES];
    
    UIButton *titleLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleLabelButton setTitle:@"关于" forState:UIControlStateNormal];
    [titleLabelButton addTarget:self action:@selector(actionSwitchEnvironment) forControlEvents:UIControlEventTouchUpInside];
    controller.navigationItem.titleView = titleLabelButton;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)actionLogout
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"退出后您将收不到新消息，是否确认退出?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出当前帐号" otherButtonTitles:nil];
    [as setTag:kActionSheetTagLogout];
    [as showInView:self.tabBarController.view];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arraySections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arraySections[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithWhite:242./255 alpha:1.0];
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:12];
    header.textLabel.shadowColor = [UIColor clearColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        NSString* dateString = @__DATE__@" "@__TIME__;
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];

        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:@"MMM d yyyy HH:mm:ss"];
        NSDate * theDate = [dateFormatter dateFromString:dateString];

        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [dateFormatter setDateFormat:@"MMddHHmm"];
        dateString = [dateFormatter stringFromDate:theDate];

        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey];

        return [NSString stringWithFormat:@"Demo:%@ %@-Core:%@-Kit:%@", version, dateString, [YWAPI sharedInstance].YWSDKCompileDate, [SPKitExample sharedInstance].ywIMKit.YWIMKitCompileDate];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSettingItem *item = self.arraySections[indexPath.section][indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
    
    {
        CGRect frame = cell.contentView.bounds;
        frame.origin.x = 14.f;
        frame.size.width -= frame.origin.x;
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [cell.contentView addSubview:label];
        
        [label setFont:[UIFont systemFontOfSize:15.f]];
        [label setTextColor:[UIColor blackColor]];
        
        [label setText:item.itemTitle];


    }
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
        if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
            cell.backgroundView = [[UIView alloc] init];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    {
        UIView *lineTop = nil, *lineBottom = nil;
        {
            lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, 0.5f)];
            [lineTop setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [lineTop setBackgroundColor:[UIColor colorWithWhite:1.f*0xdf/0xff alpha:1.f]];
            
            [cell addSubview:lineTop];
        }
        
        {
            lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 50.f - 0.5f, cell.bounds.size.width, 0.5f)];
            [lineBottom setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [lineBottom setBackgroundColor:[UIColor colorWithWhite:1.f*0xdf/0xff alpha:1.f]];
            
            [cell addSubview:lineBottom];
        }
        
        {
            [lineTop setHidden:indexPath.row != 0];
            
            if (indexPath.row != [self.arraySections[indexPath.section] count] - 1) {
                CGRect frame = lineBottom.frame;
                frame.origin.x = 14.f;
                frame.size.width -= frame.origin.x;
                [lineBottom setFrame:frame];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SPSettingItem *item = self.arraySections[indexPath.section][indexPath.row];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:item.itemSelector];
#pragma clang diagnostic pop
}

#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kActionSheetTagLogout) {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
        }
    }else if (actionSheet.tag == kActionSheetTagEnvironment) {
        
        switch (buttonIndex - actionSheet.firstOtherButtonIndex) {
            case 0:
                [[YWAPI sharedInstance] changeEnvironment:YWEnvironmentDailyForTester];
                break;
            case 1:
                [[YWAPI sharedInstance] changeEnvironment:YWEnvironmentDailyForDeveloper];
                break;
            case 2:
                [[YWAPI sharedInstance] changeEnvironment:YWEnvironmentPreRelease];
                break;
            case 3:
                [[YWAPI sharedInstance] changeEnvironment:YWEnvironmentRelease];
                break;
            case 4:
                [[YWAPI sharedInstance] changeEnvironment:YWEnvironmentSandBox];
                break;
                
            default:
                break;
        }
        [self setLastEnvironment:@([[YWAPI sharedInstance] environment])];
        // 重启
        exit(0);
    }
}


@end
