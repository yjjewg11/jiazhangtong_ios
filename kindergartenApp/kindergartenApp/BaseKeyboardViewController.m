//
//  BaseKeyboardViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"
#import "KGHUD.h"
#import "KGTextField.h"
#import "KGEmojiManage.h"

CGFloat const gestureMinimumTranslation = 20.0;

typedef enum : NSInteger {
    kCameraMoveDirectionNone,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft
} CameraMoveDirection;

@interface BaseKeyboardViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>  {
    CameraMoveDirection direction;
}

@end

@implementation BaseKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    [self addGestureBtn];
    
    textFieldMArray = [[NSMutableArray alloc] init];
    [self addTextFieldToMArray];
    [self registerMessageListen];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (_flag) {
        [_keyBoardController addKeyBoardNotification];
    }
    _flag = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_keyBoardController removeKeyBoardNotification];
}

//滑动手势
- (void)addSwipeGesture {
    UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
}


//添加手势
- (void)addGestureBtn {
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    singleTapGesture.delegate = self;
    singleTapGesture.numberOfTapsRequired = Number_One;
    singleTapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGesture];
}

//单击手势响应
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITextField class]] ||
        [touch.view.superview isKindOfClass:[UITextView class]] ||
        [touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[UIScrollView class]])
        return NO;
    return YES;
}

//单击响应
- (void)singleTap{
    [KGEmojiManage sharedManage].isSwitchEmoji = NO;
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


/**
 *  注册消息监听者
 */
- (void)registerMessageListen{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotification:) name:Key_Notification_Message object:nil];
}


/**
 *  消息监听通知
 *
 *  @param notification notification description
 */
- (void)messageNotification:(NSNotification *)notification{
    NSDictionary * dic = [notification userInfo];
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    [[KGHUD sharedHud] show:window onlyMsg:[dic objectForKey:Key_Notification_MessageText]];
}


/**
 *  添加输入框到array统一管理验证
 */
- (void)addTextFieldToMArray {
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return range.location<11?YES:NO;
}



/**
 *  验证所有输入框
 *
 *  @return 返回是否验证通过
 */
- (BOOL)validateInputInView {
    BOOL judge = YES;
    KGTextField * tf = nil;
    for(NSInteger i=Number_Zero; i<[textFieldMArray count]; i++){
        tf = [textFieldMArray objectAtIndex:i];
        if(![tf verifyTextField]){
            judge = NO;
            [tf becomeFirstResponder];
            break;
        }
    }
    return judge;
}



- (void)notificationMessage:(NSString *)msgStr {
    NSDictionary * dic = [NSDictionary dictionaryWithObject:msgStr forKey:Key_Notification_MessageText];
    [[NSNotificationCenter defaultCenter]postNotificationName:Key_Notification_Message object:self userInfo:dic];
}


- (void)handleSwipe:(UIPanGestureRecognizer*)gesture {
    
    CGPoint translation = [gesture translationInView:self.view];
    
    if(gesture.state == UIGestureRecognizerStateBegan) {
        direction = kCameraMoveDirectionNone;
    } else if(gesture.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone) {
        
        [self determineCameraDirectionIfNeeded:translation gesture:gesture];
        
        // ok, now initiate movement in the direction indicated by the user's gesture
//        switch (direction) {
//            case kCameraMoveDirectionDown:
//                [self singleTap];
//                break;
//            case kCameraMoveDirectionUp:
//                break;
//            case kCameraMoveDirectionRight:
//                break;
//            case kCameraMoveDirectionLeft:
//                break;
//            default:
//                break;
//        }
    } else if(gesture.state == UIGestureRecognizerStateEnded) {
        // now tell the camera to stop
        
    }
}


// This method will determine whether the direction of the user's swipe
- (void)determineCameraDirectionIfNeeded:(CGPoint)translation gesture:(UIPanGestureRecognizer*)gesture {
    
    if(direction != kCameraMoveDirectionNone) {
//        return direction;
    }
    
    // determine if horizontal swipe only if you meet some minimum velocity
    if(fabs(translation.x) > gestureMinimumTranslation) {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0) {
            gestureHorizontal = YES;
        } else {
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0);
        }
        
        if (gestureHorizontal) {
            
            [self didChangeViewX:translation.x gesture:gesture];
            
            if (translation.x > 0.0) {
//                return kCameraMoveDirectionRight;
            } else {
//                return kCameraMoveDirectionLeft;
            }
        }
    }
    
    // determine if vertical swipe only if you meet some minimum velocity
    
    else if(fabs(translation.y) > gestureMinimumTranslation) {
        
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0) {
            gestureVertical = YES;
        } else {
            gestureVertical = (fabs(translation.y / translation.x) > 5.0);
        }
        
        if(gestureVertical) {
            
//            if (translation.y > 0.0)
            
//                return kCameraMoveDirectionDown;
            
//            else
                
//                return kCameraMoveDirectionUp;
        }
    }
    
//    return direction;
}

//水平手势x值发生改变
- (void)didChangeViewX:(CGFloat)x gesture:(UIPanGestureRecognizer*)gesture {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
