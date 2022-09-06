//
//  JHNewShopDetailHeaderViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewShopDetailInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopDetailHeaderViewModel : NSObject
@property (nonatomic, strong) JHNewShopDetailInfoModel *shopDetailInfoModel;

@property (nonatomic, strong) RACCommand *shopDetailInfoCommand;///店铺信息
@property (nonatomic, strong) RACCommand *followShopCommand;///关注店铺
@property (nonatomic, strong) RACCommand *getCouponsCommand;///领取店铺优惠券

@property (nonatomic, strong) RACSubject *updateShopInfoSubject;
@property (nonatomic, strong) RACSubject *followShopSubject;
@property (nonatomic, strong) RACSubject *getCouponsSubject;
@property (nonatomic, strong) RACSubject *errorRefreshSubject;


@end

NS_ASSUME_NONNULL_END
