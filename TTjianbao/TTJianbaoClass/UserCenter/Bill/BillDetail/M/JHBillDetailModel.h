//
//  JHBillDetailModel.h
//  TTjianbao
//
//  Created by apple on 2019/12/18.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBillDetailModel : NSObject


/// 操作名称
@property (nonatomic, copy) NSString *optName;

/// 流水号或者备注
@property (nonatomic, copy) NSString *serialNoOrRemark;

/// 金额正负标志
@property (nonatomic, copy) NSString *sign;

/// 金额
@property (nonatomic, assign) double changeMoney;

@property (nonatomic, copy) NSString *changeMoneyStr;

/// 操作时间
@property (nonatomic, copy) NSString *flowDate;

/// 备注
@property (nonatomic, copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END
