//
//  JHCustomerAddCommentPicsTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^customerAddCommentPictsBlock) (void);
typedef void (^customerAddCommentDeletePictsBlock) (NSInteger index);

@interface JHCustomerAddCommentPicsTableViewCell : UITableViewCell
@property (nonatomic, copy) customerAddCommentPictsBlock        addBlock;
@property (nonatomic, copy) customerAddCommentDeletePictsBlock  deleteBlock;
- (void)setViewModel:(id)viewModel;

@end


NS_ASSUME_NONNULL_END
