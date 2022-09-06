//
//  LoginMode.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/21.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class IMAccountMode;

@interface LoginMode : NSObject
@property (strong,nonatomic)NSString * isBind;
@property (strong,nonatomic)NSString* loginToken;
@property (strong,nonatomic)IMAccountMode *wyAccount;
@property (assign, nonatomic) NSInteger isReg;
@property (copy, nonatomic)NSString *customerId;

@end

@interface IMAccountMode : NSObject
@property (strong,nonatomic)NSString * accid; //云信Id,对应服务端账户Id
@property (strong,nonatomic)NSString* token;
@end

NS_ASSUME_NONNULL_END
