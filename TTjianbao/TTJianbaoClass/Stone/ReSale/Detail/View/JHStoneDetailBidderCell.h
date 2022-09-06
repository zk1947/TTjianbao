//
//  JHStoneDetailBidderCell.h
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN
@class COfferRecordListData;
/// 原石回血 出价人
@interface JHStoneDetailBidderCell : JHWBaseTableViewCell

@property (nonatomic, strong) COfferRecordListData *model;

@end

NS_ASSUME_NONNULL_END
