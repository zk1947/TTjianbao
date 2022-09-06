//
//  JHStoreDetailPriceViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品价格区ViewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailCellBaseViewModel.h"

typedef NS_ENUM(NSUInteger, StoreDetailAuctionStatus) {
    /// 预告
    StoreDetailAuctionStatus_YuGao,
    /// 拍卖中无出价者
    StoreDetailAuctionStatus_InSelling_noBuyer,
    /// 拍卖中有出价
    StoreDetailAuctionStatus_InSelling,
    /// 拍卖结束无出价
    StoreDetailAuctionStatus_Finish_noBuyer,
    /// 拍卖结束有出价
    StoreDetailAuctionStatus_Finish,
};


//NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailPriceViewModel : JHStoreDetailCellBaseViewModel
@property (nonatomic, assign) StoreDetailType type;
//@property (nonatomic, strong) RACReplaySubject<NSString *> *typeSubject;
/// 背景色
@property (nonatomic, strong) RACReplaySubject<NSString *> *bgColorSubject;
/// title(专场价、新人价)
@property (nonatomic, copy) NSString *titleText;
/// title(专场价、新人价)
@property (nonatomic, copy) NSString *detailText;
/// 售价/原价
@property (nonatomic, copy) NSAttributedString *priceText;
/// 折扣价
@property (nonatomic, copy) NSAttributedString *salePriceText;
/// 折扣
@property (nonatomic, copy) NSString *saleText;
/// 倒计时时间
@property (nonatomic, assign) NSInteger countdownTime;
/// 开抢时间
@property (nonatomic, copy) NSString *previewSaleDateText;
/// 已设置提醒人数
@property (nonatomic, copy) NSString *previewNumText;

/// 拍卖状态
@property(nonatomic, assign) StoreDetailAuctionStatus  auctionStatus;

///最高出价  空没有人出价
@property (nonatomic, copy) NSString *maxBuyerPrice;

///拍卖设置提醒人数
@property (nonatomic, copy) NSString *remindCount;

///拍卖设置提醒人数
@property (nonatomic, copy) NSString *auStartTime;

/// 设置数据
/// salePrice : 折扣价
/// price : 原价
/// discount : 折扣
- (void)setupDataWithSalePrice : (NSString *)salePrice
                         price : (NSString *)price
                     isAuction : (BOOL)auction
                      discount : (NSString *)discount;

@end

//NS_ASSUME_NONNULL_END
