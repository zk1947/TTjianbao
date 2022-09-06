//
//  JHStoreAutionPriceView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailPriceView.h"
#import "JHStoreDetailConst.h"
#import "JHStoreDetail.h"
#import "JHStoreDetailCountdownView.h"
#import "JHStoreDetailPriceViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreAutionPriceView : UIView
/// title
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JHStoreDetailCountdownView *countdownView;
@property (nonatomic, strong) UILabel *noticeLbl;
@property (nonatomic, strong) UILabel *detailLabel;

@property(nonatomic, strong) NSString * auStarStr;

- (void)changeAuctionStatus:(StoreDetailAuctionStatus)status;
@end

NS_ASSUME_NONNULL_END
