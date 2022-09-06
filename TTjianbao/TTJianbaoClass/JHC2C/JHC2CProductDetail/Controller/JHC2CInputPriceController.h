    //
//  JHC2CInputPriceController.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHIssueGoodsEditModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CInputPriceController : UIViewController

@property(nonatomic, copy) void(^finish)(BOOL isYiKouJia, NSString *price1, NSString *price2, NSString *price3, BOOL post, NSString *beginTime, NSString *endTime);

@property (nonatomic, assign) BOOL isEdit;//编辑模式禁止切换一口价、拍卖类型

- (void)reloadUIData:(NSDictionary *)param;

- (void)reloadNetUIData:(JHIssueGoodsEditModel *)model;

@end

NS_ASSUME_NONNULL_END
