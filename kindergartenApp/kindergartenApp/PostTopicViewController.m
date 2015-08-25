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
#import "KGTextView.h"
#import "KGHttpService.h"
#import "ClassDomain.h"
#import "GroupDomain.h"
#import "AssetHelper.h"

#define contentTextViewDefText   @"说点什么吧..."
#define AddBtnWidth (70) //图片按钮的宽度
#define BtnInterval (5) //图片按钮之间的间隙
#define AddImageName @"tianjiatupian"

@interface PostTopicViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextViewDelegate> {
    
    IBOutlet KGTextView * contentTextView;
    UIButton * selAddImgBtn;
    NSMutableArray * filePathMArray;
    NSMutableArray * imagesMArray;
    NSInteger  count;
    NSMutableString * replyContent;
    NSString * classuuid;//班级id
    NSMutableArray * dataMArray;//数据数组 用于构建班级信息
    //需要上传的图片集合
    NSMutableArray        * imgMArray;
}

@end

@implementation PostTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _photoScrollView.contentSize = CGSizeMake(AddBtnWidth, _photoScrollView.height);
    _addPhotoBtnMArray = [[NSMutableArray alloc] init];
    _photoContentView = [[UIView alloc] init];
    _photoContentView.height = _photoScrollView.height;
    _photoContentView.width = AddBtnWidth;
    [_photoScrollView addSubview:_photoContentView];
    [self resetScrollViewPhoto];
    
    self.weakTextView = contentTextView;
    self.keyboardTopType = OnlyEmojiMode;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"发表互动";
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(pustTopicBtnClicked)];
    rightBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    filePathMArray = [[NSMutableArray alloc] init];
    imagesMArray   = [[NSMutableArray alloc] init];
    replyContent   = [[NSMutableString alloc] init];
    contentTextView.placeholder = contentTextViewDefText;
    [contentTextView setContentOffset:CGPointZero];
    
    [self loadClassNameListView];
}

#pragma mark - 重置显示横向滚动图片
- (void)resetScrollViewPhoto{

    for (UIButton * button in _addPhotoBtnMArray) {
        [button removeFromSuperview];
    }
    [_addPhotoBtnMArray removeAllObjects];
    
    for (int i = 0; i < imagesMArray.count; ++ i) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.size = CGSizeMake(AddBtnWidth, AddBtnWidth);
        button.origin = CGPointMake(i*(AddBtnWidth+BtnInterval), 0);
        [button setImage:imagesMArray[i] forState:UIControlStateNormal];
        [button setImage:imagesMArray[i] forState:UIControlStateHighlighted];
        [button setImage:imagesMArray[i] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(photoHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_photoContentView addSubview:button];
        [_addPhotoBtnMArray addObject:button];
    }
    
    if (imagesMArray.count < 9) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.size = CGSizeMake(AddBtnWidth, AddBtnWidth);
        button.origin = CGPointMake(_addPhotoBtnMArray.count*(AddBtnWidth+BtnInterval), 0);
        [button setImage:[UIImage imageNamed:AddImageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:AddImageName] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:AddImageName] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(photoHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_photoContentView addSubview:button];
        [_addPhotoBtnMArray addObject:button];
    }
    
    _photoContentView.frame = CGRectMake(0, 0, _addPhotoBtnMArray.count*(AddBtnWidth+BtnInterval), _photoScrollView.height);
    _photoScrollView.contentSize = CGSizeMake(_photoContentView.width, _photoScrollView.height);
}

