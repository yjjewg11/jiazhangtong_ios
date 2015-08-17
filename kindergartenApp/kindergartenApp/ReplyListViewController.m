//
//  ReplyListViewController.m
//  kindergartenApp
//
//  Created by You on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "ReplyListViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "PageInfoDomain.h"
#import "ReFreshTableViewController.h"
#import "UIColor+Extension.h"
#import "KGTextField.h"
#import "KGNSStringUtil.h"

@interface ReplyListViewController () <KGReFreshViewDelegate> {
    ReFreshTableViewController * reFreshView;
    PageInfoDomain * pageInfo;
    
    IBOutlet KGTextField *replyTextField;
    IBOutlet UIButton *sendBtn;
}


@end

@implementation ReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    
    [self initPageInfo];
    [self initReFreshView];
    replyTextField.placeholder = @"写下您的评论...";
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
    
    [[KGHttpService sharedService] getReplyList:pageInfo topicUUID:_topicUUID success:^(PageInfoDomain *pageInfoResp) {
        reFreshView.tableParam.dataSourceMArray = pageInfoResp.data;
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
    reFreshView.tableParam.cellClassNameStr = @"ReplyTableViewCell";
    reFreshView.tableView.backgroundColor = KGColorFrom16(0xE7E7EE);
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
    
}

//键盘回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self postTopic];
    return YES;
}


- (IBAction)sendBtnClicked:(UIButton *)sender {
    [replyTextField resignFirstResponder];
    [self postTopic];
}


- (void)postTopic {
    [[KGHUD sharedHud] show:self.contentView];
    NSString * replyText = [KGNSStringUtil trimString:replyTextField.text];
    if(replyText && ![replyText isEqualToString:String_DefValue_Empty]) {
        ReplyDomain * replyObj = [[ReplyDomain alloc] init];
        replyObj.content = replyText;
        replyObj.newsuuid = _topicUUID;
        replyObj.type = _topicType;
        
        [[KGHttpService sharedService] saveReply:replyObj success:^(NSString *msgStr) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
            
            ReplyDomain * domain = [[ReplyDomain alloc] init];
            domain.content = replyText;
            domain.newsuuid = _topicUUID;
            domain.type = _topicType;
            domain.create_user = [KGHttpService sharedService].loginRespDomain.userinfo.name;;
            domain.create_useruuid = [KGHttpService sharedService].loginRespDomain.userinfo.uuid;
            
            if(reFreshView.dataSource) {
                [reFreshView.dataSource insertObject:domain atIndex:Number_Zero];
            } else {
                NSArray * array = [[NSArray alloc] initWithObjects:domain, nil];
                reFreshView.tableParam.dataSourceMArray = array;
            }
            
            [reFreshView.tableView reloadData];
            replyTextField.text = String_DefValue_Empty;
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写评论." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)alttextFieldDidEndEditing:(UITextField *)textField {
    [self postTopic];
}

@end
