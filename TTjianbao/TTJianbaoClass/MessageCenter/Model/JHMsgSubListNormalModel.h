//
//  JHMsgSubListNormalModel.h
//  TTjianbao
//  Description:分类model：促销优惠&店铺结算[Normal]>订单物流&原石回血[NormalNotice]
//  Created by Jesse on 2020/3/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMsgSubListModel.h"
#import "JHMessageTargetModel.h"

NS_ASSUME_NONNULL_BEGIN

//促销优惠&店铺结算
@interface JHMsgSubListNormalModel : JHMsgSubListModel

@property (nonatomic, copy) NSString* status;//  (string, optional),是否已读状态,暂时没用到【直接用count判断未读】
@property (nonatomic, copy) NSString* secondType;// (string, optional): 消息二级类型 ,暂时不用。直接使用thirdType
@property (nonatomic, copy) NSString* iconUrl;//  new:图标路径
//@property (nonatomic, strong) JHMessageTargetModel* target;//  落地页,兼容新旧模型

@end

NS_ASSUME_NONNULL_END
