//
//  AlertSaveFFMoiveTitleView.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/21.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "AlertSaveFFMoiveTitleView.h"

@interface AlertSaveFFMoiveTitleView ()<UITextFieldDelegate>

@end


@implementation AlertSaveFFMoiveTitleView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)touchinside_check1:(id)sender {
    self.status=@"0";
      [self updateViewShow];
}

- (IBAction)tochinside_check2:(id)sender {
    self.status=@"1";
      [self updateViewShow];
}
-(void)setTitleAndStatus:(NSString *)title status:(NSString *) status{
    
    self.title_tf.delegate=self;
    self.title=title;
    self.status=status;
    
    self.title_tf.text=title;
    [self updateViewShow];
}
-(void)updateViewShow{
    if(self.status==0){
        [self.imgCheck1 setHidden:NO];
        [self.imgCheck2 setHidden:YES];
        
    }else{
        [self.imgCheck2 setHidden:NO];
        [self.imgCheck1 setHidden:YES];
        
    }
}
- (IBAction)touchInside_cancel:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)touchInside_Ok:(id)sender {
    self.title=self.title_tf.text;
    self.okBtn();
}


@end
