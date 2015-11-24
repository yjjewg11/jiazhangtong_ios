//
//  MySPCourseCommentVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseCommentVC.h"
#import "KGHUD.h"
#import "KGHttpService.h"
#import "MySPCommentDomain.h"
#import "MJExtension.h"
#import "SPTeacherDomain.h"
#import "MySPCourseCommentCell.h"
#import "MySPNormalCell.h"
#import "MySPCourseTeacherList.h"
#import "MySPButtonCell.h"
#import "MySPTeacherCommentCell.h"
#import "MBProgressHUD+HM.h"

@interface MySPCourseCommentVC () <UITableViewDataSource,UITableViewDelegate,MySPButtonCellDelegate,MySPTeacherCommentCellDelegate,MySPCourseCommentCellDelegate,MySPNormalCellDelegate>
{
    MySPCourseCommentCell * _courseCell;
    
    MySPNormalCell * _schoolCell;
    
    NSMutableArray * _teachersCell;
}

@property (strong, nonatomic) NSMutableArray * commentsArr;

@property (assign, nonatomic) BOOL flag;   //标识是否我评价了

@property (strong, nonatomic) MySPCommentDomain * courseDomain;

@property (strong, nonatomic) MySPCommentDomain * schoolDomain;

@property (strong, nonatomic) NSMutableArray * teachersDomain;

@property (strong, nonatomic) NSMutableArray * teacherList;

@property (strong, nonatomic) NSString * tempCommentText;

@property (strong, nonatomic) NSString * courseScore;

@property (strong, nonatomic) NSString * schoolScore;

@property (assign, nonatomic) BOOL coursecellEdited;

@property (assign, nonatomic) BOOL schoolcellEdited;

@end

@implementation MySPCourseCommentVC

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if ( self = [super initWithStyle:UITableViewStyleGrouped])
    {
        
    }
    
    return self;
}

- (NSMutableArray *)teacherList
{
    if (_teacherList == nil)
    {
        _teacherList = [NSMutableArray array];
    }
    return _teacherList;
}

- (MySPCommentDomain *)courseDomain
{
    if (_courseDomain == nil)
    {
        _courseDomain = [[MySPCommentDomain alloc] init];
    }
    return _courseDomain;
}

- (MySPCommentDomain *)schoolDomain
{
    if (_schoolDomain == nil)
    {
        _schoolDomain = [[MySPCommentDomain alloc] init];
    }
    return _schoolDomain;
}

- (NSMutableArray *)teachersDomain
{
    if (_teachersDomain == nil)
    {
        _teachersDomain = [NSMutableArray array];
    }
    return _teachersDomain;
}

- (NSMutableArray *)commentsArr
{
    if (_commentsArr == nil)
    {
        _commentsArr = [NSMutableArray array];
    }
    return _commentsArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.courseScore = @"50";
    
    _teachersCell = [NSMutableArray array];
    
    self.coursecellEdited = NO;
    
    self.schoolcellEdited = NO;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = self.tableFrame;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    //请求老师列表
    [self getTeacherList];
}

#pragma mark - 请求老师列表
- (void)getTeacherList
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] MySPCourseTeacherList:self.classuuid success:^(NSArray *teacherArr)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        self.teacherList = [NSMutableArray arrayWithArray:teacherArr];
        
        //请求我的评价
        [self getCourseComment];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

