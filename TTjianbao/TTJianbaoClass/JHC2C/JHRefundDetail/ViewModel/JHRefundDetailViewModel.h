//
//  JHRefundDetailViewModel.h
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHC2CRefundDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRefundDetailViewModel : NSObject
@property (nonatomic, strong) JHC2CRefundDetailModel *refundDetailModel;

@property (nonatomic, strong) RACCommand *refundCommand;

@property (nonatomic, copy) NSArray *dataSourceArray;

@property (nonatomic, strong) RACSubject *errorRefreshSubject;

@end

NS_ASSUME_NONNULL_END
