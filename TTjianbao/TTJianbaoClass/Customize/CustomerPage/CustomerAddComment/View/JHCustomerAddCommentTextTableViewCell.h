//
//  JHCustomerAddCommentTextTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHCustomerAddCommentTextTableViewCell;
@protocol TextViewCellDelegate
- (void)textViewCell:(JHCustomerAddCommentTextTableViewCell *)cell didChangeText:(NSString *)text;
@end

typedef void (^customerAddCommentTextEndEditingBlock) (void);
typedef void (^customerAddCommentTextUpdateHeightBlock) (void);
@interface JHCustomerAddCommentTextTableViewCell : UITableViewCell
@property (nonatomic,   copy) customerAddCommentTextEndEditingBlock   textBlock;
@property (nonatomic,   copy) customerAddCommentTextUpdateHeightBlock updateBlock;
@property (nonatomic, strong) UITextView                             *textView;
@property (nonatomic,   weak) id                                      delegate;

@end

NS_ASSUME_NONNULL_END
