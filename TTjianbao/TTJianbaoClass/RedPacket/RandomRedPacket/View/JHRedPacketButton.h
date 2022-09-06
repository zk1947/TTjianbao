//
//  JHRedPacketButton.h
//  TTjianbao
//
//  Created by apple on 2020/1/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRedPacketButton : UIView

///红包总数
@property (nonatomic, assign) NSInteger redPacketNum;

///倒计时（秒）
@property (nonatomic, assign) long timeNum;

+ (CGSize)viewSize;

- (void)starAnimation;

-(void)stopRemoveAllAnimation;

@end

NS_ASSUME_NONNULL_END
