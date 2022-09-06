//
//  JHGoodsDetailPriceCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbaoHeader.h"
#import "CGoodsDetailModel.h"


NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_JHGoodsDetailPriceIdentifer = @"JHGoodsDetailPriceIdentifer";

@interface JHGoodsDetailPriceCell : UICollectionViewCell

@property (nonatomic, strong) CGoodsInfo *goodsInfo;

+ (CGFloat)cellHeight;

- (instancetype)initWithOfflineTime:(NSString *)offlineTime;

@end

NS_ASSUME_NONNULL_END
