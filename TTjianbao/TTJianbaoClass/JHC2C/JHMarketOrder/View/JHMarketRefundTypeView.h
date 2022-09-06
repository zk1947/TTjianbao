//
//  JHMarketRefundTypeView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketRefundTypeView : BaseView
@property (nonatomic, copy)void(^selectCompleteBlock)(NSString *message, NSInteger typeIndex);
@end

NS_ASSUME_NONNULL_END
