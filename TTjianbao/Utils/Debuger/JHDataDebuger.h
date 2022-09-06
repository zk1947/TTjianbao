//
//  JHDataDebuger.h
//  TTjianbao
//  Description:各种调试:避免使用+方法,否则可能出现异常
//  Created by jesee on 22/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JHDebuger [JHDataDebuger shareInstance]

NS_ASSUME_NONNULL_BEGIN

@interface JHDataDebuger : NSObject

//尽量使用单例对应的宏
+ (instancetype)shareInstance;

//通用数据填充接口,避免多次修改头文件
- (void)dataArrayOfCommon:(NSArray*_Nonnull*_Nonnull)dataArray dataType:(NSInteger)dataType;
//出价
- (void)dataArrayOfOfferPrice:(NSArray*_Nonnull*_Nonnull)dataArray;
//买入原石数据源
- (void)dataArrayOfPurchaseStone:(NSArray*_Nonnull*_Nullable)dataArray;
//直播间弹框
- (void)liveRoomPopview;
@end

NS_ASSUME_NONNULL_END
