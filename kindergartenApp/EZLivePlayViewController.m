//
//  EZLivePlayViewController.m
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/10/28.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import <sys/sysctl.h>
#import <mach/mach.h>
#import "EZLivePlayViewController.h"
#import "EZOpenSDK.h"
#import "UIViewController+EZBackPop.h"
#import "EZDeviceInfo.h"
#import "EZPlayer.h"	
#import "DDKit.h"
#import "Masonry.h"
#import "HIKLoadView.h"
#import "MBProgressHUD.h"

@interface EZLivePlayViewController ()<EZPlayerDelegate, UIAlertViewDelegate>
{
    NSOperation *op;
}

@property (nonatomic) BOOL isOpenSound;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, strong) NSTimer *recordTimer;
@property (nonatomic) NSTimeInterval seconds;
@property (nonatomic, strong) CALayer *orangeLayer;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) EZPlayer *player;
@property (nonatomic, strong) HIKLoadView *loadingView;
@property (nonatomic, weak) IBOutlet UIButton *playerPlayButton;
@property (nonatomic, weak) IBOutlet UIView *playerView;
@property (nonatomic, weak) IBOutlet UIView *toolBar;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIButton *controlButton;
@property (nonatomic, weak) IBOutlet UIButton *talkButton;
@property (nonatomic, weak) IBOutlet UIButton *captureButton;
@property (nonatomic, weak) IBOutlet UIButton *localRecordButton;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *voiceButton;
@property (nonatomic, weak) IBOutlet UIButton *qualityButton;
@property (nonatomic, weak) IBOutlet UIButton *emptyButton;
@property (nonatomic, weak) IBOutlet UIButton *largeButton;
@property (nonatomic, weak) IBOutlet UIButton *largeBackButton;
@property (nonatomic, weak) IBOutlet UIView *ptzView;
@property (nonatomic, weak) IBOutlet UIButton *ptzCloseButton;
@property (nonatomic, weak) IBOutlet UIButton *ptzControlButton;
@property (nonatomic, weak) IBOutlet UIView *qualityView;
@property (nonatomic, weak) IBOutlet UIButton *highButton;
@property (nonatomic, weak) IBOutlet UIButton *middleButton;
@property (nonatomic, weak) IBOutlet UIButton *lowButton;
@property (nonatomic, weak) IBOutlet UIButton *ptzUpButton;
@property (nonatomic, weak) IBOutlet UIButton *ptzLeftButton;
@property (nonatomic, weak) IBOutlet UIButton *ptzDownButton;
@property (nonatomic, weak) IBOutlet UIButton *ptzRightButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *ptzViewContraint;
@property (nonatomic, weak) IBOutlet UILabel *localRecordLabel;
@property (nonatomic, weak) IBOutlet UIView *talkView;
@property (nonatomic, weak) IBOutlet UIButton *talkCloseButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *talkViewContraint;
@property (nonatomic, weak) IBOutlet UIImageView *speakImageView;
@property (nonatomic, weak) IBOutlet UILabel *largeTitleLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *localRecrodContraint;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) NSMutableData *fileData;
@property (nonatomic, weak) MBProgressHUD *voiceHud;


@end

@implementation EZLivePlayViewController

