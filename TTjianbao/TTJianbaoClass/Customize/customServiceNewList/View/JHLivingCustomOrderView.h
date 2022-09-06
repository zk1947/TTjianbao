//
//  JHLivingCustomOrderView.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLivingCustomOrderView : BaseView <JXPagerViewListViewDelegate>
@property(strong,nonatomic) NSString *status;
@property (nonatomic, copy) void(^selectBlock)(NSString *orderId);
@end

NS_ASSUME_NONNULL_END
