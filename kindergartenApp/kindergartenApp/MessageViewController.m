//
//  MessageViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "MessageViewController.h"
#import "ReFreshTableViewController.h"
#import "KGHttpService.h"
#import "MessageDomain.h"
#import "KGHUD.h"
#import "PageInfoDomain.h"
#import "UIColor+Extension.h"
#import "BrowseURLViewController.h"
#import "InteractViewController.h"
#import "IntroductionViewController.h"
#import "TimetableViewController.h"
#import "RecipesListViewController.h"
#import "GiftwareArticlesInfoViewController.h"
#import "AnnouncementInfoViewController.h"
#import "MessageTableViewCell.h"
#import "AddressBookDomain.h"
#import "ChatViewController.h"
#import "StudentSignRecordViewController.h"

@interface MessageViewController () <KGReFreshViewDelegate> {
    ReFreshTableViewController * reFreshView;
    PageInfoDomain * pageInfo;
}

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    
    [self initPageInfo];
    [self initReFreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initPageInfo {
    if(!pageInfo) {
        pageInfo = [[PageInfoDomain alloc] init];
    }
}


//获取数据加载表格
- (void)getTableData{
    pageInfo.pageNo = reFreshView.page;
    pageInfo.pageSize = reFreshView.pageSize;
    
    [[KGHttpService sharedService] getMessageList:pageInfo success:^(NSArray *messageArray) {
        reFreshView.tableParam.dataSourceMArray = messageArray;
        [reFreshView reloadRefreshTable];
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        [reFreshView endRefreshing];
    }];
}


//初始化列表
- (void)initReFreshView{
    reFreshView = [[ReFreshTableViewController alloc] initRefreshView];
    reFreshView._delegate = self;
    reFreshView.tableParam.cellHeight       = 78;
    reFreshView.tableParam.cellClassNameStr = @"MessageTableViewCell";
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xEBEBF2);
    [reFreshView appendToView:self.contentView];
    [reFreshView beginRefreshing];
}

#pragma reFreshView Delegate

/**
 *  选中cell
 *
 *  @param baseDomain  选中cell绑定的数据对象
 *  @param tableView   tableView
 *  @param indexPath   indexPath
 */
- (void)didSelectRowCallBack:(id)baseDomain tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    MessageDomain * domain = (MessageDomain *)baseDomain;
    
    BaseViewController * vc = nil;
    
    switch (domain.type) {
        case Topic_XYGG:
        case Topic_Announcement:
            vc = [[AnnouncementInfoViewController alloc] init];
            ((AnnouncementInfoViewController *)vc).annuuid = domain.rel_uuid;
            break;
        case Topic_Articles:
            vc = [[GiftwareArticlesInfoViewController alloc] init];
            ((GiftwareArticlesInfoViewController *)vc).annuuid = domain.rel_uuid;
            break;
        case Topic_ZSJH:
            vc = [[IntroductionViewController alloc] init];
            ((IntroductionViewController *)vc).isNoXYXG = YES;
            break;
        case Topic_Recipes:
            vc = [[RecipesListViewController alloc] init];
            ((RecipesListViewController *)vc).groupuuid = domain.group_uuid;
            break;
        case Topic_JPKC:
            vc = [[TimetableViewController alloc] init];
            break;
        case Topic_YEYJS:
            vc = [[IntroductionViewController alloc] init];
            break;
        case Topic_Interact:
            vc = [[InteractViewController alloc] init];
            break;
        case Topic_TeacherChat:
        case Topic_LeaderChat:
            [self chatMesagePush:domain];
            break;
        case Topic_SignRecord:
            vc = [[StudentSignRecordViewController alloc] init];
            break;
        case Topic_HTML:
            vc = [[BrowseURLViewController alloc] init];
            ((BrowseURLViewController *)vc).url = domain.url;
            break;
        default:
            break;
    }
    
    if(vc) {
        vc.title = domain.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    MessageTableViewCell * cell = (MessageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self readMessage:domain cell:cell];
}

- (void)chatMesagePush:(MessageDomain *)domain {
    AddressBookDomain * addressbookDomain = [[AddressBookDomain alloc] init];
    addressbookDomain.teacher_uuid = domain.rel_uuid;
    addressbookDomain.type = (domain.type == Topic_TeacherChat) ? YES : NO;
    ChatViewController * chatVC = [[ChatViewController alloc] init];
    chatVC.addressbookDomain = addressbookDomain;
    [self.navigationController pushViewController:chatVC animated:YES];
}

//readMsg
- (void)readMessage:(MessageDomain *)domain cell:(MessageTableViewCell *)cell {
    [[KGHttpService sharedService] readMessage:domain.uuid success:^(NSString *msgStr) {
        domain.isread = YES;
        
        cell.unReadIconImageView.hidden = YES;
        
    } faild:^(NSString *errorMsg) {
        
    }];
}


@end
