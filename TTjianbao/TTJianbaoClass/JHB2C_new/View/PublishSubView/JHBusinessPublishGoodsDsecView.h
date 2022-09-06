//
//  JHBusinessPublishGoodsDsecView.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBusinessPublishBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessPublishGoodsDsecView : JHBusinessPublishBaseView
- (instancetype)initWithType:(JHB2CPublishGoodsType)type;
- (void)setNetModelData;
@end

NS_ASSUME_NONNULL_END
