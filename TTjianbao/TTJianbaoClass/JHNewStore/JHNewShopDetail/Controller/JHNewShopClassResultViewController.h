//
//  JHNewShopClassResultViewController.h
//  TTjianbao
//
//  Created by hao on 2021/7/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
// 店铺分类

#import <UIKit/UIKit.h>
#import "JHNewShopDetailInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopClassResultViewController : JHBaseViewController
@property (nonatomic, strong) JHNewShopDetailInfoModel *shopInfoModel;
///分类ID
@property (nonatomic, assign) NSInteger cateId;

@end

NS_ASSUME_NONNULL_END
