//
//  JHBusinessPublishGoodsController.h
//  TTjianbao
//
//  Created by liuhai on 2021/7/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHBusinesspublishModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessPublishGoodsController : JHBaseViewController
@property(nonatomic, copy) void (^successBlock)(int productStatus);

- (instancetype)initWithPublishType:(JHB2CPublishGoodsType)type;
- (instancetype)initWithPublishProductId:(NSString *)productId; //编辑入口
@end

NS_ASSUME_NONNULL_END
