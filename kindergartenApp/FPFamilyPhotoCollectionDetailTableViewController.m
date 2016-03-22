//
//  FPFamilyPhotoCollectionDetailTableViewController.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/22.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPFamilyPhotoCollectionDetailTableViewController.h"
#import "KGHttpService.h"
#import "UIImageView+WebCache.h"

#import "FPFamilyMembers.h"
#import "MBProgressHUD+HM.h"
@interface FPFamilyPhotoCollectionDetailTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@end
//家庭成员列表
 NSMutableArray * dataSource_members_list;
NSMutableArray *dataSourceGroup;
 UITableView *_tableView;
    NSString *family_uuid;
UIAlertView * customAlertView;
NSInteger selectRowIndex;
FPMyFamilyPhotoCollectionDomain *dataSource;
@implementation FPFamilyPhotoCollectionDetailTableViewController

- (void)loadLoadByUuid:( NSString *) uuid{
    family_uuid=uuid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"我的收藏";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
   dataSourceGroup=[[NSMutableArray alloc]init];
    [dataSourceGroup addObject:@"基本信息"];
    [dataSourceGroup addObject:@"家庭成员"];
 
    
       //初始化数据
    [self initData];
}



#pragma mark 加载数据
-(void)initData{
    [self showLoadView];
    
    [[KGHttpService sharedService] fpFamilyPhotoCollection_get:family_uuid success:^(FPMyFamilyPhotoCollectionDomain *domain) {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self hidenLoadView];
                           dataSource=domain;
                           dataSource_members_list=domain.members_list;
                           
                           //创建一个分组样式的UITableView
                           _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
                           
                           //设置数据源，注意必须实现对应的UITableViewDataSource协议
                           _tableView.dataSource=self;
                           //设置代理
                           _tableView.delegate=self;
                           [self.view addSubview:_tableView];
                           

                          // [_tableView reloadData ];
                           
                       });
    }
    
     
        faild:^(NSString *errorMsg)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self hidenLoadView];
                            [self showNoNetView];
                        });
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    if(section==0){
        return 3;
    }
    
    return dataSource_members_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=nil;
    NSLog(@"%d,%d",indexPath.section,indexPath.row);
    if(indexPath.section==0){
         cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
       
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"相册名称";
                cell.detailTextLabel.text=dataSource.title;                break;
            case 1:
                
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dataSource.herald]];
                
                
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dataSource.herald ] placeholderImage:[UIImage imageNamed:@"waitImageDown"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                 {}];
                   cell.textLabel.text=@"封面图片";
//                cell.detailTextLabel.text=dataSource.herald;
                break;
            case 2:
                cell.textLabel.text=@"创建时间";
                cell.detailTextLabel.text=[[dataSource.create_time componentsSeparatedByString:@" "] firstObject];                break;
                
            default:
                break;
        }
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier_members_list"];
        if(cell==nil){
          cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier_members_list"];
        }

       FPFamilyMembers *member= dataSource_members_list[indexPath.row];
        cell.textLabel.text=member.family_name;
        cell.detailTextLabel.text=member.tel;
        
       
    }

    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.


#pragma mark 返回每组头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return dataSourceGroup[section];
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section!=1)return;
    
    
    //if (customAlertView==nil) {
         customAlertView = [[UIAlertView alloc] initWithTitle:@"修改" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",@"删除", nil];
        
        [customAlertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        
   // }
   
    UITextField *nameField = [customAlertView textFieldAtIndex:0];
    nameField.placeholder = @"家庭称呼";
    
    UITextField *urlField = [customAlertView textFieldAtIndex:1];
    [urlField setSecureTextEntry:NO];

    
    
   
    urlField.placeholder = @"电话号码";
    
    FPFamilyMembers *member= dataSource_members_list[indexPath.row];
    nameField.text=member.family_name;
    urlField.text=member.tel;

    selectRowIndex=indexPath.row;
    [customAlertView show];
}
- (void)fPFamilyMembers_delete{
    
    FPFamilyMembers *member= dataSource_members_list[selectRowIndex];
    
    if(member==nil){
        [MBProgressHUD showError:@"数据不存在"];
        return;
    }
    [[KGHttpService sharedService] fPFamilyMembers_delete:member.uuid success:^(NSString *msgStr) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self hidenLoadView];
                           
                           [dataSource_members_list removeObjectAtIndex:selectRowIndex];
                           
                           [MBProgressHUD showSuccess:msgStr];
                           //刷新表格
                           [_tableView reloadData];
                       });
        
    } faild:^(NSString *errorMsg) {
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           
                      [self hidenLoadView];
                           [self showNoNetView];
                       });
        
    }];

}
#pragma mark 窗口的代理方法，用户保存数据
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //当点击了第二个按钮（OK）
        NSLog(@"%d",buttonIndex);
    if (buttonIndex==2) {
        [self fPFamilyMembers_delete];
              return;
    }
    if (buttonIndex==1) {
        UITextField *textField= [alertView textFieldAtIndex:0];
        
          UITextField *textField1= [alertView textFieldAtIndex:1];
        //修改模型数据
        
          FPFamilyMembers *member= dataSource_members_list[selectRowIndex];
        
        NSString * domain_old_family_name=member.family_name;
        NSString * domain_old_tel=member.tel;
        
   
        member.family_name= textField.text;
        member.tel=textField1.text;

        
        
         [self showLoadView];
        
        [[KGHttpService sharedService] fPFamilyMembers_save:member success:^(NSString *msgStr) {
          

            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self hidenLoadView];
                              [MBProgressHUD showSuccess:@"保存成功!"];
                               //刷新表格
                               [_tableView reloadData];
                           });

        } faild:^(NSString *errorMsg) {
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               
                               member.family_name= domain_old_family_name;
                               member.tel=domain_old_tel;
                               
                               [self hidenLoadView];
                               [self showNoNetView];
                           });

        }
        
        
    ];
        
    }
}
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
    DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
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
