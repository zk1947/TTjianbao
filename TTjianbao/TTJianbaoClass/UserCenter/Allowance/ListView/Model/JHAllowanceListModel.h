//
//  JHAllowanceListModel.h
//  TTjianbao
//
//  Created by apple on 2020/2/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAllowanceListModel : NSObject

@property (nonatomic, copy) NSString *changeAmount;
@property (nonatomic, copy) NSString *changeType;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *expiredDate;
@property (nonatomic, copy) NSString *name;

/// 变动后的总额
@property (nonatomic, copy) NSString *changeAfterAmount;
/// data.type == expiration 过期
@property (nonatomic, copy) NSString *type;

/// 是否是获取金额
@property (nonatomic, assign) BOOL isGetMoney;

/// 是否已失效
@property (nonatomic, assign) BOOL isExpired;

@end

NS_ASSUME_NONNULL_END
