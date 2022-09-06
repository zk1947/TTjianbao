//
//  JHSeckillCollectionCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHGoodsInfoMode;

static NSString *const kCellId_JHStoreHomeCollectionSeckillId = @"JHStoreHomeSeckillCollectionIdentifier";


@interface JHSeckillCollectionCell : UICollectionViewCell

@property (nonatomic, strong) JHGoodsInfoMode *goodsInfo;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
