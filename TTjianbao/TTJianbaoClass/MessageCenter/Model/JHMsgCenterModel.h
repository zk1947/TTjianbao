//
//  JHMsgCenterModel.h
//  TTjianbao
//  Description:消息主页和未读请求
//  Created by Jesse on 2020/3/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHMessageHeader.h"
#import "JHSessionModel.h"
NS_ASSUME_NONNULL_BEGIN


//获取消息主页列表
@interface JHMsgCenterModel : JHRespModel

@property (nonatomic, copy) NSString* pageIndex;
@property (nonatomic, assign) NSInteger total;//  (integer, optional),
@property (nonatomic,  assign) NSInteger isTop;//  (integer, optional): 是否置顶 ,1:重要分类 0:普通分类
@property (nonatomic, copy) NSString* firstType;//   (string, optional): 一级类型 ,
@property (nonatomic, copy) NSString* body;// (string, optional),
@property (nonatomic, copy) NSString* icon;//  (string, optional),
@property (nonatomic, copy) NSString* title;//  (string, optional),
@property (nonatomic, copy) NSString* type;//  (string, optional): 一级类型 express:订单物流, announce_activity:活动公告, announce_common:平台公告, forum:社区互动, settle:店铺结算, promote:促销优惠, stone:原石回血 ,
@property (nonatomic, copy) NSString* updateDate;//  (string, optional)

/// 子商户id
@property (nonatomic, strong) NSString *shopId;

#pragma mark - IM
/// IM对方ID
@property (nonatomic, copy) NSString *receiveAccount;
@property (nonatomic, strong) JHSessionModel *session;
@end

#pragma mark - 同步消息接口,进入消息中心之前调用
@interface JHMsgCenterSyncReqModel : JHReqModel
@end

//获取总数he分类
@interface JHMsgCenterReqModel : JHReqModel
@end

//删除分类
@interface JHMsgCenterRemoveReqModel : JHReqModel

@property (nonatomic, copy) NSString* msgType;
@end

//获取总未读数
@interface JHMsgCenterSubUnreadModel : JHRespModel

@property (nonatomic, assign) NSInteger count;//   (integer, optional): 数量 ,
@property (nonatomic, copy) NSString* type;//   (string, optional): 类型
@end

@interface JHMsgCenterUnreadModel : JHRespModel

@property (nonatomic, assign) NSInteger total;//   (integer, optional): 消息总数 ,
@property (nonatomic, strong) NSArray<JHMsgCenterSubUnreadModel*>* typeCounts;//   (Array[各类型数量], optional): 各分类数量
@end

@interface JHMsgCenterUnreadReqModel : JHReqModel
@end

NS_ASSUME_NONNULL_END

