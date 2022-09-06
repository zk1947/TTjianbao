//
//  JHPresentRecordModel.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/4.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPresentRecordModel : NSObject
//收到的礼物
@property (nonatomic, copy) NSString *receiverNick;
@property (nonatomic, copy) NSString *senderTime;
@property (nonatomic, copy) NSString *receiverAvatar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, assign) NSInteger amount;


//送出的礼物
@property (nonatomic, copy) NSString *senderNick;
@property (nonatomic, copy) NSString *receiveTime;
@property (nonatomic, copy) NSString *senderAvatar;

@end

NS_ASSUME_NONNULL_END
