//
//  JHCustomizeAddProgramCategoryTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeAddProgramCategoryTableViewCell : UITableViewCell
@property (nonatomic, copy) dispatch_block_t cagetoryChooseBlock;
@property (nonatomic, copy) void(^cagetoryHasString)(BOOL has);
- (void)setViewModel:(id)viewModel;
- (BOOL)checkValue;
- (NSString *)getCagetoryValue;
@end

NS_ASSUME_NONNULL_END
