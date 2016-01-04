//
//  SPCourseDetailWebView.m
//  kindergartenApp
//
//  Created by Mac on 15/11/20.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPCourseDetailWebView.h"

#import "LBXScanView.h"
#import <objc/message.h>
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "BrowseURLViewController.h"

@interface SPCourseDetailWebView() <UIWebViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    NSTimer *_timer;	// 用于UIWebView保存图片
    int _gesState;	  // 用于UIWebView保存图片
    NSString *_imgURL;  // 用于UIWebView保存图片
    BOOL longPress;
}

@property (weak, nonatomic) IBOutlet UIView *sepViewNoOne;

@property (weak, nonatomic) IBOutlet UIView *courseDetailView;

@property (weak, nonatomic) IBOutlet UILabel *courseNameLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *courseInfoLbl;

@property (weak, nonatomic) IBOutlet UILabel *courseLocationLbl;

@property (weak, nonatomic) IBOutlet UILabel *courseTimeLbl;

@property (weak, nonatomic) IBOutlet UILabel *feesLbl;
@property (weak, nonatomic) IBOutlet UILabel *feesText;

@property (weak, nonatomic) IBOutlet UILabel *discountFeesLbl;
@property (weak, nonatomic) IBOutlet UILabel *discountFeesText;

@property (weak, nonatomic) IBOutlet UILabel *suitAgeLbl;

@property (weak, nonatomic) IBOutlet UILabel *numberOfStudyLbl;

@property (weak, nonatomic) IBOutlet UIView *clearView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseDetailViewHeightConstraint;

@property (assign, nonatomic) CGFloat yPoint;


@property (assign, nonatomic) CGFloat courseDetailOriY;
@property (assign, nonatomic) CGFloat webViewOriHeight;
@property (assign, nonatomic) CGFloat webViewOriY;

@end

@implementation SPCourseDetailWebView

static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";

// 用于UIWebView保存图片
enum
{
    GESTURE_STATE_NONE = 0,
    GESTURE_STATE_START = 1,
    GESTURE_STATE_MOVE = 2,
    GESTURE_STATE_END = 4,
    GESTURE_STATE_ACTION = (GESTURE_STATE_START | GESTURE_STATE_END),
};

#pragma mark - 设置数据
- (void)setData:(SPCourseDetailVO *)vo
{
    SPCourseDetailDomain * domain = [SPCourseDetailDomain objectWithKeyValues:vo.data];
    
    self.courseNameLbl.text = domain.title;
    
    self.courseLocationLbl.text = domain.address;
    
    self.courseTimeLbl.text = domain.schedule;
    
    self.suitAgeLbl.text = vo.age_min_max;
    
    self.numberOfStudyLbl.text = [NSString stringWithFormat:@"%ld",(long)domain.ct_study_students];
    
    if (domain.fees == 0)
    {
        [self.feesLbl setHidden:YES];
        [self.feesText setHidden:YES];
        [self.discountFeesLbl setHidden:YES];
        [self.discountFeesText setHidden:YES];
        
        self.courseDetailViewHeightConstraint.constant -= 25;
    }
    else
    {
        self.feesLbl.text = [NSString stringWithFormat:@"%.2f",domain.fees];
    }
    
    if (domain.discountfees == 0)
    {
        [self.discountFeesLbl setHidden:YES];
        [self.discountFeesText setHidden:YES];
        
        self.courseDetailViewHeightConstraint.constant -= 10;
    }
    else
    {
        self.discountFeesLbl.text = [NSString stringWithFormat:@"%.2f",domain.discountfees];
    }
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:vo.obj_url]]];
    
    self.webView.scrollView.showsHorizontalScrollIndicator = YES;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    
}

- (void)awakeFromNib
{
    self.webView.delegate = self;
    
    self.webView.scrollView.scrollEnabled = NO;
    
    self.webView.scrollView.delegate = self;
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [self addGestureRecognizer:recognizer];
    
    UILongPressGestureRecognizer *longtapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longtap:)];
    
    [self addGestureRecognizer:longtapGesture];

}

#pragma mark - 手势触发方法
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown)
    {
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        if (self.yPoint > CGRectGetMaxY(self.courseDetailView.frame))
        {
            self.clearView.hidden = YES;
            self.sepViewNoOne.hidden = YES;

            
            self.courseDetailOriY = self.courseDetailView.frame.origin.y;
            self.webViewOriHeight = self.webView.frame.size.height;
            self.webViewOriY = self.webView.frame.origin.y;
            
            [UIView animateWithDuration:0.7 animations:^
            {
                self.courseDetailView.alpha = 0;
                [self.courseDetailView setOrigin:CGPointMake(0, -self.courseDetailView.frame.size.height)];
                [self.webView setFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT-(64+40+10+40))];
            }];
            
            self.webView.scrollView.scrollEnabled = YES;
        }
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
//        NSLog(@"swipe left");
    }

    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    {
//        NSLog(@"swipe right");
    }
}

