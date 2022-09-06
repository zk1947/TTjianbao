//
//  JHMarketQuickPriceTwoView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHMarketPublishModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketQuickPriceTwoView : BaseView
/** 改价成功回调*/
@property (nonatomic, copy) void(^completeBlock)(void);
/** 数据模型*/
@property (nonatomic, strong) JHMarketPublishModel *publishModel;
@end

NS_ASSUME_NONNULL_END
