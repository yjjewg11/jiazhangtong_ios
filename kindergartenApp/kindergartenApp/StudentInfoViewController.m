//
//  StudentInfoViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/22.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentInfoViewController.h"
#import "StudentInfoItemVO.h"
#import "Masonry.h"
#import "MeTableViewCell.h"
#import "StudentInfoHeaderView.h"
#import "UIColor+Extension.h"
#import "StudentBaseInfoViewController.h"
#import "StudentOtherInfoViewController.h"
#import "StudentNoteInfoViewController.h"

#define StudentInfoCellIdentifier @"StudentInfoCellIdentifier"
#define StudentOtherInfoCellIdentifier @"StudentOtherInfoCellIdentifier"

@interface StudentInfoViewController () <UITableViewDataSource, UITableViewDelegate>  {
    NSMutableArray * tableDataSource;
    IBOutlet UITableView * studentInfoTableView;
}

@end

@implementation StudentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细信息";
    studentInfoTableView.backgroundColor = KGColorFrom16(0xE7E7EE);
    studentInfoTableView.delegate   = self;
    studentInfoTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setStudentInfo:(KGUser *)studentInfo {
    _studentInfo = studentInfo;
    [self packageTableDataSource];
}


///封装table需要的数据
- (void)packageTableDataSource {
    tableDataSource = [[NSMutableArray alloc] init];
    
    StudentInfoItemVO * item1 = [[StudentInfoItemVO alloc] init];
    item1.head = @"";
    item1.contentMArray = [[NSMutableArray alloc] initWithObjects:
                          [NSString stringWithFormat:@""],nil];
    [tableDataSource addObject:item1];
    
    StudentInfoItemVO * item2 = [[StudentInfoItemVO alloc] init];
    item2.head = @"爸爸";
    item2.contentMArray = [[NSMutableArray alloc] initWithObjects:
                          [NSString stringWithFormat:@"姓名:%@", _studentInfo.ba_name],
                          [NSString stringWithFormat:@"电话:%@", _studentInfo.ba_tel],
                          [NSString stringWithFormat:@"工作单位:%@", _studentInfo.ba_work], nil];
    [tableDataSource addObject:item2];
    
    StudentInfoItemVO * item3 = [[StudentInfoItemVO alloc] init];
    item3.head = @"妈妈";
    item3.contentMArray = [[NSMutableArray alloc] initWithObjects:
                           [NSString stringWithFormat:@"姓名:%@", _studentInfo.ma_name],
                           [NSString stringWithFormat:@"电话:%@", _studentInfo.ma_tel],
                           [NSString stringWithFormat:@"工作单位:%@", _studentInfo.ma_work], nil];
    [tableDataSource addObject:item3];
    
    StudentInfoItemVO * item4 = [[StudentInfoItemVO alloc] init];
    item4.head = @"爷爷";
    item4.contentMArray = [[NSMutableArray alloc] initWithObjects:
                           [NSString stringWithFormat:@"姓名:爷爷"],
                           [NSString stringWithFormat:@"电话:%@", _studentInfo.ye_tel], nil];
    [tableDataSource addObject:item4];
    
    StudentInfoItemVO * item5 = [[StudentInfoItemVO alloc] init];
    item5.head = @"奶奶";
    item5.contentMArray = [[NSMutableArray alloc] initWithObjects:
                           [NSString stringWithFormat:@"姓名:奶奶"],
                           [NSString stringWithFormat:@"电话:%@", _studentInfo.nai_tel], nil];
    [tableDataSource addObject:item5];
    
    StudentInfoItemVO * item6 = [[StudentInfoItemVO alloc] init];
    item6.head = @"外公";
    item6.contentMArray = [[NSMutableArray alloc] initWithObjects:
                           [NSString stringWithFormat:@"姓名:外公"],
                           [NSString stringWithFormat:@"电话:%@", _studentInfo.waigong_tel], nil];
    [tableDataSource addObject:item6];
    
    StudentInfoItemVO * item7 = [[StudentInfoItemVO alloc] init];
    item7.head = @"外婆";
    item7.contentMArray = [[NSMutableArray alloc] initWithObjects:
                           [NSString stringWithFormat:@"姓名:外婆"],
                           [NSString stringWithFormat:@"电话:%@", _studentInfo.waipo_tel], nil];
    [tableDataSource addObject:item7];
    
    StudentInfoItemVO * item8 = [[StudentInfoItemVO alloc] init];
    item8.head = @"";
    item8.contentMArray = [[NSMutableArray alloc] initWithObjects:
                           [NSString stringWithFormat:@"关联学校:%@", _studentInfo.ma_name],
                           [NSString stringWithFormat:@"关联班级:%@", _studentInfo.ma_tel], nil];
    [tableDataSource addObject:item8];
    
    StudentInfoItemVO * item9 = [[StudentInfoItemVO alloc] init];
    item9.head = @"备注";
    item9.contentMArray = [[NSMutableArray alloc] initWithObjects:_studentInfo.note ? _studentInfo.note : @"暂无" ,nil];
    [tableDataSource addObject:item9];
}



