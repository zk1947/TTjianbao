//
//  JHCelebrateHeaderView.h
//  TTjianbao
//  Description: 周年庆-header
//  Created by Jesse on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSUInteger, JHCelebrateButtonType)
{
    JHCelebrateButtonTypeCoupon,
    JHCelebrateButtonTypeRedpacket,
    JHCelebrateButtonTypeBill,
    JHCelebrateButtonTypeResaleStone,
    JHCelebrateButtonTypeMallOne,
    JHCelebrateButtonTypeMallTwo,
    JHCelebrateButtonTypeMallThree,
};

@protocol JHCelebrateHeaderViewDelegate <NSObject>

- (void)clickButtonResponse:(NSInteger)buttonTag;

@end

NS_ASSUME_NONNULL_BEGIN

@interface JHCelebrateHeaderView : BaseView

@property (nonatomic, weak) id <JHCelebrateHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