- (void)dealloc
{
    NSLog(@"%@ dealloc", self.class);
    [EZOpenSDK releasePlayer:_player];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _cameraName;
    self.largeTitleLabel.text = self.title;
    
    self.isAutorotate = YES;
    
    self.ptzView.hidden = YES;
    self.talkView.hidden = YES;
    
    self.talkButton.enabled = NO;
    self.controlButton.enabled = NO;
    self.captureButton.enabled = NO;
    self.localRecordButton.enabled = NO;
    _url=@"rtmp://hzrtmp02.ys7.com:1935/livestream/553280151_4_2_1_0";
    if (_url)
    {
        _player = [EZOpenSDK createPlayerWithUrl:_url];
    }
    else
    {
        [EZOpenSDK getDeviceInfo:_cameraId completion:^(EZDeviceInfo *deviceInfo, NSError *error) {
            if(deviceInfo.isSupportTalk)
            {
                self.talkButton.enabled = YES;
            }
            if(deviceInfo.isSupportPTZ)
            {
                self.controlButton.enabled = YES;
            }
        }];
        
        _player = [EZOpenSDK createPlayerWithCameraId:_cameraId];
    }


    _player.delegate = self;
    [_player setPlayerView:_playerView];
    [_player startRealPlay];
    
    if(!_loadingView)
        _loadingView = [[HIKLoadView alloc] initWithHIKLoadViewStyle:HIKLoadViewStyleSqureClockWise];
    [self.view insertSubview:_loadingView aboveSubview:self.playerView];
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@14);
        make.centerX.mas_equalTo(self.playerView.mas_centerX);
        make.centerY.mas_equalTo(self.playerView.mas_centerY);
    }];
    [self.loadingView startSquareClcokwiseAnimation];
    
    self.largeBackButton.hidden = YES;
    _isOpenSound = YES;
    
    [self.controlButton dd_centerImageAndTitle];
    [self.talkButton dd_centerImageAndTitle];
    [self.captureButton dd_centerImageAndTitle];
    [self.localRecordButton dd_centerImageAndTitle];
    
    [self.voiceButton setImage:[UIImage imageNamed:@"preview_unvoice_btn_sel"] forState:UIControlStateHighlighted];
    [self addLine];
    
    self.localRecordLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.localRecordLabel.layer.cornerRadius = 12.0f;
    self.localRecordLabel.layer.borderWidth = 1.0f;
    self.localRecordLabel.clipsToBounds = YES;
    self.playButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.ptzViewContraint.constant = self.bottomView.frame.size.height;
    self.talkViewContraint.constant = self.ptzViewContraint.constant;
}

- (void)viewWillDisappear:(BOOL)animated {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideQualityView) object:nil];
    //结束本地录像
    if(self.localRecordButton.selected)
    {
        [_player stopLocalRecord];
        [self.fileData writeToFile:_filePath atomically:YES];
        self.localRecordLabel.hidden = YES;
        [_recordTimer invalidate];
        _recordTimer = nil;
        [self saveRecordToPhotosAlbum:_filePath];
    }
    
    NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    self.navigationController.navigationBarHidden = NO;
    self.toolBar.hidden = NO;
    self.largeBackButton.hidden = YES;
    self.bottomView.hidden = NO;
    self.largeTitleLabel.hidden = YES;
    self.localRecrodContraint.constant = 10;
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.navigationController.navigationBarHidden = YES;
        self.localRecrodContraint.constant = 50;
        self.toolBar.hidden = YES;
        self.largeTitleLabel.hidden = NO;
        self.largeBackButton.hidden = NO;
        self.bottomView.hidden = YES;
    }
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *smsCode = [alertView textFieldAtIndex:0].text;
        //验证输入的安全短信验证码
        [EZOpenSDK validateSecureSMSCode:smsCode completion:^(NSError *error) {
            if (!error)
            {
                [_player startRealPlay];
            }
        }];
    }
}

#pragma mark - PlayerDelegate Methods

- (void)player:(EZPlayer *)player didPlayFailed:(NSError *)error
{
    NSLog(@"player: %@, didPlayFailed: %@", player, error);
    [UIView dd_showDetailMessage:[NSString stringWithFormat:@"%d", (int)error.code]];
    [self.voiceHud hide:YES];
    [self.loadingView stopSquareClockwiseAnimation];
    self.messageLabel.text = [NSString stringWithFormat:@"播放失败(%d)", (int)error.code];
    if (error.code > 370000 || error.code != 400077)
    {
        self.messageLabel.hidden = NO;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.speakImageView.alpha = 0.0;
                         self.talkViewContraint.constant = self.bottomView.frame.size.height;
                         [self.bottomView setNeedsUpdateConstraints];
                         [self.bottomView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.speakImageView.alpha = 0;
                         self.talkView.hidden = YES;
                     }];
}

