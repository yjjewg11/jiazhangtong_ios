//
//  UUMessageCell.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageCell.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "UUAVAudioPlayer.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "UUImageAvatarBrowser.h"
#import "KGHttpService.h"
#import "KGEmojiManage.h"

@interface UUMessageCell ()<UUAVAudioPlayerDelegate>
{
    AVAudioPlayer *player;
    NSString *voiceURL;
    NSData *songData;
    
    UUAVAudioPlayer *audio;
    
    UIView *headImageBackView;
    BOOL contentVoiceIsPlaying;
}
@end

@implementation UUMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        headImageBackView = [[UIView alloc]init];
        headImageBackView.layer.cornerRadius = 22;
        headImageBackView.layer.masksToBounds = YES;
        headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 20;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [headImageBackView addSubview:self.btnHeadImage];
        
        // 3、创建头像下标
//        self.labelNum = [[UILabel alloc] init];
//        self.labelNum.textColor = [UIColor grayColor];
//        self.labelNum.textAlignment = NSTextAlignmentCenter;
//        self.labelNum.font = ChatTimeFont;
//        [self.contentView addSubview:self.labelNum];
        
        // 4、创建内容
        self.btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
//        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
        
        self.contentTextView = [MLEmojiLabel new];
        self.contentTextView.numberOfLines = 0;
        self.contentTextView.font = [UIFont systemFontOfSize:APPUILABELFONTNO12];
        self.contentTextView.lineBreakMode = NSLineBreakByCharWrapping;
        self.contentTextView.isNeedAtAndPoundSign = YES;
        self.contentTextView.customEmojiRegex = String_DefValue_EmojiRegex;
        [self addSubview:self.contentTextView];
        
        self.contentTransparentBtn = [[UIButton alloc] init];
        self.contentTransparentBtn.backgroundColor = [UIColor clearColor];
        [self.contentTransparentBtn addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.contentTransparentBtn];
        
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        self.activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
        self.activityIndicatorView.hidesWhenStopped = NO;
        [self addSubview:self.activityIndicatorView ];
        self.activityIndicatorView.hidden = YES;
        
        self.sendErrorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fasongshibai"]];
//        self.sendErrorImageView.hidden = YES;
        self.sendErrorImageView.alpha = Number_Zero;
        [self addSubview:self.sendErrorImageView];
        
        //红外线感应监听
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(sensorStateChange:)
//                                                     name:UIDeviceProximityStateDidChangeNotification
//                                                   object:nil];
        contentVoiceIsPlaying = NO;

    }
    return self;
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:self.messageFrame.message.strId];
    }
}


- (void)btnContentClick{
    //play audio
//    if (self.messageFrame.message.type == UUMessageTypeVoice) {
//        if(!contentVoiceIsPlaying){
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
//            contentVoiceIsPlaying = YES;
//            audio = [UUAVAudioPlayer sharedInstance];
//            audio.delegate = self;
//            //        [audio playSongWithUrl:voiceURL];
//            [audio playSongWithData:songData];
//        }else{
//            [self UUAVAudioPlayerDidFinishPlay];
//        }
//    }
//    //show the picture
//    else if (self.messageFrame.message.type == UUMessageTypePicture)
//    {
//        if (self.btnContent.backImageView) {
//            [UUImageAvatarBrowser showImage:self.btnContent.backImageView url:nil];
//        }
//        if ([self.delegate isKindOfClass:[UIViewController class]]) {
//            [[(UIViewController *)self.delegate view] endEditing:YES];
//        }
//    }
    // show text and gonna copy that
//    else
    if (self.messageFrame.message.type == UUMessageTypeText)
    {
//        [self.btnContent becomeFirstResponder];
//        UIMenuController *menu = [UIMenuController sharedMenuController];
//        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
//        [menu setMenuVisible:YES animated:YES];
        if(_isSendError) {
            //通知二次发送
            NSDictionary *dic = @{Key_WriteVO : _messageFrame.message.writeVO};
            [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_ChatSecondSend object:self userInfo:dic];
        }
    }
}

- (void)UUAVAudioPlayerBeiginLoadVoice
{
    [self.btnContent benginLoadVoice];
}
- (void)UUAVAudioPlayerBeiginPlay
{
    //开启红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [self.btnContent didLoadVoice];
}
- (void)UUAVAudioPlayerDidFinishPlay
{
    //关闭红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    contentVoiceIsPlaying = NO;
    [self.btnContent stopPlay];
    [[UUAVAudioPlayer sharedInstance]stopSound];
}

