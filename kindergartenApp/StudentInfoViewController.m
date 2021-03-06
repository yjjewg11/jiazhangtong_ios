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
#import "StudentMomOrDodInfoViewController.h"
#import "StudentNoteInfoViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "CardInfoDomain.h"
#import "StudentOtherInfoViewController.h"
#import "EnrolStudentMySchoolVC.h"
#import "MBProgressHUD+HM.h"
#import "SDRotationLoopProgressView.h"

#define StudentInfoCellIdentifier @"StudentInfoCellIdentifier"
#define StudentOtherInfoCellIdentifier @"StudentOtherInfoCellIdentifier"

@interface StudentInfoViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray * tableDataSource;
    IBOutlet UITableView * studentInfoTableView;
    NSArray * buildCardArray;
    
    SDRotationLoopProgressView * _loadingView;
}

@end

@implementation StudentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细信息";
    
    studentInfoTableView.backgroundColor = KGColorFrom16(0xE7E7EE);
    studentInfoTableView.delegate   = self;
    studentInfoTableView.dataSource = self;
    
    tableDataSource = [[NSMutableArray alloc] init];
    
    [self showLoadView];
    [self getBuildCardInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//获取绑定的卡号列表
- (void)getBuildCardInfo
{
    [[KGHttpService sharedService] getBuildCardList:_studentInfo.uuid success:^(NSArray *cardArray)
    {
        buildCardArray = cardArray;
        [self packageTableDataSource];
        [self hidenLoadView];
    }
    faild:^(NSString *errorMsg)
    {
        [self packageTableDataSource];
        [[KGHUD sharedHud] hide:self.view];
    }];
}


///封装table需要的数据
- (void)packageTableDataSource {
    if(tableDataSource) {
        [tableDataSource removeAllObjects];
    }
    
    StudentInfoItemVO * item1 = [[StudentInfoItemVO alloc] init];
    item1.headHeight = Number_Zero;
    item1.cellHeight = 60;
    item1.contentMArray = [[NSMutableArray alloc] initWithObjects:
                          [NSString stringWithFormat:@""],nil];
    [tableDataSource addObject:item1];
    
    StudentInfoItemVO * item2 = [[StudentInfoItemVO alloc] init];
    item2.headHeight = Number_Zero;
    item2.isArrow = NO;
    NSString * groupName = [[KGHttpService sharedService] getGroupNameByUUID:_studentInfo.groupuuid];
    NSString * className = [[KGHttpService sharedService] getClassNameByUUID:_studentInfo.classuuid];
    
    item2.contentMArray = [[NSMutableArray alloc] initWithObjects:
                           [NSString stringWithFormat:@"关联学校:%@", groupName ? groupName : @""],
                           [NSString stringWithFormat:@"关联班级:%@", className ? className : @""], nil];
    [tableDataSource addObject:item2];
    
    StudentInfoItemVO * item3 = [[StudentInfoItemVO alloc] init];
    item3.head = @"爸爸";
    item3.contentMArray = [[NSMutableArray alloc] initWithObjects:
                          [NSString stringWithFormat:@"姓名:%@", _studentInfo.ba_name==nil?@"":_studentInfo.ba_name],
                          [NSString stringWithFormat:@"电话:%@", _studentInfo.ba_tel==nil?@"":_studentInfo.ba_tel],
                          [NSString stringWithFormat:@"工作单位:%@", _studentInfo.ba_work==nil?@"":_studentInfo.ba_work], nil];
    [tableDataSource addObject:item3];
    
    StudentInfoItemVO * item4 = [[StudentInfoItemVO alloc] init];
    item4.head = @"妈妈";
    item4.contentMArray = [[NSMutableArray alloc] initWithObjects:
                           [NSString stringWithFormat:@"姓名:%@", _studentInfo.ma_name==nil?@"":_studentInfo.ma_name],
                           [NSString stringWithFormat:@"电话:%@", _studentInfo.ma_tel==nil?@"":_studentInfo.ma_tel],
                           [NSString stringWithFormat:@"工作单位:%@", _studentInfo.ma_work==nil?@"":_studentInfo.ma_work], nil];
    [tableDataSource addObject:item4];
    
    StudentInfoItemVO * item5 = [[StudentInfoItemVO alloc] init];
    item5.head = @"其他联系人";
    item5.contentMArray = [[NSMutableArray alloc] initWithObjects:
                           [NSString stringWithFormat:@"爷爷:%@", _studentInfo.ye_tel==nil?@"":_studentInfo.ye_tel],
                           [NSString stringWithFormat:@"奶奶:%@", _studentInfo.nai_tel==nil?@"":_studentInfo.nai_tel],
                           [NSString stringWithFormat:@"外公:%@", _studentInfo.waigong_tel==nil?@"":_studentInfo.waigong_tel],
                           [NSString stringWithFormat:@"外婆:%@", _studentInfo.waipo_tel==nil?@"":_studentInfo.waipo_tel], nil];
    [tableDataSource addObject:item5];
    
    if(buildCardArray && [buildCardArray count]>Number_Zero) {
        StudentInfoItemVO * item6 = [[StudentInfoItemVO alloc] init];
        item6.head = @"卡号绑定";
        item6.isArrow = NO;
        NSMutableArray * cardArray = [[NSMutableArray alloc] initWithCapacity:[buildCardArray count]];
        
        for(CardInfoDomain * domain in buildCardArray) {
            [cardArray addObject:[NSString stringWithFormat:@"%@:%@", domain.name, domain.cardid]];
        }
        
        item6.contentMArray = cardArray;
        [tableDataSource addObject:item6];
    }
    
    StudentInfoItemVO * item7 = [[StudentInfoItemVO alloc] init];
    item7.head = @"备注";
    item7.isNote = YES;
    item7.isArrow = NO;
    
    NSString * noteStr = (_studentInfo.note&&![_studentInfo.note isEqualToString:String_DefValue_Empty]) ? _studentInfo.note : @"暂无";
    
    item7.contentMArray = [[NSMutableArray alloc] initWithObjects:noteStr ,nil];
    
    CGSize size =  [self sizeWithString:noteStr font:[UIFont systemFontOfSize:15]];
    item7.cellHeight = size.height;
    item7.cellHeight = 70;
    [tableDataSource addObject:item7];
    
    [studentInfoTableView reloadData];
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
    StudentInfoItemVO * itemVO = [tableDataSource objectAtIndex:section];
    return itemVO.headHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StudentInfoItemVO * itemVO = [tableDataSource objectAtIndex:section];
    if(itemVO.head) {
        StudentInfoItemVO * itemVO = [tableDataSource objectAtIndex:section];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoHeaderView" owner:nil options:nil];
        StudentInfoHeaderView * view = (StudentInfoHeaderView *)[nib objectAtIndex:Number_Zero];
        view.titleLabel.text = itemVO.head;
        view.backgroundColor = KGColorFrom16(0xE7E7EE);
        view.funBtn.tag = section;
        
        if(itemVO.isNote) {
            //备注 增加编辑按钮
            UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bianjiicon"]];
            imgView.frame = CGRectMake(KGSCREEN.size.width - 31, 10, 15, 15);
            [view addSubview:imgView];
            [view.funBtn addTarget:self action:@selector(editStudentNote) forControlEvents:UIControlEventTouchUpInside];
        }
        
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
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell resetCellParam:_studentInfo];
    return cell;
}


- (UITableViewCell *)loadFunCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:StudentOtherInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StudentOtherInfoCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    StudentInfoItemVO * itemVO = [tableDataSource objectAtIndex:indexPath.section];
    cell.textLabel.text = [itemVO.contentMArray objectAtIndex:indexPath.row];
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        itemVO.isArrow = YES;
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        itemVO.isArrow = NO;
    }
    
    if(itemVO.isArrow) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if(indexPath.section == [tableDataSource count]-Number_One) {
        cell.textLabel.numberOfLines = Number_Zero;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentInfoItemVO * itemVO = [tableDataSource objectAtIndex:indexPath.section];
    return itemVO.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == Number_Zero) {
        [self editStudentBaseInfo];
    }
    
    if(indexPath.section>Number_One && indexPath.section<[tableDataSource count]-Number_One) {
        StudentInfoItemVO * itemVO = [tableDataSource objectAtIndex:indexPath.section];
        if([itemVO.head isEqualToString:@"爸爸"] || [itemVO.head isEqualToString:@"妈妈"]) {
            [self editStudentMomOrDodInfo:indexPath.section];
        } else {
            [self editStudentOtherInfo:indexPath.section];
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        EnrolStudentMySchoolVC * vc = [[EnrolStudentMySchoolVC alloc] init];
        
        if (self.studentInfo.groupuuid == nil || [self.studentInfo.groupuuid isEqualToString:@"0"] || [self.studentInfo.groupuuid isEqualToString:@""])
        {
            [MBProgressHUD showError:@"宝贝暂时没有关联学校啦"];
        }
        else
        {
            vc.uuid = self.studentInfo.groupuuid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//编辑学生基本信息
- (void)editStudentBaseInfo {
    //编辑学生基本资料
    StudentBaseInfoViewController * baseInfoVC = [[StudentBaseInfoViewController alloc] init];
    baseInfoVC.studentInfo = _studentInfo;
    
    baseInfoVC.StudentUpdateBlock = ^(KGUser * studentObj)
    {
        self.studentInfo = studentObj;
        
        NSMutableArray * tempArray = [[NSMutableArray alloc] initWithArray:[KGHttpService sharedService].loginRespDomain.list];
        for (int i = 0; i < tempArray.count; ++ i) {
            KGUser * model = tempArray[i];
            if ([model.uuid isEqualToString:studentObj.uuid]) {
                [tempArray replaceObjectAtIndex:i withObject:studentObj];
                [KGHttpService sharedService].loginRespDomain.list = [NSMutableArray arrayWithArray:tempArray];
                break;
            }
        }
        [self packageTableDataSource];
        [studentInfoTableView reloadData];
    };
    
    [self.navigationController pushViewController:baseInfoVC animated:YES];
}

//编辑爸爸 || 妈妈信息
- (void)editStudentMomOrDodInfo:(NSInteger)index {
    StudentMomOrDodInfoViewController * otherInfoVC = [[StudentMomOrDodInfoViewController alloc] init];
    otherInfoVC.itemVO = [tableDataSource objectAtIndex:index];
    otherInfoVC.studentInfo = _studentInfo;
    otherInfoVC.StudentUpdateBlock = ^(KGUser * studentObj){
        self.studentInfo = studentObj;
        [self packageTableDataSource];
        [studentInfoTableView reloadData];
    };
    
    [self.navigationController pushViewController:otherInfoVC animated:YES];
}

//编辑其他信息
- (void)editStudentOtherInfo:(NSInteger)index {
    StudentOtherInfoViewController * otherInfoVC = [[StudentOtherInfoViewController alloc] init];
    otherInfoVC.itemVO = [tableDataSource objectAtIndex:index];
    otherInfoVC.studentInfo = _studentInfo;
    otherInfoVC.StudentUpdateBlock = ^(KGUser * studentObj){
        self.studentInfo = studentObj;
        [self packageTableDataSource];
        [studentInfoTableView reloadData];
    };
    
    [self.navigationController pushViewController:otherInfoVC animated:YES];
}


//编辑 备注
- (void)editStudentNote {
    StudentNoteInfoViewController * noteInfoVC = [[StudentNoteInfoViewController alloc] init];
    noteInfoVC.studentInfo = _studentInfo;
    
    noteInfoVC.StudentUpdateBlock = ^(KGUser * studentObj){
        self.studentInfo = studentObj;
        [self packageTableDataSource];
        [studentInfoTableView reloadData];
    };
    
    [self.navigationController pushViewController:noteInfoVC animated:YES];
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

@end
