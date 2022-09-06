//
//  JHRecycleOrderDetailAddressViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-地址ViewModel

#import "JHRecycleOrderDetailBaseViewModel.h"

static const CGFloat IconWidth = 24.0f;
static const CGFloat AddressLeftSpace = 12.0f;
static const CGFloat AddressFontSize = 14.0f;
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailAddressViewModel : JHRecycleOrderDetailBaseViewModel
/// 地址信息
@property (nonatomic, copy) NSString *addressText;
/// 用户信息
@property (nonatomic, copy) NSString *userText;

- (void)setupWithUserName : (NSString *)name phone : (NSString *)phone;
@end

NS_ASSUME_NONNULL_END
