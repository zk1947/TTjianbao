//
//  JHC2CProductDetailPaiMaiInfoBottomListView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHC2CJiangPaiListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductDetailPaiMaiInfoBottomListView : UIView


@property(nonatomic, copy) void(^refreshPriceBlock)(void);

@property(nonatomic, copy) void(^tapBlock)(void);

@property(nonatomic, strong) JHC2CJiangPaiListModel * model;

@end

NS_ASSUME_NONNULL_END
