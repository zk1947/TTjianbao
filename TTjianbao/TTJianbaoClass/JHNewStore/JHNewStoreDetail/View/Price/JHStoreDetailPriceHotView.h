//
//  JHStoreDetailPriceHotView.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailPriceView.h"
#import "JHStoreDetailConst.h"
#import "JHStoreDetail.h"
#import "JHStoreDetailCountdownView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailPriceHotView : UIView
/// title
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) JHStoreDetailCountdownView *countdownView;
@end

NS_ASSUME_NONNULL_END
