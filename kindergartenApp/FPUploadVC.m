//
//  FPUploadVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPUploadVC.h"
#import "FPImagePickerVC.h"
#import "MJExtension.h"
#import "FPFamilyPhotoUploadDomain.h"
#import "FPUploadCell.h"
#import "AFNetworking.h"
#import "KGHttpUrl.h"
#import "KGHttpService.h"

@interface FPUploadVC () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _dataArrs;
    NSURLSessionUploadTask *uploadTask;
}

@property (strong, nonatomic) UITableView * uploadTable;

@end

@implementation FPUploadVC

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
    {
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (ALAssetsLibrary *)library
{
    if (nil == _library)
    {
        _library = [self.class defaultAssetsLibrary];
    }
    return _library;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataArrs = [NSMutableArray array];
    
    _library = [[ALAssetsLibrary alloc] init];
    
    self.title = @"上传列表";
    
    [self initTableView];
    
    //在右上角添加一个按钮来选择图片
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(openSelectImageView)];
    barbtn.title = @"添加相片";
    barbtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = barbtn;
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didGetPhotoData:) name:@"didgetphotodata" object:nil];
    [center addObserver:self selector:@selector(startUpLoad:) name:@"startupload" object:nil];
}

- (void)initTableView
{
    self.uploadTable = [[UITableView alloc] init];
    self.uploadTable.dataSource = self;
    self.uploadTable.delegate = self;
    self.uploadTable.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT-64);
    [self.view addSubview:self.uploadTable];
}

#pragma mark - tableview d & d
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * upload_ID = @"upload_id";
    
    FPUploadCell * cell = [tableView dequeueReusableCellWithIdentifier:upload_ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FPUploadCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setData:_dataArrs[indexPath.row]];
    cell.index = indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)openSelectImageView
{
    FPImagePickerVC * vc = [[FPImagePickerVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 通知
- (void)didGetPhotoData:(NSNotification *)noti
{
    NSArray * urls = noti.object;
    
    for (NSInteger i=0; i<urls.count; i++)
    {
        FPFamilyPhotoUploadDomain * domain = [[FPFamilyPhotoUploadDomain alloc] init];
        
        [_library assetForURL:urls[i] resultBlock:^(ALAsset *asset)
        {
            domain.localurl = urls[i];
            domain.status = 1;
            domain.suoluetu = [UIImage imageWithCGImage:[asset thumbnail]];
            [_dataArrs addObject:domain];
            
            if (_dataArrs.count == urls.count)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    [self.uploadTable reloadData];
                });
            }
        }
        failureBlock:^(NSError *error)
        {
            NSLog(@"大图失败拉");
        }];
    }
}

- (void)dealloc
{
    NSLog(@"upload delloc ---");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 开始上传
- (void)startUpLoad:(NSNotification *)noti
{
    NSInteger index = [noti.object integerValue];
    
    FPFamilyPhotoUploadDomain * domain = _dataArrs[index];

    NSURL * localUrl = domain.localurl;
    [_library assetForURL:localUrl resultBlock:^(ALAsset *asset)
    {
        //获取大图
        UIImage * img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        //获取时间
        NSString * date = [asset valueForProperty:@"ALAssetPropertyDate"];
        //改变_dataArr里面的上传状态
        ((FPFamilyPhotoUploadDomain *)_dataArrs[index]).status = 2;//正在上传
        
        [self upLoadPic:img photoTime:date];
    }
    failureBlock:^(NSError *error)
    {
        NSLog(@"根据local url 查找失败");
    }];
}

- (void)upLoadPic:(UIImage *)img photoTime:(NSString *)photoTime
{
    NSData *data;
    data = UIImageJPEGRepresentation(img, 0.1);
    NSDictionary * dict = @{@"JSESSIONID":[KGHttpService sharedService].loginRespDomain.JSESSIONID,@"family_uuid":self.family_uuid,@"photo_time":photoTime};
    NSLog(@"%@",dict);
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:[KGHttpUrl getFPUploadImgUrl] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:@"file"
                                mimeType:@"image/jpeg"];
    } error:nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"Success %@", responseObject);
         
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Failure %@", error.description);
    }];
    
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite)
    {
        NSLog(@"%%%f",totalBytesWritten * 1.0 /totalBytesExpectedToWrite * 1.0);
    }];
    
    // 5. Begin!
    [operation start];
}


@end