- (void)player:(EZPlayer *)player didReceviedMessage:(NSInteger)messageCode
{
    NSLog(@"player: %@, didReceviedMessage: %d", player, (int)messageCode);
    if (messageCode == PLAYER_REALPLAY_START)
    {
        self.captureButton.enabled = YES;
        self.localRecordButton.enabled = YES;
        [self.loadingView stopSquareClockwiseAnimation];
        self.playButton.enabled = YES;
        [self.playButton setImage:[UIImage imageNamed:@"preview_stopplay_btn_sel"] forState:UIControlStateHighlighted];
        [self.playButton setImage:[UIImage imageNamed:@"preview_stopplay_btn"] forState:UIControlStateNormal];
        _isPlaying = YES;
        
        if (!_isOpenSound)
        {
            [player closeSound];
        }
        self.messageLabel.hidden = YES;
    }
    else if(messageCode == PLAYER_VOICE_TALK_START)
    {
        [self.voiceHud hide:YES];
        [self.bottomView bringSubviewToFront:self.talkView];
        self.talkView.hidden = NO;
        self.speakImageView.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.talkViewContraint.constant = 0;
                             self.speakImageView.alpha = 1.0;
                             [self.bottomView setNeedsUpdateConstraints];
                             [self.bottomView layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

#pragma mark - Action Methods

- (IBAction)large:(id)sender
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (IBAction)largeBack:(id)sender
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (IBAction)capture:(id)sender
{
    UIImage *image = [_player capturePicture:100];
    [self saveImageToPhotosAlbum:image];
}

- (IBAction)talkButtonClicked:(id)sender
{
    [_player startVoiceTalk];
    if (!_voiceHud) {
        _voiceHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    self.voiceHud.labelText = @"正在开启对讲，请稍候...";
}

- (IBAction)voiceButtonClicked:(id)sender
{
    if(_isOpenSound){
        [_player closeSound];
        [self.voiceButton setImage:[UIImage imageNamed:@"preview_unvoice_btn_sel"] forState:UIControlStateHighlighted];
        [self.voiceButton setImage:[UIImage imageNamed:@"preview_unvoice_btn"] forState:UIControlStateNormal];
    }
    else
    {
        [_player openSound];
        [self.voiceButton setImage:[UIImage imageNamed:@"preview_voice_btn_sel"] forState:UIControlStateHighlighted];
        [self.voiceButton setImage:[UIImage imageNamed:@"preview_voice_btn"] forState:UIControlStateNormal];
    }
    _isOpenSound = !_isOpenSound;
}

- (IBAction)playButtonClicked:(id)sender
{
    if(_isPlaying)
    {
        [_player stopRealPlay];
        [_playerView setBackgroundColor:[UIColor blackColor]];
        [self.playButton setImage:[UIImage imageNamed:@"preview_play_btn_sel"] forState:UIControlStateHighlighted];
        [self.playButton setImage:[UIImage imageNamed:@"preview_play_btn"] forState:UIControlStateNormal];
        self.localRecordButton.enabled = NO;
        self.captureButton.enabled = NO;
        self.playerPlayButton.hidden = NO;
    }
    else
    {
        [_player startRealPlay];
        self.playerPlayButton.hidden = YES;
        [self.playButton setImage:[UIImage imageNamed:@"preview_stopplay_btn_sel"] forState:UIControlStateHighlighted];
        [self.playButton setImage:[UIImage imageNamed:@"preview_stopplay_btn"] forState:UIControlStateNormal];
        [self.loadingView startSquareClcokwiseAnimation];
    }
    _isPlaying = !_isPlaying;
}

- (IBAction)qualityButtonClicked:(id)sender
{
    if(self.qualityButton.selected)
    {
        self.qualityView.hidden = YES;
    }
    else
    {
        self.qualityView.hidden = NO;
        //停留5s以后隐藏视频质量View.
        [self performSelector:@selector(hideQualityView) withObject:nil afterDelay:5.0f];
    }
    self.qualityButton.selected = !self.qualityButton.selected;
}

- (void)hideQualityView
{
    self.qualityButton.selected = NO;
    self.qualityView.hidden = YES;
}

- (IBAction)qualitySelectedClicked:(id)sender
{
    BOOL result = NO;
    if (sender == self.highButton)
    {
        result = [_player setVideoLevel:EZVideoQualityHigh];
        [self.qualityButton setTitle:@"高清" forState:UIControlStateNormal];
    }
    else if (sender == self.middleButton)
    {
        result = [_player setVideoLevel:EZVideoQualityMiddle];
        [self.qualityButton setTitle:@"均衡" forState:UIControlStateNormal];
    }
    else
    {
        result = [_player setVideoLevel:EZVideoQualityLow];
        [self.qualityButton setTitle:@"流畅" forState:UIControlStateNormal];
    }
    if (result)
    {
        [self.loadingView startSquareClcokwiseAnimation];
    }
    self.qualityView.hidden = YES;
}

- (IBAction)ptzControlButtonTouchDown:(id)sender
{
    EZPTZCommand command;
    NSString *imageName = nil;
    if(sender == self.ptzLeftButton)
    {
        command = EZPTZCommandLeft;
        imageName = @"ptz_left_sel";
    }
    else if (sender == self.ptzDownButton)
    {
        command = EZPTZCommandDown;
        imageName = @"ptz_bottom_sel";
    }
    else if (sender == self.ptzRightButton)
    {
        command = EZPtzCommandRight;
        imageName = @"ptz_right_sel";
    }
    else {
        command = EZPTZCommandUp;
        imageName = @"ptz_up_sel";
    }
    [self.ptzControlButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
    [EZOpenSDK controlPTZ:_cameraId
                  command:command
                   action:EZPTZActionStart
                    speed:3.0
                   result:^(BOOL result, NSError *error) {
                   }];
}

- (IBAction)ptzControlButtonTouchUpInside:(id)sender
{
    EZPTZCommand command;
    if(sender == self.ptzLeftButton)
    {
        command = EZPTZCommandLeft;
    }
    else if (sender == self.ptzDownButton)
    {
        command = EZPTZCommandDown;
    }
    else if (sender == self.ptzRightButton)
    {
        command = EZPtzCommandRight;
    }
    else {
        command = EZPTZCommandUp;
    }
    [self.ptzControlButton setImage:[UIImage imageNamed:@"ptz_bg"] forState:UIControlStateDisabled];
    [EZOpenSDK controlPTZ:_cameraId
                  command:command
                   action:EZPTZActionStop
                    speed:3.0
                   result:^(BOOL result, NSError *error) {
                   }];
}

- (IBAction)ptzViewShow:(id)sender
{
    self.ptzView.hidden = NO;
    [self.bottomView bringSubviewToFront:self.ptzView];
    self.ptzControlButton.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.ptzViewContraint.constant = 0;
                         self.ptzControlButton.alpha = 1.0;
                         [self.bottomView setNeedsUpdateConstraints];
                         [self.bottomView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (IBAction)closePtzView:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.ptzControlButton.alpha = 0.0;
                         self.ptzViewContraint.constant = self.bottomView.frame.size.height;
                         [self.bottomView setNeedsUpdateConstraints];
                         [self.bottomView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.ptzControlButton.alpha = 0;
                         self.ptzView.hidden = YES;
                     }];
}

- (IBAction)closeTalkView:(id)sender
{
    [_player stopVoiceTalk];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.speakImageView.alpha = 0.0;
                         self.talkViewContraint.constant = self.bottomView.frame.size.height;
                         [self.bottomView setNeedsUpdateConstraints];
                         [self.bottomView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.speakImageView.alpha = 0;
                         self.talkView.hidden = YES;
                     }];
}

- (IBAction)localButtonClicked:(id)sender
{
    //结束本地录像
    if(self.localRecordButton.selected)
    {
        [_player stopLocalRecord];
        [_recordTimer invalidate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            _recordTimer = nil;
            [_fileData writeToFile:_filePath atomically:YES];
            self.localRecordLabel.hidden = YES;
            [self saveRecordToPhotosAlbum:_filePath];
            _filePath = nil;
        });
    }
    else
    {
        //开始本地录像
        NSString *path = @"/OpenSDK/EzvizLocalRecord";
        
        NSArray * docdirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * docdir = [docdirs objectAtIndex:0];
        
        NSString * configFilePath = [docdir stringByAppendingPathComponent:path];
        if(![[NSFileManager defaultManager] fileExistsAtPath:configFilePath]){
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:configFilePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
        }
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyyMMddHHmmssSSS";
        _filePath = [NSString stringWithFormat:@"%@/%@.mov",configFilePath,[dateformatter stringFromDate:[NSDate date]]];
        if (!_fileData) {
            _fileData = [NSMutableData new];
        }
        __weak __typeof(self) weakSelf = self;
        [_player startLocalRecord:^(NSData *data) {
            if (!_recordTimer)
            {
                _recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
            }
            if (!data || !weakSelf.fileData) {
                return;
            }
            [weakSelf.fileData appendData:data];
        }];
        self.localRecordLabel.hidden = NO;
        _seconds = 0;
    }
    self.localRecordButton.selected = !self.localRecordButton.selected;
}

- (void)timerStart:(NSTimer *)timer
{
    NSInteger currentTime = ++_seconds;
    self.localRecordLabel.text = [NSString stringWithFormat:@"  %02d:%02d", (int)currentTime/60, (int)currentTime % 60];
    if (!_orangeLayer)
    {
        _orangeLayer = [CALayer layer];
        _orangeLayer.frame = CGRectMake(10.0, 8.0, 8.0, 8.0);
        _orangeLayer.backgroundColor = [UIColor dd_hexStringToColor:@"0xff6000"].CGColor;
        _orangeLayer.cornerRadius = 4.0f;
    }
    if(currentTime % 2 == 0)
    {
        [_orangeLayer removeFromSuperlayer];
    }
    else
    {
        [self.localRecordLabel.layer addSublayer:_orangeLayer];
    }
}

#pragma mark - Private Methods

- (void)saveImageToPhotosAlbum:(UIImage *)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)saveRecordToPhotosAlbum:(NSString *)path
{
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = nil;
    if (!error) {
        message = @"已保存至手机相册";
    }
    else
    {
        message = [error description];
    }
    [UIView dd_showMessage:message];
}

- (void)addLine
{
    for (UIView *view in self.toolBar.subviews) {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    CGFloat averageWidth = [UIScreen mainScreen].bounds.size.width/5.0;
    UIImageView *lineImageView1 = [UIView dd_instanceVerticalLine:20 color:[UIColor grayColor]];
    lineImageView1.frame = CGRectMake(averageWidth, 7, lineImageView1.frame.size.width, lineImageView1.frame.size.height);
    [self.toolBar addSubview:lineImageView1];
    UIImageView *lineImageView2 = [UIView dd_instanceVerticalLine:20 color:[UIColor grayColor]];
    lineImageView2.frame = CGRectMake(averageWidth * 2, 7, lineImageView2.frame.size.width, lineImageView2.frame.size.height);
    [self.toolBar addSubview:lineImageView2];
    UIImageView *lineImageView3 = [UIView dd_instanceVerticalLine:20 color:[UIColor grayColor]];
    lineImageView3.frame = CGRectMake(averageWidth * 3, 7, lineImageView3.frame.size.width, lineImageView3.frame.size.height);
    [self.toolBar addSubview:lineImageView3];
    UIImageView *lineImageView4 = [UIView dd_instanceVerticalLine:20 color:[UIColor grayColor]];
    lineImageView4.frame = CGRectMake(averageWidth * 4, 7, lineImageView4.frame.size.width, lineImageView4.frame.size.height);
    [self.toolBar addSubview:lineImageView4];
}

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

@end
