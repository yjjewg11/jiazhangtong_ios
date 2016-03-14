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
}

- (IBAction)myCollection:(UIButton *)sender {
    self.pushCollege();
}

- (IBAction)photoAlbumInfo:(UIButton *)sender {
    self.pushAlbunInfo();
}
@end
