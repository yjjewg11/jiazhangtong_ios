//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"
#import "SDWebImageManager.h"
#import "KGEmojiManage.h"
#import "EmojiDomain.h"
#import "UIButton+Extension.h"


#define FACE_COUNT_ROW  4

#define FACE_COUNT_CLU  7

#define FACE_ICON_SIZE  44

@implementation FaceBoard
@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, 216)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
//        self.backgroundColor = [UIColor brownColor];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        if ([[languages objectAtIndex:0] hasPrefix:@"zh"]) {
            _faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_ch" ofType:@"plist"]];
        } else {
            _faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_en" ofType:@"plist"]];
        }
       
        NSArray * emojiArray = [KGEmojiManage sharedManage].emojiArray;
        
        NSMutableArray * array = [[NSMutableArray alloc] initWithArray:emojiArray];
        [array addObjectsFromArray:emojiArray];
        [array addObjectsFromArray:emojiArray];
        
        NSInteger FACE_COUNT_ALL = [array count];
        NSInteger pageSize = FACE_COUNT_ROW * FACE_COUNT_CLU;
        CGFloat faceViewH = 190;
        
        NSInteger pageCount = (FACE_COUNT_ALL + pageSize - 1) / pageSize;
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, faceViewH)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake(pageCount*KGSCREEN.size.width, faceViewH);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        EmojiDomain * emojiDomain = nil;
        
        UIButton * faceButton = nil;
    
        CGFloat btnWH = 44;
        CGFloat spliteX = (KGSCREEN.size.width-(7*btnWH)) / 8;
        CGFloat spliteY = (faceViewH - (4*btnWH)) / 5;
        CGFloat x = spliteX;
        CGFloat y = spliteY;
        CGFloat cell = 0;
        CGFloat row  = 0;
        CGFloat page = 0;
       
        
        for (int i = 0; i<[array count]; i++) {
            emojiDomain = [array objectAtIndex:i];
            
            x = spliteX + (btnWH*cell) + (spliteX*cell) + (page*KGSCREEN.size.width);
            
            if(cell == 7) {
                cell = 0;
                row++;
                x = spliteX + (page*KGSCREEN.size.width);
                y = spliteY + (btnWH*row) + (spliteY*row);
            }
            
            if(i/pageSize>0 && i%pageSize==0) {
                page++;
                x = spliteX + (page*KGSCREEN.size.width);
                y = spliteY;
                row = 0;
                cell = 0;
            }
            
            faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            faceButton.frame = CGRectMake(x, y, btnWH, btnWH);
            faceButton.targetObj = emojiDomain;
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:emojiDomain.descriptionUrl] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                [faceButton setImage:image forState:UIControlStateNormal];
                
            }];
            
            
            [faceView addSubview:faceButton];
            
            cell++;
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(110, faceViewH, 100, 20)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = [emojiArray count]/28+1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"backFace"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"backFaceSelect"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(270, 185, 38, 27);
        [self addSubview:back];
        
    }
    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [facePageControl setCurrentPage:faceView.contentOffset.x / KGSCREEN.size.width];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * KGSCREEN.size.width, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(UIButton *)sender {
    EmojiDomain * domain = (EmojiDomain *)sender.targetObj;
    NSString * emojiStr = [NSString stringWithFormat:@"[%@]", domain.datavalue];
    if (self.inputTextField) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
        [faceString appendString:emojiStr];
        self.inputTextField.text = faceString;
    }
    if (self.inputTextView) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString appendString:emojiStr];
        self.inputTextView.text = faceString;
    }
    
    if(_FaceBoardInputedBlock) {
        _FaceBoardInputedBlock(emojiStr);
    }
}


- (void)backFace{
    NSString *inputString;
    inputString = self.inputTextField.text;
    if (self.inputTextView) {
        inputString = self.inputTextView.text;
    }
    
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound){
                string = [inputString substringToIndex:stringLength - 1];
            } else {
                NSRange rang = [inputString rangeOfString:@"[" options:NSBackwardsSearch];
                string = [inputString substringToIndex:rang.location];
            }
        } else {
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    self.inputTextField.text = string;
    self.inputTextView.text = string;
}

@end
