//
//  JHGoodManagerListNavView.h
//  TTjianbao
//
//  Created by user on 2021/7/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGoodManagerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodManagerListNavView : UIView
@property (nonatomic,   copy) dispatch_block_t backBlock;
@property (nonatomic,   copy) dispatch_block_t channelBlock;
@property (nonatomic, assign) BOOL isAuction;
- (void)setViewModel:(NSArray<JHGoodManagerListTabChooseModel *> *)viewModel;
@end

NS_ASSUME_NONNULL_END
