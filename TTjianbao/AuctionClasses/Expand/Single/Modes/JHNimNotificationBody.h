//
//  JHNimNotificationBody.h
//  TTjianbao
//
//  Created by jiang on 2019/12/9.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNimNotificationBody : NSObject
//队列等待人数
@property(strong,nonatomic)NSString *singleWaitSecond;
@property(assign,nonatomic)NSInteger offerCount;
@property(assign,nonatomic)NSInteger saleCount;
@property(assign,nonatomic)NSInteger seekCount;
@property(assign,nonatomic)NSInteger shelveCount;
@property(strong,nonatomic)NSString *totalPrice;
@property(assign,nonatomic)NSInteger orderCount;
@property(assign,nonatomic)NSInteger unshelveCount;
/*push消息推送的时候会比原石回血多返回一个msgType属性
 * 原石回血：1stoneRestore("stoneRestore") 或者2没有时
 * 原石转售stoneResale("stoneResale")
 */
@property(strong,nonatomic)NSString *msgType;

//个人(原石)转售
- (BOOL)stoneResellMsgType;

@end

NS_ASSUME_NONNULL_END
