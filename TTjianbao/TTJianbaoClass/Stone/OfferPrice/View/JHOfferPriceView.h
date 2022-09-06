//
//  JHOfferPriceView.h
//  TTjianbao
//
//  Created by jiang on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "JHStoneOfferModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^intentionBtnAction)(NSString *price);
@interface JHOfferPriceView : BaseView
@property (nonatomic, strong) JHStoneOfferModel *stoneMode;
@property (nonatomic, strong) intentionBtnAction handle;
@property (nonatomic, assign) BOOL resaleFlag;//是否是个人转售
@end

NS_ASSUME_NONNULL_END
