//
//  JHChatGoodsInfoModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "JHIMHeader.h"
NS_ASSUME_NONNULL_BEGIN


@class JHChatGoodsInfoModel;


@interface JHChatCustomGoodsModel : NSObject<NIMCustomAttachment>
@property (nonatomic, assign) JHChatCustomType type;
@property (nonatomic, strong) JHChatGoodsInfoModel *body;
@end

#pragma mark - goods
@interface JHChatGoodsInfoModel : NSObject
/// 商品类型- 0: C2C商品 1：B2C商品
@property (nonatomic, assign) NSInteger goodsPlatformType;
/// 商品ID
@property (nonatomic, copy) NSString *productId;
/// 商品图片
@property (nonatomic, copy) NSString *iconUrl;
/// 商品名称
@property (nonatomic, copy) NSString *title;
/// 商品金额
@property (nonatomic, copy) NSString *price;
@end



NS_ASSUME_NONNULL_END
