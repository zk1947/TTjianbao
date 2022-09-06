//
//  JHRedPacketDetailHeader.h
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 红包详情头
@interface JHRedPacketDetailHeader : UIImageView

@property (nonatomic, copy) dispatch_block_t balanceClickBlock;

- (void)setWishes:(NSString *)wishes price:(CGFloat)price avavtorUrl:(NSString *)avavtorUrl name:(NSString *)name descStr:(NSString *)descStr;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
