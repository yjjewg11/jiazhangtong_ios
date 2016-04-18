//
//  SPContactRequestListController.m
//  WXOpenIMSampleDev
//
//  Created by sidian on 15/12/28.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPContactRequestListController.h"
#import <WXOUIModule/YWIMKit.h>
#import <WXOUIModule/YWIndicator.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

#import "SPContactCell.h"
#import "SPKitExample.h"
#import "SPUtil.h"
#import "UIControl+BlockSupport.h"


@interface SPContactRequestListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YWConversation *conversation;

@end

@implementation SPContactRequestListController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"好友请求";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil]
         forCellReuseIdentifier:@"ContactCell"];
    [self.view addSubview:_tableView];
    
    _conversation = [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] fetchContactSystemConversation];
    
    __weak typeof(self) weakSelf = self;
    [_conversation setOnNewMessageBlockV2:^(NSArray *aMessages, BOOL aIsOffline) {
        [weakSelf.tableView reloadData];
    }];
    [_conversation loadMoreMessages:100 completion:^(BOOL existMore) {
        [weakSelf.tableView reloadData];
    }];
    
    [_conversation setDidChangeContentBlock:^(){
        [weakSelf.tableView reloadData];
    }];
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

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_conversation fetchedObjects].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPContactCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ContactCell"
                                                         forIndexPath:indexPath];
    
    id<IYWMessage> message = [[_conversation fetchedObjects] objectAtIndex:indexPath.row];
    
    YWPerson *person = [message messageFromPerson];
    NSString *personId = person.personId;
    
    cell.identifier = personId;
    
    __block NSString *displayName = nil;
    __block UIImage *avatar = nil;
    //  SPUtil中包含的功能都是Demo中需要的辅助代码，在你的真实APP中一般都需要替换为你真实的实现。
    [[SPUtil sharedInstance] syncGetCachedProfileIfExists:person completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
        displayName = aDisplayName;
        avatar = aAvatarImage;
    }];
    
    if (!avatar) {
        avatar = [UIImage imageNamed:@"demo_head_120"];
    }
    __weak __typeof(self) weakSelf = self;

    if (!displayName) {
        displayName = personId;
        
        __weak __typeof(cell) weakCell = cell;
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:person
                                                  progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndexPath = [weakSelf.tableView indexPathForCell:weakCell];
                                                          if (!aIndexPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.tableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  } completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndexPath = [weakSelf.tableView indexPathForCell:weakCell];
                                                          if (!aIndexPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.tableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  }];
    }
    
    [cell configureWithAvatar:avatar title:displayName subtitle:nil];
    
    CGRect frame = CGRectMake(0, 15, 60, 34.f);
    YWMessageBodyContactSystem *contactsystem = (YWMessageBodyContactSystem *)[message messageBody];
    if ([contactsystem isKindOfClass:[YWMessageBodyContactSystem class]]) {
        if (contactsystem.requestStatus == YWAddContactRequestStatusAccepted || contactsystem.requestStatus == YWAddContactRequestStatusRefused) {
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.text = contactsystem.requestStatus == YWAddContactRequestStatusAccepted ? @"已接受"  : @"拒绝" ;
            label.backgroundColor = [UIColor clearColor];
            cell.accessoryView = label;
        } else if (contactsystem.requestStatus == YWAddContactRequestStatusNull) {
            UIButton *button = [[UIButton alloc] initWithFrame:frame];
            [button setTitle:@"接受" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:38/255.f green:191/255.f blue:1 alpha:1.f]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 4.f;
            button.clipsToBounds = YES;
            [button addblock:^{
                [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] responseToAddContact:YES fromPerson:person withMessage:@"" andResultBlock:^(NSError *error, YWPerson *person) {
                    if (error == nil) {
                        [YWIndicator showTopToastTitle:@"操作成功" content:@"通过好友申请" userInfo:nil withTimeToDisplay:1.5f andClickBlock:nil];
                        [weakSelf.tableView reloadData];
                    } else {
                        [YWIndicator showTopToastTitle:@"操作失败" content:@"通过好友申请" userInfo:nil withTimeToDisplay:1.5f andClickBlock:nil];
                    }
                }];
            } forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = button;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
