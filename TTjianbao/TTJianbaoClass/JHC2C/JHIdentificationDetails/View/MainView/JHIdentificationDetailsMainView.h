//
//  JHIdentificationDetailsMainView.h
//  TTjianbao
//
//  Created by miao on 2021/6/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JHJHIdentificationDetailsDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface JHIdentificationDetailsMainView : UIView

/// controller  的交互事件
@property (nonatomic, weak) id<JHJHIdentificationDetailsDelegate> delegate;

- (instancetype)initWithRecordInfoId:(NSInteger)recordInfoId;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;


@end

NS_ASSUME_NONNULL_END
