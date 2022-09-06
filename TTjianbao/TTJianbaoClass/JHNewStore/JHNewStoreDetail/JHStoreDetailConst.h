//
//  JHStoreDetailConst.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#ifndef JHStoreDetailConst_h
#define JHStoreDetailConst_h

static CGFloat const LeftSpace = 12.0f;
static CGFloat const PriceRightDetailWidth = 120.0f;
static CGFloat const PriceTitleTopSpace = 6.0f;

typedef NS_ENUM(NSUInteger, StoreDetailType) {
    /// 正常
    Normal = 1,
    /// 热卖
    HotSale,
    /// 预告专场
    Preview,
    /// 新人
    NewUser,
    /// 拍卖
    Auction,
    /// 秒杀
    RushPurChase,

};

#endif /* JHStoreDetailConst_h */
