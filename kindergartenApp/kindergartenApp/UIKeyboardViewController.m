//
//  UIKeyboardViewController.m
// 
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import "UIKeyboardViewController.h"
#import "SystemResource.h"
#import "AppDelegate.h"
#import "KGTextField.h"

//static CGFloat kboardHeight = 254.0f;
//static CGFloat spacerY = 10.0f;
static CGFloat spacerY = 0.0f;
static CGFloat viewFrameY = 10;


@interface UIKeyboardViewController () 

- (void)animateView:(BOOL)isShow textField:(id)textField heightforkeyboard:(CGFloat)kheight;
- (void)addKeyBoardNotification;
//- (void)checkBarButton:(id)textField;
- (id)firstResponder:(UIView *)navView;
- (NSArray *)allSubviews:(UIView *)theView;
- (void)resignKeyboard:(UIView *)resignView;

@end

@implementation UIKeyboardViewController

@synthesize boardDelegate = _boardDelegate;

//监听键盘隐藏和显示事件
- (void)addKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}

//注销监听事件
- (void)removeKeyBoardNotification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//计算当前键盘的高度
-(void)keyboardWillShowOrHide:(NSNotification *)notification {
	CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    kboardHeight = kbSize.height;
	BOOL isShow = [[notification name] isEqualToString:UIKeyboardWillShowNotification] ? YES : NO;
	if ([self firstResponder:objectView]) {
		[self animateView:isShow textField:[self firstResponder:objectView]
		heightforkeyboard:kboardHeight];
	}
}

//输入框上移防止键盘遮挡
- (void)animateView:(BOOL)isShow textField:(id)textField heightforkeyboard:(CGFloat)kheight {
	CGRect rect = objectView.frame;
	
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	if (isShow) {
		if ([textField isKindOfClass:[UITextField class]]) {
			UITextField *newText = ((UITextField *)textField);
			CGPoint textPoint = [newText convertPoint:CGPointMake(0, newText.frame.size.height + spacerY) toView:objectView];
            
            if (rect.size.height - textPoint.y < kheight) {
                
                
                CGFloat height = rect.size.height;
                CGFloat y = height - textPoint.y - kheight + viewFrameY;
                
                CGFloat h2 = height - (height + y);
                if(h2 > kheight) {
                    y -= kheight-h2;
                }
                
                rect.origin.y = y;
            } else {
                rect.origin.y = viewFrameY;
            }
            
		}
		else {
			UITextView *newView = ((UITextView *)textField);
			CGPoint textPoint = [newView convertPoint:CGPointMake(0, newView.frame.size.height + spacerY) toView:objectView];
			if (rect.size.height - textPoint.y < kheight) 
				rect.origin.y = rect.size.height - textPoint.y - kheight + viewFrameY;
			else rect.origin.y = viewFrameY;
		}
    } else {
        rect.origin.y = viewFrameY;
    }
	objectView.frame = rect;
    [UIView commitAnimations];
}

//输入框获得焦点
- (id)firstResponder:(UIView *)navView {
	for (id aview in [self allSubviews:navView]) {
		if ([aview isKindOfClass:[UITextField class]] && [(UITextField *)aview isFirstResponder]) {
			return (UITextField *)aview;
		}
		else if ([aview isKindOfClass:[UITextView class]] && [(UITextView *)aview isFirstResponder]) {
			return (UITextView *)aview;
		}
	}
	return nil;
}

//找出所有的subview
- (NSArray *)allSubviews:(UIView *)theView {
	NSArray *results = [theView subviews];
	for (UIView *eachView in [theView subviews]) {
		NSArray *riz = [self allSubviews:eachView];
		if (riz) {
			results = [results arrayByAddingObjectsFromArray:riz];
		}
	}
	return results;
}

//输入框失去焦点，隐藏键盘
- (void)resignKeyboard:(UIView *)resignView {
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


//光标移动
- (void)firstResponderMove:(NSInteger)type{
   for (int i = 0; i < [allInputFields count]; i++) {
		id textField = [allInputFields objectAtIndex:i];
		if ([textField isKindOfClass:[UITextField class]]) {
			textField = ((UITextField *)textField);
		}
		else {
			textField = ((UITextView *)textField);
		}
		if ([textField isFirstResponder]) {
			if (type == 1) {
				if (i > 0) {
					[[allInputFields objectAtIndex:--i] becomeFirstResponder];
					[self animateView:YES textField:[allInputFields objectAtIndex:i] heightforkeyboard:kboardHeight];
				}
			}
			else if (type == 2) {
				if (i < [allInputFields count] - 1) {
					[[allInputFields objectAtIndex:++i] becomeFirstResponder];
					[self animateView:YES textField:[allInputFields objectAtIndex:i] heightforkeyboard:kboardHeight];
				}else if(i == [allInputFields count] - 1){
                    [self resignKeyboard:objectView];
                }
			}
		}
	}
	if (type == 3)
		[self resignKeyboard:objectView];
}

#pragma mark - TextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
//	[self checkBarButton:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	[textField resignFirstResponder];
    [self firstResponderMove:2];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([self.boardDelegate respondsToSelector:@selector(alttextFieldDidEndEditing:)]) {
		[self.boardDelegate alttextFieldDidEndEditing:textField];
	}
}

//判断是否是纯字母
-(BOOL)pureLetters:(NSString*)str{
    for(int i=0;i<str.length;i++){
        unichar c=[str characterAtIndex:i];
        if((c<'A'||c>'Z')&&(c<'a'||c>'z'))
            return NO;
    }
    return YES;
    
}

#pragma mark - UITextView delegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location >= Number_Hundred_Forty)
    {
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
        if ( [lang isEqualToString:@"zh-Hans"]&&[self pureLetters:text])
            return YES;
        else
            return NO;
    }
    else{
        return YES;
    }
    
	if ([text isEqualToString:@"\n"]) {
        [self firstResponderMove:2];
		return NO;
	}
	return YES;
}


//next

@end

@implementation UIKeyboardViewController (UIKeyboardViewControllerCreation)

- (id)initWithControllerDelegate:(id <UIKeyboardViewControllerDelegate>)delegateObject {
	if (self = [super init]) {
		self.boardDelegate = delegateObject;
        if ([self.boardDelegate isKindOfClass:[UIViewController class]]) {
			objectView = [(UIViewController *)[self boardDelegate] view];
		}
		else if ([self.boardDelegate isKindOfClass:[UIView class]]) {
			objectView = (UIView *)[self boardDelegate];
		}
        viewFrameY = objectView.frame.origin.y;
		[self addKeyBoardNotification];
        [self buildDelegate];
	}
	return self;
}

- (void)buildDelegate{
    if(!allInputFields){
        allInputFields =[[NSMutableArray alloc] init];
    }
    for (id aview in [self allSubviews:objectView]) {
        
//        NSLog(@"class:%@", [aview class]);
        
		if (([aview isKindOfClass:[UITextField class]] && ((UITextField*)aview).userInteractionEnabled && ((UITextField*)aview).enabled) ||
            [aview isKindOfClass:[KGTextField class]]) {
			((UITextField *)aview).delegate = self;
            [allInputFields addObject:(UITextField *)aview];
		}
		else if ([aview isKindOfClass:[UITextView class]] && ((UITextView*)aview).userInteractionEnabled && ((UITextView*)aview).editable) {
			((UITextView *)aview).delegate = self;
            [allInputFields addObject:(UITextView *)aview];
		}
	}
}

@end
