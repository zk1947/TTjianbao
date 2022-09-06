//
//  JHC2CPaySureMoneyView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailModel.h"

@class JHC2CProoductDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CPaySureMoneyView : UIView

@property(nonatomic, strong) JHC2CProoductDetailModel * model;

//B2C
@property(nonatomic, strong)  JHProductAuctionFlowModel* modelB2C;

@property(nonatomic, copy) void (^payBlock)(void);

@property(nonatomic, copy) NSString * productID;

@end

NS_ASSUME_NONNULL_END
