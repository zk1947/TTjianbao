//
//  JHGoodsDetailHeaderShopPanel.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  店铺信息栏
//

#import <UIKit/UIKit.h>
//#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"
#import "CGoodsDetailModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JHGoodsDetailHeaderShopPanel : UIView

@property (nonatomic, strong) CShopInfo *shopInfo;

@property (nonatomic, copy) void(^enterShopBlock)(NSInteger sellerId);


@end

NS_ASSUME_NONNULL_END