#pragma mark - 请求我的评价
- (void)getCourseComment
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] MySPCourseComment:self.classuuid pageNo:@"0" success:^(SPDataListVO *msg)
    {
        [[KGHUD sharedHud] hide:self.view];
        
        self.commentsArr = [NSMutableArray arrayWithArray:[MySPCommentDomain objectArrayWithKeyValuesArray:msg.data]];
        
        if (self.commentsArr.count == 0 || self.commentsArr == nil)
        {
            self.flag = NO;
            [self initData];
        }
        else
        {
            self.flag = YES;
            [self separateData];
        }

        [self.tableView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
    
}

#pragma mark - 没评价，初始化数据
- (void)initData
{
    if (self.schoolcellEdited == NO)
    {
        self.schoolDomain.score = @"50";
    }
    
    if (self.courseDomain.score == NO)
    {
        self.courseDomain.score = @"50";
    }
    
    for (MySPCourseTeacherList * domain in self.teacherList)
    {
        domain.score = @"50";
    }
}

#pragma mark - 若评价了，把返回数据分类
- (void)separateData
{
    for (MySPCommentDomain * data in self.commentsArr)
    {
        if (data.type == Topic_PXKC)
        {
            self.courseDomain = data;
        }
        
        else if (data.type == Topic_PXJG)
        {
            self.schoolDomain = data;
        }
        
        else if (data.type == Topic_PXJS)
        {
            for (MySPCourseTeacherList *listDomain in self.teacherList)
            {
                if ([listDomain.uuid isEqualToString:data.ext_uuid])
                {
                    listDomain.score = data.score;
                }
            }
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 1 + self.teacherList.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString * coursecellid = @"coursecellid";
        
        MySPCourseCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:coursecellid];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MySPCourseCommentCell" owner:nil options:nil] firstObject];
        }
        
        cell.delegate = self;
        
        _courseCell = cell;
        
        if (self.courseDomain.score == NO)
        {
            self.courseDomain.score = @"50";
        }
        else
        {
            self.courseDomain.score = self.courseScore;
        }
        
        [cell setData:self.courseDomain];
        
        if (self.tempCommentText != nil || ![self.tempCommentText isEqualToString:@""])
        {
            cell.textView.text = self.tempCommentText;
        }
        
        if (self.flag == YES) //评价了
        {
            cell.textView.editable = NO;
            
            cell.textView.backgroundColor = [UIColor whiteColor];
            
            cell.textView.textColor = [UIColor blackColor];
            
            cell.starView.userInteractionEnabled = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)  //学校
        {
            static NSString * schoolcellid = @"schoolcellid";
            
            MySPNormalCell * cell = [tableView dequeueReusableCellWithIdentifier:schoolcellid];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MySPNormalCell" owner:nil options:nil] firstObject];
            }
            
            cell.delegate = self;
            
            _schoolCell = cell;
            
            if (self.schoolcellEdited == NO)
            {
                self.schoolDomain.score = @"50";
            }
            else
            {
                self.schoolDomain.score = self.schoolScore;
            }
            
            [cell setSchoolData:self.schoolDomain];
            
            if (self.flag == YES)
            {
                cell.starView.userInteractionEnabled = NO;
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else                     //教师
        {
            static NSString * teachercellid = @"teachercellid";
            
            MySPTeacherCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:teachercellid];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MySPTeacherCommentCell" owner:nil options:nil] firstObject];
            }
            
            [_teachersCell addObject:cell];
            
            cell.delegate = self;
            
            [cell setData:self.teacherList[indexPath.row - 1] teacherList:self.teacherList indexRow:indexPath.row];
            
            if (self.flag == YES)
            {
                for (UIButton * b in cell.starView.subviews)
                {
                    b.enabled = NO;
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    
    if (indexPath.section == 2)
    {
        MySPButtonCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MySPButtonCell" owner:nil options:nil] firstObject];
        
        cell.delegate = self;
        
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        if (self.flag == YES)
        {
            cell.btn.backgroundColor = [UIColor grayColor];
            
            [cell.btn setTitle:@"已评价" forState:UIControlStateNormal];
            
            cell.btn.enabled = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 160;
    }
    
    if (indexPath.section == 1)
    {
        return 50;
    }
    
    if (indexPath.section == 2)
    {
        return 40;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    else
    {
        return 10;
    }
}

#pragma mark - 提交按钮代理方法
- (void)saveComments:(MySPButtonCell *)cell
{
    self.flag = YES;
    
    _courseCell.textView.text = _courseCell.content;
    
    _courseCell.textView.editable = NO;
    
    _courseCell.textView.backgroundColor = [UIColor whiteColor];
    
    _courseCell.textView.textColor = [UIColor blackColor];
    
    cell.btn.backgroundColor = [UIColor grayColor];
    
    [cell.btn setTitle:@"已评价" forState:UIControlStateNormal];
    
    cell.btn.enabled = NO;
    
    _courseCell.starView.userInteractionEnabled = NO;

    _schoolCell.starView.userInteractionEnabled = NO;
    
    for (MySPTeacherCommentCell * cell in _teachersCell)
    {
        cell.userInteractionEnabled = NO;
    }
    
    [self commentCourse];
}

#pragma mark - 课程评价
//课程评价
- (void)commentCourse
{
    [[KGHttpService sharedService] MySPCourseSaveComment:self.courseuuid classuuid:self.classuuid type:[NSString stringWithFormat:@"%d",Topic_PXKC] score:self.courseScore content:_courseCell.content success:^(NSString *mgr)
     {
         [self commentSchool];
     }
     faild:^(NSString *errorMsg)
     {
         
     }];
}

//学校评价
- (void)commentSchool
{
    [[KGHttpService sharedService] MySPCourseSaveComment:self.groupuuid classuuid:self.classuuid type:[NSString stringWithFormat:@"%d",Topic_PXJG] score:_schoolCell.userscore content:@"" success:^(NSString *mgr)
     {
         [self commentTeachers];
     }
     faild:^(NSString *errorMsg)
     {
         
     }];
}

//老师评价
- (void)commentTeachers
{
    for (MySPCourseTeacherList * domain in self.teacherList)
    {
        [[KGHttpService sharedService] MySPCourseSaveComment:domain.uuid classuuid:self.classuuid type:[NSString stringWithFormat:@"%d",Topic_PXJS] score:domain.score content:@"" success:^(NSString *mgr)
        {
            
        }
        faild:^(NSString *errorMsg)
        {
            [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
        }];
    }
}

#pragma mark - 老师评价cell的代理
- (void)reloadTeacherListData:(NSMutableArray *)teacherListArr
{
    self.teacherList = teacherListArr;
}

#pragma mark - 保存评论文本的代理
- (void)saveCommentText:(NSString *)content
{
    self.tempCommentText = content;
    self.coursecellEdited = YES;
}

#pragma mark - 保存课程分数
- (void)saveCourseScore:(NSString *)score
{
    self.courseScore = score;
    self.coursecellEdited = YES;
}

#pragma mark - 保存学校分数
- (void)saveSchoolScore:(NSString *)score
{
    self.schoolScore = score;
    self.schoolcellEdited = YES;
}



@end
