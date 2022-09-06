//
//  JHNewShopDetailInfoViewController.h
//  TTjianbao
//
//  Created by user on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class JHNewShopDetailInfoModel;
@interface JHNewShopDetailInfoViewController : JHBaseViewController
@property (nonatomic, strong)JHNewShopDetailInfoModel *shopHeaderInfoModel;
///关注按钮点击回调
@property (nonatomic,   copy) JHActionBlock    followSuccessBlock;
@end

NS_ASSUME_NONNULL_END
