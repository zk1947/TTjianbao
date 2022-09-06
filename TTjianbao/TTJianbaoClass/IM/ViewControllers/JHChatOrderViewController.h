//
//  JHChatOrderViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatGoodsInfoModel.h"
#import "JHChatOrderInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHChatOrderViewController : UIViewController
@property (nonatomic, strong) RACSubject<JHChatOrderInfoModel *> *sendOrderMessage;
@property (nonatomic, strong) RACSubject<JHChatOrderInfoModel *> *gotoDetailPage;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *receiveAccount;
@end

NS_ASSUME_NONNULL_END
