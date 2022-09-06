//
//  JHNewShopHotSellViewController.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "JHNewShopDetailInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopHotSellViewController : UIViewController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHNewShopDetailInfoModel *shopInfoModel;
///标签点击 0全部 1拍卖 2一口价
@property (nonatomic, assign) NSInteger selectedTitleIndex;

@end

NS_ASSUME_NONNULL_END
