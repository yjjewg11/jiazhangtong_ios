//
//  MyInfoUpdateController.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "MyInfoUpdateController.h"
#import "KGHttpService.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface MyInfoUpdateController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * dataArray;
@property (strong, nonatomic) NSArray * dataArray_UI;
@property (strong, nonatomic) ParentInfoUpdateDomain *domain;
@end
UITextField * ui_name;
UIImageView * ui_img;
UITextField * ui_name;
UITextField * ui_relname;
UILabel * ui_tel;


@implementation MyInfoUpdateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(handleSavePwd)];
    [rightItem setTintColor:[UIColor whiteColor]];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
      _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView registerNib:[UINib nibWithNibName:@"ModifyPasswordTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModifyPasswordTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 40;
    
    _dataArray = @[@"昵称",@"头像",@"真实姓名",@"手机号码"];
    CGRect frame=CGRectMake(APPWINDOWWIDTH/2, 0, APPWINDOWWIDTH/2-5, 40);
    ui_name=[[UITextField alloc]initWithFrame:frame];
    
    UITextBorderStyle borderStyle=UITextBorderStyleRoundedRect;
   ui_name=[[UITextField alloc]initWithFrame:frame];
    NSTextAlignment alignemnt=NSTextAlignmentRight;
      ui_name.borderStyle=borderStyle;
    ui_name.textAlignment=alignemnt;
   ui_img=[[UIImageView alloc]initWithFrame:CGRectMake(APPWINDOWWIDTH-40, 1, 38, 38)];
   

    ui_relname=[[UITextField alloc]initWithFrame:frame];
;
    ui_relname.borderStyle=borderStyle;
    ui_relname.textAlignment=alignemnt;
   ui_tel=[[UILabel alloc]initWithFrame:frame];
     ui_tel.textAlignment=alignemnt;
    
    _dataArray_UI=@[ui_name,ui_img,ui_relname,ui_tel];
    
    [self.view addSubview:_tableView];
    [self loadData];
}




#pragma mark 加载数据
-(void)initData:(ParentInfoUpdateDomain *) domain{
    self.domain=domain;

    ui_name.text=domain.name;
    ui_relname.text=domain.realname;
    
    NSString * tt=nil;
    Boolean tt1=tt.length>0;
    if(domain.img.length>0){
        
        [ui_img sd_setImageWithURL:[NSURL URLWithString:domain.img ] placeholderImage:[UIImage imageNamed:@"waitImageDown"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {}];
    }else{
        ui_img.image=[UIImage imageNamed:@"waitImageDown"];
    }
    ui_tel.text=domain.tel;
    
  
    [_tableView reloadData];
   
}
-(void)loadData{
    [self showLoadView];
    
    NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/userinfo/getParentBaseInfo.json"];

    [[KGHttpService sharedService] getNSDictionaryByURL:url success:^(NSDictionary *dic) {
          [self hidenLoadView];
        
        
          ParentInfoUpdateDomain * domain = [ParentInfoUpdateDomain objectWithKeyValues: [dic objectForKey:@"data"]];
        [self initData:domain];
    } faild:^(NSString *errorMessage) {
          [self hidenLoadView];
           [MBProgressHUD showError:errorMessage];
    }];
    
    
    
}


#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    if(indexPath.section==0){
        if(indexPath.row==1){
            //选取照片
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"从相册选取", @"拍照",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
            return;
        }
        
    }
   
 
   
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
    ui_img.image=[self compressImage:editedImage];
    
    
    [self uploadImg:^(BOOL isSuccess, NSString *msgStr) {
             if(isSuccess)
        {
            self.domain.img=msgStr;
            
            
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
    [[KGHttpService sharedService] uploadImg:ui_img.image withName:@"file" type:1 success:^(NSString *msgStr) {
        block(YES, msgStr);
    } faild:^(NSString *errorMsg) {
        block(NO, errorMsg);
    }];
}

- (void)handleSavePwd{
    self.domain.name=ui_name.text;
    self.domain.realname=ui_relname.text;
//    self.domain.name=ui_name.text;
//    self.domain.name=ui_name.text;
    
    if (self.domain.name.length<1) {
        [[KGHUD sharedHud] show:self.view onlyMsg:@"请填写昵称"];
        return;
    }
   
    [[KGHUD sharedHud] show:self.view];
    NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/userinfo/update.json"];
    
    [[KGHttpService sharedService] postByDomainBodyJson:url params:self.domain success:^(KGBaseDomain *baseDomain) {
        [self hidenLoadView];
        [MBProgressHUD showSuccess:baseDomain.ResMsg.message];
        
        [self.navigationController popViewControllerAnimated:YES];
    } faild:^(NSString *errorMessage) {
        [self hidenLoadView];
        [MBProgressHUD showError:errorMessage];
    }];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text=_dataArray[indexPath.row];
    
    [cell.contentView addSubview:_dataArray_UI[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
