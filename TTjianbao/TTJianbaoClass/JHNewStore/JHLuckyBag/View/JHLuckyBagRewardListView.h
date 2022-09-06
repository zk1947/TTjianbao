//
//  JHLuckyBagRewardListView.h
//  TTjianbao
//
//  Created by zk on 2021/11/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLuckyBagRewardListView : UIView

@property (nonatomic, assign) BOOL isOnAlert;//yes-JHLuckyBagView 和 no-JHLuckyBagRewardVC 共用

@property (nonatomic, assign) NSInteger pageIndex;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END