//内容及Frame设置
- (void)setMessageFrame:(UUMessageFrame *)messageFrame{

    _messageFrame = messageFrame;
    UUMessage *message = messageFrame.message;
    
    // 1、设置时间
    self.labelTime.text = message.strTime;
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    headImageBackView.frame = messageFrame.iconF;
    self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
    
    
    // 3、设置下标
//    self.labelNum.text = message.strName;
//    if (messageFrame.nameF.origin.x > 160) {
//        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - 50, messageFrame.nameF.origin.y + 3, 100, messageFrame.nameF.size.height);
//        self.labelNum.textAlignment = NSTextAlignmentRight;
//    }else{
//        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 3, 80, messageFrame.nameF.size.height);
//        self.labelNum.textAlignment = NSTextAlignmentLeft;
//    }

    // 4、设置内容
    
    //prepare for reuse
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;

    self.btnContent.frame = messageFrame.contentF;
    self.contentTransparentBtn.frame = messageFrame.contentF;
    self.contentTextView.frame = messageFrame.contentTextViewF;
    
    if (message.from == UUMessageFromMe) {
        self.btnContent.isMyMessage = YES;
        [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
    }else{
        self.btnContent.isMyMessage = NO;
        [self.btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
    }
    
    NSString * defheadImage = @"head_def";
    //背景气泡图
    UIImage *normal;
    if (message.from == UUMessageFromMe) {
        normal = [UIImage imageNamed:@"massage_box"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }
    else{
        normal = [UIImage imageNamed:@"massage2_box"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
        defheadImage = message.isTeacher ? defheadImage : @"group_head_def";
    }
    
    [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal
                                          withURL:[NSURL URLWithString:message.strIcon]
                                 placeholderImage:[UIImage imageNamed:defheadImage]];
    
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];

    switch (message.type) {
        case UUMessageTypeText:
//            [self.btnContent setTitle:message.strContent forState:UIControlStateNormal];
//            [self.contentTextView setText:message.strContent];
            self.contentTextView.text = message.strContent;
            break;
        case UUMessageTypePicture:
        {
            self.btnContent.backImageView.hidden = NO;
            self.btnContent.backImageView.image = message.picture;
            self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
            [self makeMaskView:self.btnContent.backImageView withImage:normal];
            self.contentTextView.hidden = YES;
        }
            break;
        case UUMessageTypeVoice:
        {
            self.btnContent.voiceBackView.hidden = NO;
            self.btnContent.second.text = [NSString stringWithFormat:@"%@'s Voice",message.strVoiceTime];
            songData = message.voice;
//            voiceURL = [NSString stringWithFormat:@"%@%@",RESOURCE_URL_HOST,message.strVoice];
        }
            break;
            
        default:
            break;
    }
    
    if (message.from == UUMessageFromMe && message.isNewMsg) {
        [self sendTextInfo];
        self.activityIndicatorView.frame = messageFrame.hudF;
        [self.activityIndicatorView startAnimating];
        self.activityIndicatorView.hidden = NO;
        _sendErrorImageView.frame = CGRectMake(_messageFrame.hudF.origin.x + 20, _messageFrame.hudF.origin.y + 10, 15, 15);
    } else {
        self.activityIndicatorView.hidden = YES;
    }
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

//提交发送文本
- (void)sendTextInfo {
    WriteVO * domain = _messageFrame.message.writeVO;
    domain.message = [[KGEmojiManage sharedManage] textConventHTMLText:domain.strContent];
    [[KGHttpService sharedService] saveAddressBookInfo:domain success:^(NSString *msgStr) {
        
        [self hideActivity:NO];
        _isSendError = NO;
        _sendErrorImageView.alpha = Number_Zero;
    } faild:^(NSString *errorMsg) {
        [self hideActivity:YES];
    }];
}

- (void)hideActivity:(BOOL)isError {
    _isSendError = isError;
    [_activityIndicatorView stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        _activityIndicatorView.alpha = Number_Zero;
        if(isError) {
            _sendErrorImageView.alpha = Number_One;
        }
    } completion:^(BOOL finished) {
        [_activityIndicatorView removeFromSuperview];
    }];
}

@end


