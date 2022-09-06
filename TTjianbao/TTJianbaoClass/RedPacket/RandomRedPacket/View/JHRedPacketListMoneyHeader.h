//
//  JHRedPacketListMoneyHeader.h
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 红包弹层用户信息头
@interface JHRedPacketListMoneyHeader : UIImageView

- (void)setTitle:(NSString *)title price:(CGFloat)price;

@end

NS_ASSUME_NONNULL_END
