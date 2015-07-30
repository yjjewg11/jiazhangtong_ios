//
//  PostTopicViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/25.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "PostTopicViewController.h"
#import "UIButton+Extension.h"
#import "KGNSStringUtil.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "ReplyDomain.h"

#define contentTextViewDefText   @"说点什么吧..."

@interface PostTopicViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextViewDelegate> {
    
    IBOutlet UITextView *contentTextView;
    UIButton * selAddImgBtn;
    NSMutableArray * filePathMArray;
    NSMutableArray * imagesMArray;
    NSInteger  count;
    NSMutableString * replyContent;
}

@end

@implementation PostTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发表动态";
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(pustTopicBtnClicked)];
    rightBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
    filePathMArray = [[NSMutableArray alloc] init];
    imagesMArray   = [[NSMutableArray alloc] init];
    replyContent   = [[NSMutableString alloc] init];
    contentTextView.text = contentTextViewDefText;
    [contentTextView setBorderWithWidth:Number_One color:[UIColor grayColor] radian:5.0];
    [contentTextView setContentOffset:CGPointZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//发表动态
- (void)pustTopicBtnClicked {
    [self loadImg];
}


//上传图片
- (void)loadImg {
    if([imagesMArray count] > Number_Zero) {
        [[KGHUD sharedHud] show:self.contentView msg:@"上传图片中..."];
        [[KGHttpService sharedService] uploadImg:[imagesMArray objectAtIndex:count] withName:@"file" type:1 success:^(NSString *msgStr) {
            
            [replyContent appendFormat:@"<img src='%@' />", msgStr];
            
            [self uploadImgSuccessHandler];
        } faild:^(NSString *errorMsg) {
            [self uploadImgSuccessHandler];
        }];
    } else {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:@"请添加图片"];
    }
}

- (void)uploadImgSuccessHandler {
    count++;
    
    if(count < [imagesMArray count]) {
        [self loadImg];
    } else {
        [self sendReplyInfo];
    }
}

- (void)sendReplyInfo {
    [[KGHUD sharedHud] changeText:self.contentView text:@"发表中..."];
    
    ReplyDomain * replyObj = [[ReplyDomain alloc] init];
    
    [replyContent appendString:[KGNSStringUtil trimString:contentTextView.text]];
    
    replyObj.content = replyContent;
    replyObj.newsuuid = _topicUUID;
    replyObj.topicType = _topicType;
    
    [[KGHttpService sharedService] saveReply:replyObj success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}


- (IBAction)addImgBtnClicked:(UIButton *)sender {
    
    selAddImgBtn = sender;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册选取", @"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.contentView];
}

#pragma TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    contentTextView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([[KGNSStringUtil trimString:textView.text] isEqualToString:@""]) {
        contentTextView.text = contentTextViewDefText;
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//}


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
        NSString * filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        [filePathMArray addObject:filePath];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        //        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
        //                                    CGRectMake(50, 120, 40, 40)];
        //
        //        smallimage.image = image;
        //        //加在视图中
        //        [self.view addSubview:smallimage];
        
        [selAddImgBtn setBackgroundImage:image forState:UIControlStateNormal];
        [selAddImgBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [selAddImgBtn setBackgroundImage:image forState:UIControlStateSelected];
        
        [imagesMArray addObject:image];
        [self selImgAfterHandler];
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)selImgAfterHandler {
    if(selAddImgBtn.tag < 12) {
        [self.contentView viewWithTag:selAddImgBtn.tag + 1].hidden = NO;
    }
}



@end
