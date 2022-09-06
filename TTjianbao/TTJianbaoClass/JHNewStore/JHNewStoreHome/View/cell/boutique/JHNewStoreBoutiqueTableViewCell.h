//
//  JHNewStoreBoutiqueTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHNewStoreHomeShareInfoModel;
@interface JHNewStoreBoutiqueTableViewCell : UITableViewCell
@property (nonatomic,   copy) void(^shareBlock)(JHNewStoreHomeShareInfoModel *model);
@property (nonatomic,   copy) dispatch_block_t bouClickBlock;
@property (nonatomic, assign) BOOL isFirstCell;
- (void)setViewModel:(id)viewModel;
- (void)reloadBuyBtnMess:(BOOL)hasRemind;
@end

NS_ASSUME_NONNULL_END
