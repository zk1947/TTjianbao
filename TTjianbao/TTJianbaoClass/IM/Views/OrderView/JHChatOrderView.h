//
//  JHChatOrderView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatGoodsInfoModel.h"
#import "JHChatOrderInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^SendOrderInfoHandler)(JHChatOrderInfoModel *orderInfo);
@interface JHChatOrderView : UIView
@property (nonatomic, copy) SendOrderInfoHandler sendHandler;
/// 订单消息
@property (nonatomic, strong) JHChatOrderInfoModel *orderInfo;
@end

NS_ASSUME_NONNULL_END
