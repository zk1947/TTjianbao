//
//  JHStoreHomeSellerPanel.h
//  TTjianbao
//
//  Created by wuyd on 2019/12/17.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  商家店铺样式cell 的滑动面板
//

#import <UIKit/UIKit.h>

@class CStoreHomeListData;

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreHomeSellerPanel : UIView

@property (nonatomic, strong) CStoreHomeListData *curData;

@end

NS_ASSUME_NONNULL_END
