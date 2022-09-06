//
//  JHLargeImageCollectionViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CGoodsInfo;

static NSString *kCellId_JHLargeImageIdentifer = @"JHLargeImageCollectionViewCellIdentifer";

@interface JHLargeImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CGoodsInfo *goodsInfo;  //商品信息


@end

NS_ASSUME_NONNULL_END
