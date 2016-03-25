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
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "HZQDatePickerView.h"
#import "KGHUD.h"
#import "EditFamilyMemberVC.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface FPFamilyPhotoCollectionDetailTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate,EditFamilyMemberVCDelegate>
{
    //家庭成员列表
    NSMutableArray * dataSource_members_list;
    NSMutableArray * dataSource_family_list;
    NSMutableArray *dataSourceGroup;
    UITableView *_tableView;
    NSString *family_uuid;
    UIAlertView * customAlertView;
    NSInteger selectRowIndex;
    FPMyFamilyPhotoCollectionDomain *dataSource;
    UIImageView * heraldImageView;
}
@end

@implementation FPFamilyPhotoCollectionDetailTableViewController

- (void)loadLoadByUuid:( NSString *) uuid{
    family_uuid=uuid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"家庭相册信息";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
   dataSourceGroup=[[NSMutableArray alloc]init];
    [dataSourceGroup addObject:@"基本信息"];
    [dataSourceGroup addObject:@"家庭成员"];
 
    
    dataSource_family_list=[[NSMutableArray alloc]init];

    [dataSource_family_list addObject:@"相册名称"];
    [dataSource_family_list addObject:@"封面图片"];
    [dataSource_family_list addObject:@"创建时间"];
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
                           NSLog(@"1.%@=%@",domain.title,dataSource.title);
                           dataSource=domain;
                           dataSource_members_list=domain.members_list;
                            NSLog(@"2.%@=%@",domain.title,dataSource.title);
                           if(_tableView==nil){
                               //创建一个分组样式的UITableView
                               _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
                               //                           _tableView.allowsSelection=NO;
                               //设置数据源，注意必须实现对应的UITableViewDataSource协议
                               _tableView.dataSource=self;
                               //设置代理
                               _tableView.delegate=self;
                               
                               
                               
                               UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, 60)];
                               footView.backgroundColor = [UIColor clearColor];
                               
                               UIButton *sureButton  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, 60)];
                               sureButton.backgroundColor = [UIColor clearColor];
                               //  sureButton.layer.cornerRadius = 2.0f;
                               sureButton.layer.masksToBounds = YES;
                               [sureButton setTitle:@"邀请更多亲戚加入" forState:UIControlStateNormal];
                               [sureButton addTarget:self action:@selector(tableFooterViewButtonPressed) forControlEvents:UIControlEventTouchUpInside];
                               sureButton.titleLabel.textColor = [UIColor grayColor];
                               sureButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                               [footView addSubview:sureButton];
                               _tableView.tableFooterView = footView;
                                   [self.view addSubview:_tableView];
                           }else{
                               [_tableView reloadData ];
                           }
                          
                       
                           
                           
                       });
    }
    
     
        faild:^(NSString *errorMsg)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self hidenLoadView];
                             [MBProgressHUD showError:errorMsg];
                        });
     }];

}

- (void)updateFPFamilyMembers:(FPFamilyMembers *)fPFamilyMembers{
    if(fPFamilyMembers.uuid==nil ||[fPFamilyMembers.uuid isEqualToString:@""]){
       //新建 重新获取数据
        [self initData];
    }else{
         [_tableView reloadData];
    }
    
}

- (void)tableFooterViewButtonPressed {
    NSLog(@"tableFooterViewButtonPressed");
//
    
    EditFamilyMemberVC *editFamilyMemberVC=[[EditFamilyMemberVC alloc]init] ;
    editFamilyMemberVC.editFamilyMemberVCDelegate=self;
    editFamilyMemberVC.fPFamilyMembers=[[FPFamilyMembers alloc]init];
    editFamilyMemberVC.fPFamilyMembers.family_uuid=dataSource.uuid;
    [self.navigationController pushViewController:editFamilyMemberVC animated:YES];
    return;
   
//
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
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
   // NSLog(@"%d,%d",indexPath.section,indexPath.row);
    if(indexPath.section==0){
         cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
       
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=dataSource_family_list[indexPath.row];
                cell.detailTextLabel.text=dataSource.title;
                    NSLog(@"3.=%@",dataSource.title);
                
                  cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                heraldImageView=cell.imageView;
                  cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dataSource.herald ] placeholderImage:[UIImage imageNamed:@"waitImageDown"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                 {}];
                
                
                   cell.textLabel.text=dataSource_family_list[indexPath.row];
//                cell.detailTextLabel.text=dataSource.herald;
                break;
            case 2:
                cell.textLabel.text=dataSource_family_list[indexPath.row];
                cell.detailTextLabel.text=[[dataSource.create_time componentsSeparatedByString:@" "] firstObject];                break;
                
            default:
                break;
        }
        
    }else{
        //家庭成员
        cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier_members_list"];
        if(cell==nil){
          cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier_members_list"];
        }

       FPFamilyMembers *member= dataSource_members_list[indexPath.row];
        cell.textLabel.text=member.family_name;
        cell.detailTextLabel.text=member.tel;
        
          cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
       
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
    
    
    
    
    if(indexPath.section==0){
        if(indexPath.row==2)return;
        if(indexPath.row==1){
            //选取照片
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"从相册选取", @"拍照",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.contentView];
            return;
        }
        
        UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:dataSource_family_list[indexPath.row] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
       
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *nameField = [alertView textFieldAtIndex:0];
        
        
         alertView.tag=indexPath.section;
        
        nameField.placeholder = dataSource_family_list[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                
                nameField.text=dataSource.title;
                break;
           
                
            default:
                break;
        }
         selectRowIndex=indexPath.row;
        [alertView show];
        return;
    };
    
    
    //修改成功列
    
    
    EditFamilyMemberVC *editFamilyMemberVC=[[EditFamilyMemberVC alloc]init] ;
    editFamilyMemberVC.editFamilyMemberVCDelegate=self;
    
    
    
    editFamilyMemberVC.fPFamilyMembers=dataSource_members_list[indexPath.row];
    [self.navigationController pushViewController:editFamilyMemberVC animated:YES];
    
    return;
