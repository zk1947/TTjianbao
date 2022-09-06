//
//  JHShopwindowGoodsAlert.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHShopwindowGoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHShopwindowGoodsAlert : UIImageView

+ (JHShopwindowGoodsAlert *)showWithModel:(JHShopwindowGoodsListModel *)model;
+ (CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END
