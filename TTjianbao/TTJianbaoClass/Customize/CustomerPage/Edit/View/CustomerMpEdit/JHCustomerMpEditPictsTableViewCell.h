//
//  JHCustomerMpEditPictsTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^customerMpEditAddPictsBlock) (void);
typedef void (^customerMpEditDeletePictsBlock) (NSInteger index);
@interface JHCustomerMpEditPictsTableViewCell : UITableViewCell
@property (nonatomic, copy) customerMpEditAddPictsBlock     addBlock;
@property (nonatomic, copy) customerMpEditDeletePictsBlock  deleteBlock;
- (void)setViewModel:(id)viewModel;
@end

NS_ASSUME_NONNULL_END
