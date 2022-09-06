//
//  JHNewShopDetailClassView.h
//  TTjianbao
//
//  Created by hao on 2021/7/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  店铺分类

#import <UIKit/UIKit.h>
#import "JHNewShopDetailInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopDetailClassView : UIView
///店铺ID
@property (nonatomic, copy) NSString *shopID;
@property (nonatomic, strong) JHNewShopDetailInfoModel *shopInfoModel;

@end

NS_ASSUME_NONNULL_END
