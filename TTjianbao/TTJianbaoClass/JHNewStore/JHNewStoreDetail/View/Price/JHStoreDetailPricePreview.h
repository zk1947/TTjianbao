//
//  JHStoreDetailPricePreview.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailPriceView.h"
#import "JHStoreDetailConst.h"
#import "JHStoreDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailPricePreview : UIView
/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// 开抢时间
@property (nonatomic, strong) UILabel *dateLabel;
/// 设置提醒的人数
@property (nonatomic, strong) UILabel *numLabel;

@end

NS_ASSUME_NONNULL_END
