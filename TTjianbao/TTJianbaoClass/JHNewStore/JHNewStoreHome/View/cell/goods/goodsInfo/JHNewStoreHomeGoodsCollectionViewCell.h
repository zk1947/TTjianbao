//
//  JHNewStoreHomeGoodsCollectionViewCell.h
//  TTjianbao
//
//  Created by user on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHNewStoreHomeGoodsProductListModel;
@class JHC2CProductBeanListModel;
@interface JHNewStoreHomeGoodsCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) JHNewStoreHomeGoodsProductListModel *curData;
@property (nonatomic,   copy) void(^goToBoutiqueDetailClickBlock)(BOOL isH5,NSString *showId, NSString *boutiqueName);
@property (nonatomic, strong) UIImageView *imgView;  //背景图片,用来接收视频层,暴露出来
//收藏与CTC模型合并
@property (nonatomic, strong) JHC2CProductBeanListModel *goodsListModel;
@end

NS_ASSUME_NONNULL_END
