//
//  BaseReplyListTableViewCell.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/3.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReFreshBaseCell.h"
#import "MLEmojiLabel.h"
#import "BaseReplyDomain.h"

@protocol BaseReplyListDataSoruceDelegate <NSObject>

- (void)baseReply_delete:(NSString *)newsuid;


@end

@interface BaseReplyListTableViewCell : ReFreshBaseCell
{
    
    IBOutlet UIImageView * headImageView;
    IBOutlet UILabel * timeLabel;
    IBOutlet UILabel * titleLabel;
    IBOutlet MLEmojiLabel * messageLabel;
    BaseReplyDomain * baseReplyDomain;
    IBOutlet UIButton *dzBtn;
    
}
@property (nonatomic, retain) id<BaseReplyListDataSoruceDelegate> delegate;

- (void)resetValue:(id)baseDomain parame:(NSMutableDictionary *)parameterDic;

@end
