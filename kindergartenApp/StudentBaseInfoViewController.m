//
//  StudentBaseInfoViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/23.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentBaseInfoViewController.h"
#import "KGTextField.h"
#import "Masonry.h"
#import "PopupView.h"
#import "KGNSStringUtil.h"
#import "UIImageView+WebCache.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "KGDateUtil.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"

#define ORIGINAL_MAX_WIDTH 640.0f


@interface StudentBaseInfoViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    IBOutlet UIImageView * headImageView;
    IBOutlet KGTextField * nameTextField;
    IBOutlet KGTextField * nickTextField;
    IBOutlet KGTextField * birthdayTextField;
    IBOutlet UIImageView * boyImageView;
    IBOutlet UIImageView * girlImageView;
    NSString * filePath;
    
    PopupView * popupView;
    UIDatePicker * datePicker;
    BOOL isSetHeadImg; //是否设置过头像
    
    IBOutlet KGTextField *peopleCardTextField;
}

@end

@implementation StudentBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细信息";
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveStudentBaseInfo)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [headImageView.layer setCornerRadius:headImageView.width / Number_Two];
    [headImageView.layer setMasksToBounds:YES];
    
    [self initViewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  添加输入框到array统一管理验证
 */
- (void)addTextFieldToMArray
{
    [nameTextField setTextFielType:KGTextFielType_Empty];
    [nameTextField setMessageStr:@"姓名不能为空"];
    [textFieldMArray addObject:nameTextField];
}


//初始化页面值
- (void)initViewData {
    [headImageView sd_setImageWithURL:[NSURL URLWithString:_studentInfo.headimg] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:headImageView.width / Number_Two];
    }];

    nameTextField.text = _studentInfo.name;
    nickTextField.text = _studentInfo.nickname;
    birthdayTextField.text = _studentInfo.birthday;
    peopleCardTextField.text = _studentInfo.idcard;
    
    [self resetStudentSet];
}

//设置性别图
- (void)resetStudentSet {
    if(!_studentInfo.sex) {
        boyImageView.image = [UIImage imageNamed:@"menan2"];
        girlImageView.image = [UIImage imageNamed:@"menv1"];
    } else {
        boyImageView.image = [UIImage imageNamed:@"menan1"];
        girlImageView.image = [UIImage imageNamed:@"menv2"];
    }
}


//保存按钮点击
- (void)saveStudentBaseInfo {
    if([self validateInputInView]) {
        _studentInfo.name = [KGNSStringUtil trimString:nameTextField.text];
        _studentInfo.nickname = [KGNSStringUtil trimString:nickTextField.text];
        _studentInfo.birthday = [KGNSStringUtil trimString:birthdayTextField.text];
        _studentInfo.idcard = [KGNSStringUtil trimString:peopleCardTextField.text];
        
        //提交数据
        if(isSetHeadImg) {
            [[KGHUD sharedHud] show:self.contentView msg:@"上传头像中..."];
            
            [self uploadImg:^(BOOL isSuccess, NSString *msgStr) {
                
                _studentInfo.headimg = msgStr;
                [[KGHUD sharedHud] changeText:self.contentView text:@"上传成功"];
                
                if(isSuccess) {
                    [self saveStudentInfo];
                    
                } else {
                    [[KGHUD sharedHud] hide:self.contentView];
                }
            }];
        } else {
            [self saveStudentInfo];
        }
        
    }
}


//上传头像
- (void)uploadImg:(void(^)(BOOL isSuccess, NSString * msgStr))block {
    
    [[KGHttpService sharedService] uploadImg:headImageView.image withName:@"file" type:1 success:^(NSString *msgStr) {
        block(YES, msgStr);
    } faild:^(NSString *errorMsg) {
        block(NO, errorMsg);
    }];
}

//提交基本信息
- (void)saveStudentInfo {
    [[KGHUD sharedHud] changeText:self.contentView text:@"提交信息中..."];
    [[KGHttpService sharedService] saveStudentInfo:_studentInfo success:^(NSString *msgStr) {
        
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        
        if(_StudentUpdateBlock) {
            _StudentUpdateBlock(_studentInfo);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } faild:^(NSString *errorMsg) {
         [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}



- (IBAction)changeHeadImgBtnClicked:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册选取", @"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.contentView];
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

#pragma mark - 是否授权相机
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
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
            // TO DO
        }];
    }];
    
//    NSString * type = [info objectForKey:UIImagePickerControllerMediaType];
//    
//    //当选择的类型是图片
//    if ([type isEqualToString:@"public.image"])
//    {
//        //先把图片转成NSData
//        UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        NSData * data = UIImageJPEGRepresentation(image, 0.1);
//        
//        //图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
//        
//        //得到选择后沙盒中图片的完整路径
//        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
//        
//        //关闭相册界面
//        [picker dismissViewControllerAnimated:YES completion:nil];
//        
//        headImageView.image = image;
//        
//        isSetHeadImg = YES;
//    } 
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    UIImage * image = [self compressImage:editedImage];
    headImageView.image = image;
    isSetHeadImg = YES;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)sexBtnClicked:(UIButton *)sender {
    _studentInfo.sex = sender.tag-Number_Ten;
    [self resetStudentSet];
}


- (IBAction)birthdayBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
     
    if(!popupView) {
        popupView = [[PopupView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, KGSCREEN.size.width, KGSCREEN.size.height)];
        popupView.alpha = Number_Zero;
        
        CGFloat height = 216;
        datePicker = [[UIDatePicker alloc] init];
        datePicker.frame = CGRectMake(Number_Zero, KGSCREEN.size.height-height, KGSCREEN.size.width, height);
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        if(_studentInfo.birthday) {
            [datePicker setDate:[KGDateUtil getDateByDateStr:_studentInfo.birthday format:dateFormatStr1] animated:YES];
        }
        
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        [popupView addSubview:datePicker];
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:popupView];
    }
    
    [UIView viewAnimate:^{
        popupView.alpha = Number_One;
    } time:Number_AnimationTime_Five];
}


-(void)dateChanged:(id)sender{
    UIDatePicker * control = (UIDatePicker*)sender;
    NSString * timeStr = [NSString stringWithFormat:@"%@", control.date];
    NSArray * timeArray = [timeStr componentsSeparatedByString:@" "];
    if([timeArray count] > Number_Zero) {
        birthdayTextField.text = [timeArray objectAtIndex:Number_Zero];
    }
}


- (void)showDatePicker:(BOOL)isShow {
    [UIView animateWithDuration:Number_AnimationTime_Five animations:^{
        datePicker.alpha = isShow ? Number_One : Number_Zero;
    } completion:^(BOOL finished) {
        
    }];
}


@end
