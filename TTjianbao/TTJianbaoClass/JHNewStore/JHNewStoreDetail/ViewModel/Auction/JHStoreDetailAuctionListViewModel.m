//
//  JHStoreDetailAuctionListViewModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailAuctionListViewModel.h"
#import "JHC2CProductDetailBusiness.h"


@interface JHStoreDetailAuctionListViewModel()

@end

@implementation JHStoreDetailAuctionListViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = AuctionListCell;
    self.height = 0.1;
    self.listCount = @"0";
    // 57 35  41
}

- (void)setAuctionSn:(NSString *)auctionSn{
    _auctionSn = auctionSn;
    if (self.hasRequest) {return;}
    self.hasRequest = YES;
    [JHC2CProductDetailBusiness  requestC2CProductDetailPaiMaiList:auctionSn page:@1 completion:^(NSError * _Nullable error, JHC2CJiangPaiListModel * _Nullable model) {
        if (model.records.count) {
            NSInteger count = MIN(3, model.records.count);
            CGFloat footer = 41;
            if (model.records.count > 3) {
                footer = 41;
            }
            self.height = 57.0 * count + 35 + footer;
            [self.recordsArrSubject sendNext:model.records];
        }
    }];
}

- (RACReplaySubject<NSArray<JHC2CJiangPaiRecord *> *> *)recordsArrSubject{
    if (!_recordsArrSubject) {
        _recordsArrSubject = [RACReplaySubject subject];
    }
    return _recordsArrSubject;
}

- (void)setAddPrice:(NSString *)addPrice{
    _addPrice = [NSString stringWithFormat:@"￥%@",[CommHelp getPriceWithInterFen:addPrice.integerValue]];
}
- (void)setHistoryRecords:(NSArray<JHC2CJiangPaiRecord *> *)historyRecords{
    _historyRecords = historyRecords;
    if (historyRecords.count) {
        NSInteger count = MIN(3, historyRecords.count);
        CGFloat footer = 41;
        if (historyRecords.count > 3) {
            footer = 41;
        }
        self.height = 57.0 * count + 35 + footer;
        [self.recordsArrSubject sendNext:historyRecords];
    }
}

@end