//    if (customAlertView==nil) {
//         customAlertView = [[UIAlertView alloc] initWithTitle:@"修改" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",@"删除", nil];
//        
//        [customAlertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
//        customAlertView.tag=indexPath.section;
//    }
//   
//    UITextField *nameField = [customAlertView textFieldAtIndex:0];
//    nameField.placeholder = @"家庭称呼";
//    
//    UITextField *urlField = [customAlertView textFieldAtIndex:1];
//    [urlField setSecureTextEntry:NO];
//
//    
//    
//   
//    urlField.placeholder = @"电话号码";
//    
//    FPFamilyMembers *member= dataSource_members_list[indexPath.row];
//    nameField.text=member.family_name;
//    urlField.text=member.tel;
//
//    selectRowIndex=indexPath.row;
//    [customAlertView show];
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
                            [MBProgressHUD showError:errorMsg];
                       });
        
    }];

}


#pragma actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == Number_Zero) {
        //从相册
        if ([self isPhotoLibraryAvailable]) {
            [self localPhoto];
        }
    } else if (buttonIndex == Number_One) {
        //拍照
        [self openCamera];
    }
}


#pragma mark - 是否允许打开相册
- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

//打开本地相册
- (void)localPhoto {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    picker.mediaTypes = mediaTypes;
    
    picker.delegate = self;
    //设置选择后的图片可被编辑
    //    picker.allowsEditing = true;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}


//开始拍照
- (void)openCamera {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        //设置选择后的图片可被编辑
        //        picker.allowsEditing = true;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    } else {
        //没有相机
        
    }
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}


- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
        }];
    }];
}


#pragma mark - 缩放图片到指定尺寸
- (UIImage *)compressImage:(UIImage *)imgSrc
{
    CGSize size = {99, 99};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
//    
//    UIImage * image = [self compressImage:editedImage];
//    
//    
    heraldImageView.image=[self compressImage:editedImage];
    
    
    [self uploadImg:^(BOOL isSuccess, NSString *msgStr) {
        

        
        if(isSuccess)
        {
            dataSource.herald= msgStr;
           
            
            
            FPMyFamilyPhotoCollectionDomain * saveDomain=[[FPMyFamilyPhotoCollectionDomain alloc]init];
            saveDomain.uuid=dataSource.uuid;
            saveDomain.title=dataSource.title;
            saveDomain.herald=dataSource.herald;
            
            [self fpFamilyPhotoCollection_save:saveDomain block:^(BOOL isSuccess, NSString *msgStr) {
                if(isSuccess){
                   
                    
                    //刷新表格
                    [_tableView reloadData];
                }
                
            }];

            
            
            
        }
        else
        {
            [[KGHUD sharedHud] hide:self.contentView];
        }
    }];
    
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

//上传头像
- (void)uploadImg:(void(^)(BOOL isSuccess, NSString * msgStr))block
{
    [[KGHttpService sharedService] uploadImg:heraldImageView.image withName:@"file" type:1 success:^(NSString *msgStr) {
        block(YES, msgStr);
    } faild:^(NSString *errorMsg) {
        block(NO, errorMsg);
    }];
}

- (void)fpFamilyPhotoCollection_save:(FPMyFamilyPhotoCollectionDomain *) saveDomain block:(void(^)(BOOL isSuccess, NSString * msgStr))block{
    
    
    [self showLoadView];
    
    [[KGHttpService sharedService] fpFamilyPhotoCollection_save:saveDomain success:^(NSString *msgStr) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self hidenLoadView];
                           [MBProgressHUD showSuccess:@"保存成功!"];
                           block(true,msgStr);
                       });
        
    } faild:^(NSString *errorMsg) {
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           
                           
                           [self hidenLoadView];
                           [MBProgressHUD showError:errorMsg];
                           block(false,errorMsg);

                       });
        
    }
     
     
     ];

}
#pragma mark 窗口的代理方法，用户保存数据
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    //当点击了第二个按钮（OK）
    NSLog(@"%d",buttonIndex);
    //基本信息修改
    if(alertView.tag ==0 )
    {
        
        if (buttonIndex!=1) return;
        UITextField *textField= [alertView textFieldAtIndex:0];
        
       
        
        FPMyFamilyPhotoCollectionDomain * saveDomain=[[FPMyFamilyPhotoCollectionDomain alloc]init];
        saveDomain.uuid=dataSource.uuid;
        saveDomain.title=dataSource.title;
        saveDomain.herald=dataSource.herald;
        
        switch (selectRowIndex) {
            case 0:
                
                saveDomain.title=textField.text;
                break;
            case 1:
                saveDomain.herald=textField.text;
                break;
                
            default:
                break;
        }

        [self fpFamilyPhotoCollection_save:saveDomain block:^(BOOL isSuccess, NSString *msgStr) {
            if(isSuccess){
                dataSource.title=saveDomain.title;
                dataSource.herald=saveDomain.herald;
                
                //刷新表格
                [_tableView reloadData];
            }
           
        }];
        
        return;
    }//end tag=0
   
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
                                [MBProgressHUD showError:errorMsg];
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
