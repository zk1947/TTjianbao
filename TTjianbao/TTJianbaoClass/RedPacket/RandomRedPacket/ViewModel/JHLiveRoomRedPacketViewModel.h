//
//  JHLiveRoomRedPacketViewModel.h
//  TTjianbao
//
//  Created by yaoyao on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRoomRedPacketModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRoomRedPacketViewModel : NSObject

///主播
@property (nonatomic, assign) BOOL isAnchor;
///助理
@property (nonatomic, assign) BOOL isAssistant;

@property (nonatomic, strong) NSMutableArray *redPacketList;
///埋点参数
@property (nonatomic, copy) NSDictionary *trackingParams;

- (void)reuqestRedListChannelId:(NSString *)channelId roomId:(NSString *)roomId superView:(UIView *)superView right:(CGFloat)right top:(CGFloat)top;

//显示新红包
- (void)showBigPacketWithModel:(id)model;

//更新小红点
- (void)updateRedCount:(NSInteger)count;

//移除过期或者抢完的红包 或者自己已领过红包
- (void)updateReceivedRedId:(NSString *)redId;

@end

NS_ASSUME_NONNULL_END
