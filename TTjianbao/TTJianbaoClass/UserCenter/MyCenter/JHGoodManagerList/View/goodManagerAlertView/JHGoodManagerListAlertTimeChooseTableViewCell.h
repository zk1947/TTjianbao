//
//  JHGoodManagerListAlertTimeChooseTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/8/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodManagerListAlertTimeChooseTableViewCell : UITableViewCell
@property (nonatomic, copy) dispatch_block_t putOnNowBlock;
@property (nonatomic, copy) dispatch_block_t putOnwithTimeBlock;

- (void)setViewModel:(NSDictionary *)viewModel;
@end

NS_ASSUME_NONNULL_END
