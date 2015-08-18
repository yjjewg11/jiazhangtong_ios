//
//  EmojiAndTextView.h
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/17.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGTextView.h"
#import "KGEmojiManage.h"
#import "FaceBoard.h"

typedef void(^ButtonPressed)(UIButton *);

@interface EmojiAndTextView : UIView

@property (strong, nonatomic) IBOutlet KGTextView *contentTextView;
@property (strong, nonatomic) ButtonPressed pressedBlock;
@property (strong, nonatomic) FaceBoard * faceBoard;

@end
