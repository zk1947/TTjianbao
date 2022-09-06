//
//  JHGoodManagerNormalModel.h
//  TTjianbao
//
//  Created by user on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#ifndef JHGoodManagerNormalModel_h
#define JHGoodManagerNormalModel_h

/// 商品类型 0 一口价 1 拍卖 2 全部
typedef NS_ENUM(NSInteger, JHGoodManagerListRequestProductType) {
    JHGoodManagerListRequestProductType_OnePrice = 0, /// 0 一口价
    JHGoodManagerListRequestProductType_Auction  = 1, /// 1 拍卖
    JHGoodManagerListRequestProductType_All      = 2, /// 2 全部
};

/// 商品状态   0上架   1下架   2违规禁售   3预告中  4已售出  5流拍  6交易取消
typedef NS_ENUM(NSInteger, JHGoodManagerListRequestProductStatus) {
    JHGoodManagerListRequestProductStatus_ALL         = -1, /// nav tab 的全部
    JHGoodManagerListRequestProductStatus_PutOn       = 0, /// 0 上架
    JHGoodManagerListRequestProductStatus_PutOff      = 1, /// 1 下架
    JHGoodManagerListRequestProductStatus_IllegalSale = 2, /// 2 违规禁售
    JHGoodManagerListRequestProductStatus_Trailer     = 3, /// 3 预告中
    JHGoodManagerListRequestProductStatus_AlreadySold = 4, /// 4 已售出
    JHGoodManagerListRequestProductStatus_NoOneBuy    = 5, /// 5 流拍
    JHGoodManagerListRequestProductStatus_Cancel      = 6, /// 5 交易取消
};

/// 审核状态 0系统审核中 1系统审核通过 2系统审核不通过
typedef NS_ENUM(NSInteger, JHGoodManagerListAuditStatus) {
    JHGoodManagerListAuditStatus_Auditing = 0, /// 0系统审核中
    JHGoodManagerListAuditStatus_AuditYES = 1, /// 1系统审核通过
    JHGoodManagerListAuditStatus_AuditNO  = 2, /// 2系统审核不通过
};

/// 孤品状态 0非孤品 1孤品
typedef NS_ENUM(NSInteger, JHGoodManagerListGoodUniqueStatus) {
    JHGoodManagerListGoodUniqueStatus_Many    = 0, /// 0非孤品
    JHGoodManagerListGoodUniqueStatus_OnlyOne = 1, /// 1孤品
};



#endif /* JHGoodManagerNormalModel_h */
