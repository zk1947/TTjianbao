//
//  JHMakeRedpacketView.h
//  TTjianbao
//  Description:创建红包view
//  Created by Jesse on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHMakeRedpacketPageModel;

@protocol JHMakeRedpacketViewDelegate <NSObject>

- (void)chargeMoneyIntoRedpacket:(id)model;

@end

@interface JHMakeRedpacketView : UIView

@property (nonatomic, weak) id <JHMakeRedpacketViewDelegate>delegate;

- (instancetype)initWithDelegate:(id)aDelegate;
- (void)refreshView:(JHMakeRedpacketPageModel*)model;
- (void)drawSubview;

@end

NS_ASSUME_NONNULL_END
