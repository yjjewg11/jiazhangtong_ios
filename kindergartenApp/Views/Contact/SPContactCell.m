//
//  SPContactCell.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/13.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPContactCell.h"

@interface SPContactCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelCenterYConstraint;


@end

@implementation SPContactCell

- (void)awakeFromNib {
    // Initialization code
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.frame) * 0.5;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)configureWithAvatar:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle {
    self.avatarImageView.image = image;
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;

    UILayoutPriority titleLabelCenterYLayoutPriority;
    if (subtitle.length == 0) {
        titleLabelCenterYLayoutPriority = UILayoutPriorityDefaultHigh + 100;
        self.subtitleLabel.hidden = YES;
    }
    else {
        titleLabelCenterYLayoutPriority = UILayoutPriorityDefaultLow;
        self.subtitleLabel.hidden = NO;
    }
    if (self.titleLabelCenterYConstraint.priority != titleLabelCenterYLayoutPriority) {
        self.titleLabelCenterYConstraint.priority = titleLabelCenterYLayoutPriority;
        [self setNeedsLayout];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
