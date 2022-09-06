//
//  JHNewStoreGoodsInfoViewController.h
//  TTjianbao
//
//  Created by user on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXCategoryView.h"
#import "JHGoodManagerNormalModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHNewStoreGoodsInfoViewControllerDelegate <NSObject>
- (void)JHNewStoreGoodsInfoViewControllerLeaveTop;
@end

@class JHNewStoreHomeGoodsProductListModel;
@interface JHNewStoreGoodsInfoViewController : JHBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic,   copy) void(^goodsClickBlock)(JHNewStoreHomeGoodsProductListModel *model, NSIndexPath *indexPath);
@property (nonatomic,   copy) void(^goToBoutiqueDetailClickBlock)(BOOL isH5, NSString *showId, NSString *boutiqueName);
@property (nonatomic,   weak) id<JHNewStoreGoodsInfoViewControllerDelegate> delegate;
@property (nonatomic, strong) UICollectionView                      *collectionView;

@property (nonatomic, assign) long tabId;
@property (nonatomic, assign) NSInteger indexVc; /// 第几个vc (第0个是客户端加的默认推荐)
@property (nonatomic,   copy) NSString *tabName;
@property (nonatomic, assign) BOOL hasBoutiqueValue;
@property (nonatomic, assign) JHGoodManagerListRequestProductType requestProductType;

- (void)getGoodsInfo;
- (void)makeDeatilDescModuleScroll:(BOOL)canScroll;
- (void)makeDeatilDescModuleScrollToTop;

@end

NS_ASSUME_NONNULL_END
