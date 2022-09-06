//
//  JHLotteryDetailInfoView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLotteryActivityDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryDetailInfoView : UIView

@property (nonatomic, copy) dispatch_block_t addAddressBlock;

@property (nonatomic, strong) JHLotteryActivityDetailModel *model;

@end

NS_ASSUME_NONNULL_END
