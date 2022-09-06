//
//  JHMarketScrollAnimationView.h
//  ZkDemoAll
//
//  Created by 赵凯 on 2021/5/30.
//  Copyright © 2021 赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMarketHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MarketScrollAnimationDelegate <NSObject>
- (void)changeScrollViewHeight:(CGFloat)scrollH;
- (void)scrollCategroyTouchEvent:(NSInteger)categroyIndex;
@end

@interface JHMarketScrollAnimationView : UIView

@property (nonatomic, weak) id <MarketScrollAnimationDelegate>animationDelegate;

@property (nonatomic, copy) NSArray <JHMarketHomeKingKongItemModel *>*resourceArray;

@property (nonatomic, assign) NSInteger pageIndex;

- (CGFloat)getScrollViewPageOneHeight;
- (CGFloat)getScrollViewPageTowHeight;
- (CGFloat)getScrollViewAddHeight;

@end

NS_ASSUME_NONNULL_END
