//
//  JHRecyclePriceView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class JHRecyclePriceModel;
@interface JHRecyclePriceView : BaseView
/** 商品的id*/
@property (nonatomic, copy) NSString *productId;
/** 数据*/
@property (nonatomic, strong) NSMutableArray <JHRecyclePriceModel *>*listArray;
/** 价格选择模型id*/
@property (nonatomic, copy) void(^bitIdBlock)(JHRecyclePriceModel *bidModel);
/** 查看全部按钮*/
@property (nonatomic, strong) UIButton *seeAllButton;
/** 选择报价*/

@end

NS_ASSUME_NONNULL_END
