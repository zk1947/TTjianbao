//
//  JHShopGoodsController.h
//  TTjianbao
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  特卖商品列表
//


typedef void(^JHShopScrollContentOffSetBlock)(CGFloat offsetY);

NS_ASSUME_NONNULL_BEGIN

@interface JHShopGoodsController : UIViewController

///商家id
@property (nonatomic, assign) NSInteger sellerId;
///1 特价商品  2 询价商品  暂时没用 暂时传0
@property (assign) NSInteger sortType;
@property (nonatomic, copy) JHShopScrollContentOffSetBlock offsetBlock;


@end

NS_ASSUME_NONNULL_END
