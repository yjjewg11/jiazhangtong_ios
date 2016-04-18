//
//  SPSearchContactViewController.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/21.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPSearchContactViewController.h"
#import "SPKitExample.h"
#import "SPUtil.h"
#import "SPContactCell.h"
#import "SPContactManager.h"

@interface SPSearchContactViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSMutableDictionary *cachedDisplayNames;
@property (strong, nonatomic) NSMutableDictionary *cachedAvatars;


@end

@implementation SPSearchContactViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.navigationItem.title = @"搜索联系人";

    [self.tableView registerNib:[UINib nibWithNibName:@"SPContactCell" bundle:nil]
         forCellReuseIdentifier:@"ContactCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];


    self.cachedAvatars = [NSMutableDictionary dictionary];
    self.cachedDisplayNames = [NSMutableDictionary dictionary];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.searchTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.searchTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSearch:(id)sender {
    if( [self.searchTextField.text length] == 0 ){
        return;
    }
    YWPerson *person = [[YWPerson alloc] initWithPersonId:self.searchTextField.text];
    __weak __typeof(self) weakSelf = self;
    [[[self ywIMCore] getContactService] asyncGetProfileForPerson:person
                                                         progress:nil
                                                  completionBlock:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aIsSuccess && aPerson) {
                                                          if (aDisplayName) {
                                                              weakSelf.cachedDisplayNames[aPerson.personId] = aDisplayName;
                                                          }
                                                          if (aAvatarImage) {
                                                              weakSelf.cachedAvatars[aPerson.personId] = aAvatarImage;
                                                          }
                                                          weakSelf.results = @[aPerson];
                                                          [weakSelf.tableView reloadData];
                                                      }
                                                      else {
                                                          [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                                                              title:@"未找到该用户，请确认帐号后重试"
                                                                                                           subtitle:nil
                                                                                                               type:SPMessageNotificationTypeError];
                                                      }
                                                  }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchTextField) {
        [self onSearch:nil];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.results = nil;
    [self.tableView reloadData];

    return YES;
}

#pragma mark - UITableView DataSource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWPerson *person = self.results[indexPath.row];

    NSString *name = nil;
    UIImage *avatar = nil;

    // 使用服务端的资料
    name = self.cachedDisplayNames[person.personId];
    if (!name) {
        name = person.personId;
    }
    avatar = self.cachedAvatars[person.personId];
    if (!avatar) {
        avatar = [UIImage imageNamed:@"demo_head_120"];
    }

    SPContactCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ContactCell"
                                                         forIndexPath:indexPath];
    [cell configureWithAvatar:avatar title:name subtitle:nil];


    BOOL isMe = [person.personId isEqualToString:[[[self ywIMCore] getLoginService] currentLoginedUserId]];
    BOOL isFriend = [[[self ywIMCore] getContactService] ifPersonIsFriend:person];

    if (isMe || isFriend) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        cell.accessoryView = label;
        if (isMe) {
            label.text = @"自己";
        }
        else {
            label.text = @"好友";
        }
        [label sizeToFit];
    }
    else {
        cell.accessoryView = nil;
        CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect accessoryViewFrame = CGRectMake(windowWidth - 100, (cell.frame.size.height - 30)/2, 80, 30);
        UIButton *button = [[UIButton alloc] initWithFrame:accessoryViewFrame];
        [button setTitle:@"添加好友" forState:UIControlStateNormal];
        UIColor *color = [UIColor colorWithRed:0 green:180./255 blue:1.0 alpha:1.0];
        [button setTitleColor:color forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        button.layer.borderColor = color.CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 4.0f;
        button.backgroundColor = [UIColor clearColor];
        button.clipsToBounds = YES;
        [button addTarget:self
                   action:@selector(addContactButtonTapped:event:)
         forControlEvents:UIControlEventTouchUpInside];
//        cell.accessoryView = button;
        [cell.contentView addSubview:button];;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWPerson *person = self.results[indexPath.row];

    NSString *personId = person.personId;
    BOOL isEService = personId && [kSPEServicePersonIds containsObject:personId];

    if (isEService) {
        //  SPUtil中包含的功能都是Demo中需要的辅助代码，在你的真实APP中一般都需要替换为你真实的实现。
        [[SPKitExample sharedInstance] exampleOpenEServiceConversationWithPersonId:personId fromNavigationController:self.navigationController];
    } else {
        YWPerson *person = [[YWPerson alloc] initWithPersonId:personId];
        [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    YWPerson *person = self.results[indexPath.row];
    BOOL isMe = [person.personId isEqualToString:[[[self ywIMCore] getLoginService] currentLoginedUserId]];
    return !isMe;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    YWPerson *person = self.results[indexPath.row];
    [[SPContactManager defaultManager] addContact:person];

    [self.tableView reloadData];
}

- (void)addContactButtonTapped:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

@end
