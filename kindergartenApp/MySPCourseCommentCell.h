//
//  MySPCourseCommentCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/16.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySPCommentDomain.h"

@protocol  MySPCourseCommentCellDelegate<NSObject>

- (void)saveCommentText:(NSString *)content;

@end

@interface MySPCourseCommentCell : UITableViewCell

- (void)setData:(MySPCommentDomain *)commentDomain;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (strong, nonatomic) NSString * userscore;

@property (strong, nonatomic) NSString * content;

@property (strong, nonatomic) NSString * extuuid;

- (void)initNoCommentData;

@property (weak, nonatomic) id<MySPCourseCommentCellDelegate> delegate;

@end
