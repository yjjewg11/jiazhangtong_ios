//
//  FPHomeSonView.m
//  kindergartenApp
//
//  Created by Mac on 16/1/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeSonView.h"
#import "FPUploadVC.h"
@interface FPHomeSonView()
- (IBAction)upLoadBtn:(UIButton *)sender;

- (IBAction)myCollection:(UIButton *)sender;

- (IBAction)photoAlbumInfo:(UIButton *)sender;


@end

@implementation FPHomeSonView



- (IBAction)upLoadBtn:(UIButton *)sender {
    self.pushUpLoad();
    [self setHidden:YES];
}

- (IBAction)myCollection:(UIButton *)sender {
    self.pushCollege();
     [self setHidden:YES];
}

- (IBAction)photoAlbumInfo:(UIButton *)sender {
    self.pushAlbunInfo();
     [self setHidden:YES];
}
@end