#pragma UITableView delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableDataSource count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    StudentInfoItemVO * itemVO = [tableDataSource objectAtIndex:section];
    return [itemVO.contentMArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section!=Number_Zero && section!=Number_Seven) {
        return Cell_Height2;
    }
    return Number_Zero;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section!=Number_Zero && section!=Number_Seven) {
        StudentInfoItemVO * itemVO = [tableDataSource objectAtIndex:section];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
        StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
        view.titleLabel.text = itemVO.head;
        view.backgroundColor = KGColorFrom16(0xE7E7EE);
        view.funBtn.tag = section;
        [view.funBtn addTarget:self action:@selector(sectionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == Number_Zero) {
        //学生基本信息
        return [self loadStudentInfoCell:tableView cellForRowAtIndexPath:indexPath];
    } else {
        return [self loadFunCell:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (UITableViewCell *)loadStudentInfoCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:StudentInfoCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:Number_Zero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell resetCellParam:_studentInfo];
    return cell;
}


- (UITableViewCell *)loadFunCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:StudentOtherInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StudentOtherInfoCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    StudentInfoItemVO * itemVO = [tableDataSource objectAtIndex:indexPath.section];
    cell.textLabel.text = [itemVO.contentMArray objectAtIndex:indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == Number_Zero) {
        return 60;
    }else{
        if(indexPath.section == Number_Eight) {
            return 70;
        } else {
            return 35;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == Number_Zero) {
        //编辑学生基本资料
        StudentBaseInfoViewController * baseInfoVC = [[StudentBaseInfoViewController alloc] init];
        baseInfoVC.studentInfo = _studentInfo;
        
        baseInfoVC.StudentUpdateBlock = ^(KGUser * studentObj){
            self.studentInfo = studentObj;
            [studentInfoTableView reloadData];
        };
        
        [self.navigationController pushViewController:baseInfoVC animated:YES];
    }
}


//section点击
- (void)sectionBtnClicked:(UIButton *)sender {
    if(sender.tag < Number_Seven) {
        StudentOtherInfoViewController * otherInfoVC = [[StudentOtherInfoViewController alloc] init];
        otherInfoVC.index = sender.tag;
        otherInfoVC.dataSource = tableDataSource;
        otherInfoVC.studentInfo = _studentInfo;
        otherInfoVC.StudentUpdateBlock = ^(KGUser * studentObj){
            self.studentInfo = studentObj;
            [studentInfoTableView reloadData];
        };
        
        [self.navigationController pushViewController:otherInfoVC animated:YES];
    }
    
    if(sender.tag == Number_Eight) {
        StudentNoteInfoViewController * noteInfoVC = [[StudentNoteInfoViewController alloc] init];
        noteInfoVC.studentInfo = _studentInfo;
        
        noteInfoVC.StudentUpdateBlock = ^(KGUser * studentObj){
            self.studentInfo = studentObj;
            [studentInfoTableView reloadData];
        };
        
        [self.navigationController pushViewController:noteInfoVC animated:YES];
    }
}




@end
