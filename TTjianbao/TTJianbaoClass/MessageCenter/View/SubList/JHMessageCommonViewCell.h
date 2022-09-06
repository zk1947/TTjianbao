//
//  JHMessageCommonViewCell.h
//  TTjianbao
//  Description:4类样式
//  样式1.1<店铺结算「小图+desc」>
//  样式1.2<原石回血/订单提醒「大图+desc」>
//  样式2.1<鉴定回复「大图+title+desc」>
//  样式2.2<促销优惠/系统消息「小图+title+desc」>
//  Created by Jesse on 2020/2/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessagesTableViewCell.h"
#import "JHMsgSubListNormalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMessageCommonViewCell : JHMessagesTableViewCell

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *desc;

@end

NS_ASSUME_NONNULL_END
