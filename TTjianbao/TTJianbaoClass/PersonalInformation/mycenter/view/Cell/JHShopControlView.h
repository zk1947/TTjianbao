//
//  JHShopControlView.h
//  TTjianbao
//
//  Created by lihui on 2020/3/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YYControl.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHShopControlViewAlignment) {
    JHShopControlViewAlignmentLeft = 0,     ///居左
    JHShopControlViewAlignmentCenter,       ///居中
    JHShopControlViewAlignmentRight,        ///居右
};

@interface JHShopControlView : YYControl

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) JHShopControlViewAlignment controlAlignment;


@end

NS_ASSUME_NONNULL_END
