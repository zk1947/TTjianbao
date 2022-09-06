//
//  JHGoodsInfoShopCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///店铺信息 及 入口

#import <UIKit/UIKit.h>

@class CShopInfo;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_JHGoodsInfoShopIdentifer = @"JHGoodsInfoShopIdentifer";

@interface JHGoodsInfoShopCell : UICollectionViewCell

@property (nonatomic, strong) CShopInfo *shopInfo;
@property (nonatomic, copy) void(^enterShopBlock)(NSInteger sellerId);

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
