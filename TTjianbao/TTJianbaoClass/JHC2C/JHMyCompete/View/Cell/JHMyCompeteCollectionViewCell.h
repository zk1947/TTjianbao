//
//  JHMyCompeteCollectionViewCell.h
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
@class JHMyCompeteModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ButtonActionBlock)(JHMyCompeteModel *model, BOOL isPay);

@interface JHMyCompeteCollectionViewCell : UICollectionViewCell
//JHBaseCollectionViewCell

/// 设置数据
@property (nonatomic, strong) JHMyCompeteModel *myCompeteModel;

///商品图
@property (nonatomic, strong) UIImageView *goodsImgView;

@property (nonatomic, copy) ButtonActionBlock buttonActionBlock;


@end

NS_ASSUME_NONNULL_END
