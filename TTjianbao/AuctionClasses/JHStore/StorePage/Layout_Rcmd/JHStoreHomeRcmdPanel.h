//
//  JHStoreHomeRcmdPanel.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  今日推荐样式cell 的商品滑动面板
//

#import <UIKit/UIKit.h>

@class CStoreHomeListData;
@class CStoreHomeGoodsData;

static CGFloat bgRatio  = 1.116; //大背景图宽高比 355/318

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreHomeRcmdPanel : UIView

@property (nonatomic, strong) CStoreHomeListData *curData;

#pragma mark - 下列属性解决横向滑动ccView联动问题

@property (nonatomic, copy) void(^collectionOffsetXChangedBlock)(UICollectionView *ccView, NSIndexPath *atIndexPath, CGFloat offsetX);
@property (nonatomic, strong) NSIndexPath *indexPath;
//这里不要用YDBaseCollectionView，不然会和首页底部标签列表冲突！！！
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
