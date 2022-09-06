//
//  JHChatCouponViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatCouponInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHChatCouponViewController : UIViewController
@property (nonatomic, strong) NSArray<JHChatCouponInfoModel *> *dataSource;
@property (nonatomic, strong) RACSubject<NSArray<JHChatCouponInfoModel *> *> *sendSubject;
@end

NS_ASSUME_NONNULL_END
