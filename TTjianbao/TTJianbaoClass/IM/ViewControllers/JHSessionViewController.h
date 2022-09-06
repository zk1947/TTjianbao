//
//  JHSessionViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatGoodsInfoModel.h"
#import "JHChatOrderInfoModel.h"
#import "JHChatRecordView.h"
NS_ASSUME_NONNULL_BEGIN

static NSTimeInterval const VideoMaximumDuration = 60;

@interface JHSessionViewController : JHBaseViewController
/// 对方ID -accId customerId  二者传其一即可
@property (nonatomic, copy) NSString *receiveAccount;
/// 用户ID - customerId
@property (nonatomic, copy) NSString *userId;
/// 商品信息
@property (nonatomic, strong) JHChatGoodsInfoModel *goodsInfo;
/// 订单信息
@property (nonatomic, strong) JHChatOrderInfoModel *orderInfo;

@property (nonatomic, assign) JHIMSourceType sourceType;

@end

NS_ASSUME_NONNULL_END
