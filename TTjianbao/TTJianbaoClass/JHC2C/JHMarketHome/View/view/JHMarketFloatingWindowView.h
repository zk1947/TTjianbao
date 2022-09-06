//
//  JHMarketFloatingWindowView.h
//  TTjianbao
//
//  Created by zk on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MarketFloatingBlock)(NSInteger index);

@interface JHMarketFloatingWindowView : UIView

/// 设置收藏数和竞拍状态
/// @param collectNum 收藏数 0-隐藏收藏入口
/// @param auctionStatus 竞拍状态 0-隐藏竞拍入口 1-出价 2-出局 3-领先 4-中拍
- (void)setCollectNum:(int)collectNum auctionStatus:(int)auctionStatus;

@property (nonatomic,   copy) MarketFloatingBlock marketFloatBlock;

- (void)hiddenAddButton;

@end

NS_ASSUME_NONNULL_END
