//
//  JHC2CGoodsCollectionViewCell.h
//  TTjianbao
//
//  Created by hao on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHC2CGoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CGoodsCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) JHC2CProductBeanListModel *goodsListModel;
///商品图
@property (nonatomic, strong) UIImageView *goodsImgView;
//数据绑定
- (void)bindViewModel:(id)dataModel params:(NSDictionary* _Nullable )parmas;
@end

NS_ASSUME_NONNULL_END
