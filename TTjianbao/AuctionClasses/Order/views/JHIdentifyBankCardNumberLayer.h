//
//  JHIdentifyBankCardNumberLayer.h
//  TTjianbao
//
//  Created by 张坤 on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^JHIdentifyBankCardNumberLayerBlock)(NSDictionary *dic);
@interface JHIdentifyBankCardNumberLayer : UIView
@property(nonatomic, copy) JHIdentifyBankCardNumberLayerBlock identifyBankCardNumberLayerBlock;
- (BOOL)canUserCamear;
- (void)show;
@end

NS_ASSUME_NONNULL_END
