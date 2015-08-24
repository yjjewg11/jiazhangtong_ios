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
        [self localPhoto];
    } else {
        //拍照
        [self openCamera];
    }
}


//打开本地相册
- (void)localPhoto {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = true;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}


//开始拍照
- (void)openCamera {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        //设置选择后的图片可被编辑
        picker.allowsEditing = true;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    } else {
        //没有相机
        
    }
}


//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString * type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData * data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        headImageView.image = image;
        
        isSetHeadImg = YES;
    } 
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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
