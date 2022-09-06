//
//  JHLotteryHomeInfoView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHLotteryActivityData;

@interface JHLotteryHomeInfoView : UIView


/// 0-未参与  1-参与未分享  2-分享未助力 3-分享满 4-提醒(开启，关闭)
@property (nonatomic, copy) void (^buttonClickBlock) (NSInteger type);

/// 0-未参与  1-参与未分享  2-分享未助力 3-分享满 4-提醒(开启，关闭)
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) JHLotteryActivityData *model;

///倒计时结束
@property (nonatomic, copy) dispatch_block_t finshBlock;

@end

NS_ASSUME_NONNULL_END
