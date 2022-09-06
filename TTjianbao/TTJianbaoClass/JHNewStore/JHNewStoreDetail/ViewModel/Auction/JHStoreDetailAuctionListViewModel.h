//
//  JHStoreDetailAuctionListViewModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCellBaseViewModel.h"
#import "JHC2CJiangPaiListModel.h"

NS_ASSUME_NONNULL_BEGIN

///拍卖列表
@interface JHStoreDetailAuctionListViewModel : JHStoreDetailCellBaseViewModel

@property(nonatomic, strong) RACReplaySubject<NSArray<JHC2CJiangPaiRecord*> *> * recordsArrSubject;

/// 拍卖流水号
@property(nonatomic, strong) NSString * auctionSn;


/// 加价幅度 fen
@property(nonatomic, strong) NSString * addPrice;


/// 拍卖条数Sting
@property(nonatomic, strong) NSString * listCount;

/// 是否请求过list
@property(nonatomic) BOOL  hasRequest;

@property(nonatomic, strong) NSArray<JHC2CJiangPaiRecord*> * historyRecords;

@end

NS_ASSUME_NONNULL_END
