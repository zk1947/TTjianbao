//
//  JHLotterAddAddressAlert.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseWhiteViewAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotterAddAddressAlert : JHBaseWhiteViewAlert

/// 0元抽添加地址
/// @param price 市场价
/// @param clickBlock 添加地址回调
+ (void)showLotterAddAddressAlertWithImageUrl:(NSString *)url
                                        title:(NSString *)title
                                     btnTitle:(NSString *)btnTitle
                                        price:(NSString *)price
                                    prizeName:(NSString *)prizeName
                              blockClickBlock:(dispatch_block_t)clickBlock;

@end

NS_ASSUME_NONNULL_END
