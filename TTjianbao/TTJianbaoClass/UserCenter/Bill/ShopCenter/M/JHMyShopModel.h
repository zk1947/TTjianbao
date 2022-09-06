//
//  JHMyShopModel.h
//  TTjianbao
//
//  Created by apple on 2019/12/18.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface JHMyShopAccountModel : NSObject

@property (nonatomic, assign) double incomeFreezeAccount;

@property (nonatomic, assign) double withdrawAccount;

@property (nonatomic, assign) double alreadyIncomeAccount;
@end


@interface JHMyShopModel : NSObject

@property (nonatomic, strong) JHMyShopAccountModel *account;

@property (nonatomic, strong) JHMyShopAccountModel *oldAccount;

@property (nonatomic, assign) double totalMoney;

@property (nonatomic, copy) NSString *accountDate;

@end

NS_ASSUME_NONNULL_END
