//
//  JHGoodsDetailRepertoryCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
// 商品库存

#import <UIKit/UIKit.h>

@class CGoodsInfo;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_JHGoodsDetailRepertoryIdentifer = @"JHGoodsDetailRepertoryIdentifer";

@interface JHGoodsDetailRepertoryCell : UICollectionViewCell

@property (nonatomic, strong) CGoodsInfo *goodsInfo;  //商品信息

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