- (void)setUpStarts:(NSInteger)intCount halfCount:(NSInteger)halfCount
{
    for (NSInteger i = 0; i < 5; i++)
    {
        for (UIButton * btn in self.starView.subviews)
        {
            if (btn.tag == i)
            {
                if (btn.tag < intCount)
                {
                    [btn setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
                }
                if (btn.tag == intCount)
                {
                    if (halfCount >= 5)
                    {
                        [btn setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
                    }
                    else if(halfCount > 0 && halfCount <5)
                    {
                        [btn setImage:[UIImage imageNamed:@"banekexing"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
                    }
                }
                if (btn.tag > intCount)
                {
                    [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
                }
            }
        }
    }
}

#pragma mark - scroll view代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    if(scrollView.contentOffset.y <= -80)
    {
        self.clearView.hidden = NO;
        self.sepViewNoOne.hidden = NO;

        [UIView animateWithDuration:0.5 animations:^
        {
            self.courseDetailView.alpha = 1;
            [self.courseDetailView setOrigin:CGPointMake(0, self.courseDetailOriY)];
            [self.webView setFrame:CGRectMake(0, self.webViewOriY, APPWINDOWWIDTH, self.webViewOriHeight)];
        }];
        self.webView.scrollView.scrollEnabled = NO;
    }
}

#pragma mark - 获取触摸点
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet * allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch * touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    int y = point.y;
    
    self.yPoint = y;
}



#pragma mark - 长按保存图片
// 功能：UIWebView响应长按事件
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[_request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"])
    {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            NSLog(@"you are touching!");
//            NSTimeInterval delaytime = 2;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                _gesState = GESTURE_STATE_START;
                NSLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
                _imgURL = nil;
                
                if ([tagName isEqualToString:@"IMG"])
                {
                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                }
//                if (_imgURL && longPress)
//                {
//                    _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
//                    longPress = NO;
//                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                _gesState = GESTURE_STATE_MOVE;
                NSLog(@"you are move");
            }
        }
        else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
            [_timer invalidate];
            _timer = nil;
            _gesState = GESTURE_STATE_END;
            NSLog(@"touch end");
        }
        return NO;
    }
    
    return YES;
}

- (void)handleLongTouch
{
//    NSLog(@"%@", _imgURL);
    if (_imgURL && _gesState == GESTURE_STATE_START)
    {
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"识别二维码图片", nil];
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        
        _gesState = GESTURE_STATE_END;
        
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

// 功能：保存图片到手机
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.numberOfButtons - 1 == buttonIndex)
    {
        return;
    }
    
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"识别二维码图片"])
    {
        if (_imgURL)
        {
//            NSLog(@"imgurl = %@", _imgURL);
        }
        
        NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:_imgURL];
//        NSLog(@"image url = %@", urlToSave);
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
        UIImage* image = [UIImage imageWithData:data];
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
//        NSLog(@"UIImageWriteToSavedPhotosAlbum = %@", urlToSave);
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

// 功能：显示对话框
-(void)showAlert:(NSString *)msg
{
//    NSLog(@"showAlert = %@", msg);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}

// 功能：显示图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error)
    {
        [self showAlert:@"出错了..."];
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        
        if (image)
        {
            [LBXScanWrapper recognizeImage:image success:^(NSArray<LBXScanResult *> *array)
            {
                [weakSelf scanResultWithArray:array];
            }];
        }
    }
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self showAlert:@"识别失败了！"];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array)
    {
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    NSLog(@"识别信息 : %@",strResult.imgScanned);
    NSLog(@"%@",strResult.strScanned);
    NSLog(@"%@",strResult.strBarCodeType);
    
    NSNotification * noti = [[NSNotification alloc] initWithName:@"erweima_web" object:strResult.strScanned userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

#pragma mark - 手势长按
- (void)longtap:(UILongPressGestureRecognizer * )longtapGes
{
    if (_imgURL)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self handleLongTouch];
        });
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 当iOS版本大于7时，向下移动20dp
    // 防止内存泄漏
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    // 响应touch事件，以及获得点击的坐标位置，用于保存图片
    [_webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
    
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}



@end
