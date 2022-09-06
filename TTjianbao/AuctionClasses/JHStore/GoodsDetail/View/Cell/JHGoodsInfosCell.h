//
//  JHGoodsInfosCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGoodsInfo;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_JHGoodsInfosIdentifer = @"JHGoodsInfosIdentifer";

@interface JHGoodsInfosCell : UICollectionViewCell

@property (nonatomic, strong) CGoodsInfo *goodsInfo;

+ (CGFloat)cellHeight;


@end

NS_ASSUME_NONNULL_END
