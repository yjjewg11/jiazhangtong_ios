//
//  SPBlackListViewController.m
//  WXOpenIMSampleDev
//
//  Created by sidian on 15/12/29.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPBlackListViewController.h"
#import "SPKitExample.h"
#import "SPContactCell.h"
#import "SPUtil.h"

#import <WXOUIModule/YWIndicator.h>

NSString * const kYWBlackListCellIdentifier = @"kYWBlackListCellIdentifier";


@interface SPBlackListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *blackList;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation SPBlackListViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateBlackList];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [_tableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil] forCellReuseIdentifier:kYWBlackListCellIdentifier];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    self.title = @"黑名单";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_blackList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kYWBlackListCellIdentifier forIndexPath:indexPath];
    
    YWPerson *person = _blackList[indexPath.row];
    cell.identifier = person.personId;
    
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
        displayName = person.personId;
        
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

    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        YWPerson *person = _blackList[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] removePersonFromBlackList:person withResultBlock:^(NSError *error, YWPerson *person) {
            BOOL isSuccess = (error == nil || error.code == 0);
            [YWIndicator showTopToastTitle:isSuccess ? @"移出黑名单成功" : @"移出黑名单失败" content:nil userInfo:nil withTimeToDisplay:1.5f andClickBlock:nil];
            if(isSuccess) {
                [weakSelf updateBlackList];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - internal
- (void)updateBlackList
{
    __weak typeof(self) weakSelf = self;
    [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] fetchBlackListWithCompletionBlock:^(NSError *error, NSArray *blackList) {
        if (error == nil || error.code == 0) {
            weakSelf.blackList = [blackList mutableCopy];
            [weakSelf.tableView reloadData];
            [weakSelf showAddTipsIfNeed];
        }
    }];
}

- (void)showAddTipsIfNeed
{
    if ([self.blackList count] == 0) {
        if (_tipLabel == nil) {
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 50)/2, self.view.frame.size.width, 30)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.textColor = [UIColor lightGrayColor];
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.font = [UIFont systemFontOfSize:13.f];
            tipLabel.text = @"您可以在单聊的设置界面添加黑名单";
            _tipLabel = tipLabel;
        }
        [self.view addSubview:_tipLabel];
    } else {
        [_tipLabel removeFromSuperview];
    }
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
