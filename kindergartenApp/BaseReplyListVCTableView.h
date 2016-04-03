//
//  BaseReplyListVCTableViewController.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/1.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseReplyListVCTableViewDelegate <NSObject>

- (CGPoint)callBackSaveContent:(NSString *)replyText;


@end
@interface BaseReplyListVCTableView : UIView
@property (strong,nonatomic) NSString *rel_uuid;
@property (nonatomic)  KGTopicType type;
@property (nonatomic, retain) UIViewController *superVC;
@property (nonatomic, retain) id<BaseReplyListVCTableViewDelegate> delegate;
//必须设置关联uuid和type
- (void)setBaseReplyData:(NSString *)rel_uuid type:(KGTopicType)type;

- (id)initWithSuperVC:(UIViewController *)superVC;
- (void)headerRereshing;
@end
