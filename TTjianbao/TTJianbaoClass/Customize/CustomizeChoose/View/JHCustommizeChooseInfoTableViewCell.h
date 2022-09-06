//
//  JHCustommizeChooseInfoTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/11/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustommizeChooseInfoTableViewCell : UITableViewCell
@property (nonatomic, copy) dispatch_block_t showAllAction;
@property (nonatomic, copy) dispatch_block_t applyBtnAction;
@property (nonatomic, copy) dispatch_block_t iconClickAction;
@property (nonatomic, copy) dispatch_block_t opusListClickAction;
- (void)setViewModel:(id)viewModel;
@end

NS_ASSUME_NONNULL_END
