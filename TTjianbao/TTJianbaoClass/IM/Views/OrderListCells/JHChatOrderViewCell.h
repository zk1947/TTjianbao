//
//  JHChatOrderViewCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatGoodsInfoModel.h"
#import "JHChatOrderInfoModel.h"
#import "JHChatBaseCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHChatOrderViewCell : JHChatBaseCell
@property (nonatomic, strong) JHChatOrderInfoModel *model;
@property (nonatomic, strong) RACSubject *sendSubject;
@property (nonatomic, strong) RACSubject *detailSubject;
@end

NS_ASSUME_NONNULL_END
