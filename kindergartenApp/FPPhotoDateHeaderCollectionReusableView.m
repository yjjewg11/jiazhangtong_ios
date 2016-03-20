//
//  FPPhotoDateHeaderCollectionReusableView.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/17.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPPhotoDateHeaderCollectionReusableView.h"
@interface FPPhotoDateHeaderCollectionReusableView()



@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@property (weak, nonatomic) IBOutlet UILabel *total;

@end
@implementation FPPhotoDateHeaderCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
}
- (void)setDateAndCount:(NSArray *)strArr
{    self.dateLbl.text = strArr[0];
    self.total.text = [NSString stringWithFormat:@"共%@张",strArr[1]];
}
@end
