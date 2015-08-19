//
//  ChatViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/29.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "ChatViewController.h"
#import "UUInputFunctionView.h"
#import "MJRefreshHeaderView.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "KGEmojiManage.h"
#import "KGHttpService.h"
#import "KGEmojiManage.h"
#import "WriteVO.h"
#import "QueryChatsVO.h"
#import "ChatInfoDomain.h"
#import "KGHUD.h"

@interface ChatViewController () <UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate> {
    UUInputFunctionView *IFView;
}

@property (strong, nonatomic) IBOutlet UITableView * chatTableView;
@property (strong, nonatomic) MJRefreshHeaderView  * head;
@property (strong, nonatomic) ChatModel * chatModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (assign, nonatomic) NSUInteger pageNo;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pageNo = 0;
    self.title = _addressbookDomain.name;
    
    [self loadBaseViewsAndData];
    [self loadInputFuniView];
    
    __weak typeof(self) weakSelf = self;
    [_chatTableView addHeaderWithCallback:^{
        [weakSelf getChatInfoList:weakSelf.pageNo+1];
    }];
    [_chatTableView headerBeginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


//加载底部输入功能View
- (void)loadInputFuniView {
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self isShow:YES];
    IFView.delegate = self;
    [self.view addSubview:IFView];
}

- (void)loadChatListData:(NSArray *)chatsArray {
    self.chatModel.isTeacher = _addressbookDomain.type;
    [self.chatModel addChatInfosToDataSource:chatsArray];
    [self.chatTableView reloadData];
    if (_pageNo == 1) {
        [self tableViewScrollToBottom];
    }
}

- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
   
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
    }else{
        self.bottomConstraint.constant = 40;
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    IFView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
    
    [self sendTextInfo:[KGEmojiManage sharedManage].chatHTMLInfo];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addSpecifiedItem:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}

//提交发送文本
- (void)sendTextInfo:(NSString *)message {
    WriteVO * writeVO = [[WriteVO alloc] init];
    writeVO.isTeacher = _addressbookDomain.type;
    writeVO.revice_useruuid = _addressbookDomain.teacher_uuid;
    writeVO.message = message;
    
    [[KGHttpService sharedService] saveAddressBookInfo:writeVO success:^(NSString *msgStr) {
        
        [KGEmojiManage sharedManage].chatHTMLInfo = nil;
    } faild:^(NSString *errorMsg) {
        
    }];
}

//发送图片
- (void)sendImgInfo:(UIImage *)image {
    
    [[KGHttpService sharedService] uploadImg:image withName:@"file" type:0 success:^(NSString *msgStr) {
        
        [self sendTextInfo:msgStr];
        
    } faild:^(NSString *errorMsg) {
        
    }];
}

- (void)getChatInfoList:(NSUInteger)pageNo {
    QueryChatsVO * queryVO = [[QueryChatsVO alloc] init];
    queryVO.isTeacher = _addressbookDomain.type;
    queryVO.uuid = _addressbookDomain.teacher_uuid;
    queryVO.pageNo = pageNo;
    
    [[KGHttpService sharedService] getTeacherOrLeaderMsgList:queryVO success:^(NSArray *msgArray) {
        if (msgArray && msgArray.count != 0) {
            ++_pageNo;
        }
        [self resetChatNameToTitle:msgArray];
        [self loadChatListData:msgArray];
        [_chatTableView headerEndRefreshing];
    } faild:^(NSString *errorMsg) {
        [_chatTableView headerEndRefreshing];
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}

//设置聊天对方名字
- (void)resetChatNameToTitle:(NSArray *)msgArray {
    NSString * loginName = [KGHttpService sharedService].loginRespDomain.userinfo.name;
    for(ChatInfoDomain * domain in msgArray) {
        if(![domain.send_user isEqualToString:loginName]) {
            self.title = domain.send_user;
            break;
        }
    }
}


@end
