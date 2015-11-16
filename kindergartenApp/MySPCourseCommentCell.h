//
//  MySPCourseCommentCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/16.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySPCommentDomain.h"

@interface MySPCourseCommentCell : UITableViewCell

- (void)setData:(MySPCommentDomain *)commentDomain;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
