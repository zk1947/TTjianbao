//
//  JHBillDetailViewModel.h
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHBillDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBillDetailViewModel : JHBaseViewModel

/// 结算 = 1  提现 = 2   退款 = 3  冲账 = 4
@property (nonatomic, assign) NSInteger status;

+(NSString*)numberFormatter:(NSNumber*)number;

@end

NS_ASSUME_NONNULL_END
