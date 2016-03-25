//
//  AddFamilyMemberVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/23.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "AddFamilyMemberVC.h"



@interface AddFamilyMemberVC ()<UITableViewDelegate,UITableViewDataSource>


@end
//家庭成员列表
NSMutableArray * dataSourceGroup_child_telAndName;
NSMutableArray * dataSourceGroup;
UITableView *_tableView;
@implementation AddFamilyMemberVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加家人";
    
    
    dataSourceGroup=[[NSMutableArray alloc]init];
    [dataSourceGroup addObject:@"从手机通讯录添加"];
    [dataSourceGroup addObject:@"添加信息"];
    [dataSourceGroup addObject:@"添加"];
    
    dataSourceGroup_child_telAndName=[[NSMutableArray alloc]init];
    
    [dataSourceGroup_child_telAndName addObject:@"家庭昵称"];
    [dataSourceGroup_child_telAndName addObject:@"电话号码"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if(section==0)return 1;
    if(section==1)return dataSourceGroup_child_telAndName.count;
    return 1;
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section==0){
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text=@"从手机通讯录添加";
        
        return cell;
    }
    
    
    if(indexPath.section==2){
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text=@"添加";
        
        return cell;
        
    }
    
    if(indexPath.section==1){
        
        
        //
        //        AddFamilyMemberCell *cell =[[AddFamilyMemberCell alloc]initWithStyle:nil reuseIdentifier:nil];
        //
        //        if (indexPath.row==0) {
        //          //  cell.getLable1.text=@"家庭昵称";
        //
        //        }else {
        //           //  cell.getLable1.text=@"手机号码";
        //        }
        
        return nil;
        
    }
    
    // Configure the cell...
    
    return nil;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end