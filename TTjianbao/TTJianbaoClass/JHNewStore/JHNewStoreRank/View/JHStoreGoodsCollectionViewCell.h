//
//  JHStoreGoodsCollectionViewCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHStoreRankProductModel;
@interface JHStoreGoodsCollectionViewCell : UIView
/** 商品数据*/
@property (nonatomic, strong)  JHStoreRankProductModel *model;
@end

NS_ASSUME_NONNULL_END
