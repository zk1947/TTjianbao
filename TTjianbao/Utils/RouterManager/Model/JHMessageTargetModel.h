//
//  JHMessageTargetModel.h
//  TTjianbao
//  Description:兼容新旧message和push模型
//  Created by Jesse on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTjianbaoMarcoEnum.h"

@class JHMessageTargetParamsModel;

typedef NS_ENUM(NSInteger, XGPushMessageType)
{
    XGPushMessageTypeDefault = 1,
    XGPushMessageTypeWeb  = 2,
    XGPushMessageTypeView  = 3
};
typedef NS_ENUM(NSInteger, JHMessagePageType)
{
    /*尽量别新增page type了,用透传方式,目前为了兼容两种方式,定义下面类型*/
    JHMessagePageTypePushMsg  = -999, //拦截透传方式
    JHMessagePageTypeNormal = 0,     // 3.3.1后默认拦截透传方式
    
     JHMessagePageTypeLiveRoom = 1,//直播间
     JHMessagePageTypeCopon = 2,//我的红包列表
     JHMessagePageTypeOrderDetail = 3,//订单详情
     JHMessagePageTypeOrderSure = 4,//订单确认页
     JHMessagePageTypeReport = 5,//评估报告
     JHMessagePageTypeCoverDetail = 6,//帖子详情
     JHMessagePageTypeUserMainPage = 7,//个人主页
     JHMessagePageTypeHistoryMessageList = 8,//消息中心
     JHMessagePageTypeOrderList = 9,//订单列表
     JHMessagePageTypeTopic = 10,//进入话题详情
     JHMessagePageTypeUserCenterResale = 11,//买家寄售原石页面
     JHMessagePageTypeStonePinMoney = 12,//卖家结算页面
     JHMessagePageTypeStoneMyPrice = 13,//待出价
     JHMessagePageTypeStoneMyWillSale = 14,//待上架原石
     JHMessagePageTypeRedPacket = 15,//红包领取详情
     JHMessagePageTypeMallCopon  = 16,//我的代金券列表
     JHMessagePageTypeAllowance  = 17, //我的钱包-津贴
     JHMessagePageTypeSeckillPageList  = 18, //秒杀列表
    JHMessagePageTypePersonCenter  = 19, //个人中心
    JHMessagePageTypePersonalInfo  = 20, //个人信息
    
    
};

NS_ASSUME_NONNULL_BEGIN

@interface JHMessageTargetModel : NSObject
//new
@property (nonatomic, copy) NSString* type; //页面类型->JHRouterType
@property (nonatomic, copy) NSString* presentType; //页面跳转方式,push or present
@property (nonatomic, copy) NSString* vc; //具体页面viewController
@property (nonatomic, strong) NSDictionary* params; //JHRouterControllerModel
//old
@property (nonatomic, assign) XGPushMessageType action_type; //仅区分了下web,没啥用途,尽量废除
@property (nonatomic, assign) JHMessagePageType componentType;//  (integer, optional),
@property (nonatomic, copy) NSString* componentName;//  (string, optional),
@property (nonatomic, strong) JHMessageTargetParamsModel* paramTargetModel;// (inline_model, optional)

@end

@interface JHMessageTargetParamsModel : NSObject

@property (assign,nonatomic) JHMessagePageType componentType;

@property (assign,nonatomic)int  type;
@property (strong,nonatomic)NSString* roomId;
@property (strong,nonatomic)NSString* orderId;
@property (strong,nonatomic)NSString* ID;
@property (strong,nonatomic)NSString* url;
//进详情页
@property (assign,nonatomic)JHPostItemType item_type;
@property (strong,nonatomic)NSString *item_id;
@property (strong,nonatomic)NSString *comment_id;
@property (assign,nonatomic) NSInteger layout;
//用户中心
@property (strong,nonatomic) NSString  * user_id;
@property (assign,nonatomic)int targetIndex; //0 未使用  1已使用  2 已过期
//红包id
@property (strong,nonatomic) NSString  * redPacketId;
//店铺结算>>我的店铺-订单管理-我卖出的
@property (assign,nonatomic) NSInteger isSeller; //=YES or 1

@end

NS_ASSUME_NONNULL_END