#pragma mark - 图片点击
- (void)photoHandle:(UIButton*)sender{
    
    if (imagesMArray.count < 9 && sender == [_addPhotoBtnMArray lastObject]) {
        DoImagePickerController *cont = [[DoImagePickerController alloc] init];
        cont.delegate = self;
        cont.nMaxCount = 9 - imagesMArray.count;
        cont.nResultType = DO_PICKER_RESULT_ASSET;
        cont.nColumnCount = 4;
        [self presentViewController:cont animated:YES completion:nil];
    }else{
        PhotoVC * vc = [[PhotoVC alloc] init];
        vc.imgMArray = imagesMArray;
        vc.isShowDel = YES;
        __weak typeof(self) weakSelf = self;
        [vc setMyBlock:^(NSArray * array){
            imagesMArray = [NSMutableArray arrayWithArray:array];
            [weakSelf resetScrollViewPhoto];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//加载班级选择
- (void)loadClassNameListView {
    [self.contentView bringSubviewToFront:contentTextView];
    for (UIView * view in _btnArray) {
        [self.contentView bringSubviewToFront:view];
    }
    
    dataMArray = [[NSMutableArray alloc] init];
    for (GroupDomain * gmodel in [KGHttpService sharedService].loginRespDomain.group_list) {
        for (ClassDomain * cmodel in [KGHttpService sharedService].loginRespDomain.class_list) {
            if ([gmodel.uuid isEqualToString:cmodel.groupuuid]) {
                NSString * name = [NSString stringWithFormat:@"%@%@",gmodel.company_name,cmodel.name];
                [dataMArray addObject:@{@"name":name,@"id":cmodel.uuid}];
            }
        }
    }
    
    if([dataMArray count] > Number_Zero) {
        [_selectBtn setTitle:[dataMArray[0] objectForKey:@"name"] forState:UIControlStateNormal];
        classuuid = [dataMArray[0] objectForKey:@"id"];
    }
}

//下拉选择菜单
- (IBAction)selectBtnPressed:(UIButton *)sender {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] init];
        _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectTableView.backgroundColor = [UIColor whiteColor];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        _selectTableView.rowHeight = 40;
        [_selectTableView registerNib:[UINib nibWithNibName:@"SelectClassCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SelectClassCell"];
        _selectTableView.size = CGSizeMake(APPWINDOWWIDTH, dataMArray.count<4?dataMArray.count*40:40*4);
    }
    if (_selectTableView.superview) {
        return;
    }
    _selectTableView.origin = CGPointMake(0, CGRectGetMaxY(_bgView.frame));
    [self.contentView addSubview:_selectTableView];
    [self showSelectTableViewAnimation];
}

//显示选择动画
- (void)showSelectTableViewAnimation{
    _selectTableView.height = 0;
    _arrowImageView.image = [UIImage imageNamed:@"shangjiantou"];
    [UIView animateWithDuration:0.3 animations:^{
        _selectTableView.height = dataMArray.count<4?dataMArray.count*40:40*4;
    } completion:^(BOOL finished) {
    }];
}

//隐藏选择动画
- (void)hiddenSelectTableViewAnimation{
    _arrowImageView.image = [UIImage imageNamed:@"xiajiantou-1"];
    [UIView animateWithDuration:0.3 animations:^{
        _selectTableView.height = 0;
    } completion:^(BOOL finished) {
        [_selectTableView removeFromSuperview];
        [_selectTableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectClassCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SelectClassCell"];
    cell.selectImageView.hidden = ![[dataMArray[indexPath.row] objectForKey:@"id"] isEqualToString:classuuid];
    cell.nameLabel.text = [dataMArray[indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int i = 0;
    for (; i < dataMArray.count; ++ i) {
        NSDictionary * dic = dataMArray[i];
        if ([[dic objectForKey:@"id"] isEqualToString:classuuid]) {
            break;
        }
    }
    SelectClassCell * cell = (SelectClassCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    cell.selectImageView.hidden = YES;
    classuuid = [dataMArray[indexPath.row] objectForKey:@"id"];
    [_selectBtn setTitle:[dataMArray[indexPath.row] objectForKey:@"name"] forState:UIControlStateNormal];
    [self hiddenSelectTableViewAnimation];
}

//发表动态
- (void)pustTopicBtnClicked {
    [contentTextView resignFirstResponder];
    NSString * topicText = [KGNSStringUtil trimString:contentTextView.text];
    if((!topicText || [topicText isEqualToString:String_DefValue_Empty]) && [imagesMArray count]==Number_Zero) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容或者图片必填其中一项。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        [self loadImg];
    }
}


//上传图片
- (void)loadImg {
    if([imagesMArray count] > Number_Zero) {
        [[KGHUD sharedHud] show:self.view msg:@"上传图片中..."];
        [[KGHttpService sharedService] uploadImg:[imagesMArray objectAtIndex:count] withName:@"file" type:self.topicType success:^(NSString *msgStr) {
            
            if(![replyContent isEqualToString:String_DefValue_EmptyStr]) {
                [replyContent appendString:String_DefValue_SpliteStr];
            }
            [replyContent appendString:msgStr];
            
            [self uploadImgSuccessHandler];
        } faild:^(NSString *errorMsg) {
            [self uploadImgSuccessHandler];
        }];
    } else {
        [self sendReplyInfo];
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
    [[KGHUD sharedHud] changeText:self.view text:@"发表中..."];
    
    TopicDomain * domain = [[TopicDomain alloc] init];
    domain.classuuid = classuuid;
    domain.content = [KGNSStringUtil trimString:contentTextView.text];
    domain.imgs = replyContent;
    
    [[KGHttpService sharedService] saveClassNews:domain success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
        
        if(_PostTopicBlock) {
            _PostTopicBlock(domain);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
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
        NSData * data = UIImageJPEGRepresentation(image, 0.5);
        
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


#pragma mark - DoImagePickerControllerDelegate

/**
 *  图片选择取消
 */
- (void)didCancelDoImagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  图片选择确定回调
 *
 *  @param picker    图片选择器
 *  @param aSelected 选中的图片集合
 */
- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(aSelected && [aSelected count]>Number_Zero) {
        [self initImgMArray];
        for(NSInteger i=Number_Zero; i<[aSelected count]; i++) {
            UIImage * image       = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];
            [imagesMArray addObject:image];
        }
    }
    [self resetScrollViewPhoto];
    
    [ASSETHELPER clearData];
}

- (void)simpleShowImageWithArray:(NSArray *)imgArray {
    [imagesMArray addObjectsFromArray:imgArray];
    [self resetScrollViewPhoto];
}

/**
 *  初始化imgMArray
 */
- (void)initImgMArray {
    if(!imgMArray) {
        imgMArray = [[NSMutableArray alloc] init];
    } else {
        [imgMArray removeAllObjects];
    }
}



@end
