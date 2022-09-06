//
//  User.h
//  TTjianbao
//  Description:用户信息model
//  Created by jiangchao on 2018/12/10.
//  Copyright © 2018 Netease. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "JHUserAuthModel.h"

////准备废弃
//typedef NS_ENUM(NSInteger, JHUserTypeRole) {
//    JHUserTypeRoleDefault = 0,                  ///普通用户
//    JHUserTypeRoleAppraiseAnchor = 1,           ///鉴定主播
//    JHUserTypeRoleSaleAnchor = 2,               ///卖货主播
//    JHUserTypeRoleAssistant = 3,                ///卖货助理
//    JHUserTypeRoleCommunityShop = 4,            ///社区商户
//    JHUserTypeRoleMaJia = 5,                    ///马甲
//    JHUserTypeRoleCommunityAndSaleAnchor = 6,   ///既是社区商户 又是卖货商户
//    JHUserTypeRoleRestoreAnchor = 7,            //回血主播
//    JHUserTypeRoleRestoreAssistant = 8,       //回血助理
//    JHUserTypeRoleCustomize = 9,            //定制师
//    JHUserTypeRoleCustomizeAssistant = 10,        //定制师助理
//
//};

NS_ASSUME_NONNULL_BEGIN
///直播
static NSString *const living = @"live";
///回收
static NSString *const recycle = @"recycle";
///优店
static NSString *const excellent = @"excellent";

@interface User : NSObject
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *icon;
@property (nonatomic, copy)NSString *authStatus;
@property (nonatomic, copy)NSString *invitationCode;
@property (nonatomic, copy)NSString *loginWay;
@property (nonatomic, assign)int type;
@property (nonatomic, copy)NSString *customerId;
@property (nonatomic, copy)NSString * balance;//鉴豆津贴
@property (nonatomic, copy)NSString *enCouponCount;//可用红包
@property (nonatomic, copy)NSString *enVoucherCount;//可用代金券
@property (nonatomic, assign)BOOL isAssistant; //是否卖货主播助理
@property (nonatomic, assign)int  bindThird; //绑定第三方，0未绑定，1微信，2QQ，3微信+QQ ,
@property (nonatomic, copy)NSString * bountyBalance;//现金红包;
@property (nonatomic, assign) NSInteger nameModifyLimit;
@property (nonatomic, assign) NSInteger gameGrade;
@property (nonatomic, assign)int enCreateVoucher;//1可以 0不可以
@property (nonatomic, assign)int hasWaitPay; //是否有待付款

@property (nonatomic, copy) NSString *userTycoonLevelIcon;//用户土豪等级图标

@property (nonatomic, assign) NSInteger hasBigCustomer;//土豪level

/// 土豪开关 1开   0 关
@property (nonatomic, assign) NSInteger customerRichStatus;

/// 土豪 1是   0 不是
@property (nonatomic, assign) NSInteger hasBigCustomerType;

///372新增小版本 --- TODO lihui
///认证类型
@property (nonatomic, assign) JHUserAuthType authType;
///审核状态
@property (nonatomic, assign) JHUserAuthState authState;
@property (nonatomic, copy) NSString *isFaceAuth; /// 是否实名认证（0:否，1:是）
@property (nonatomic, copy) NSString *isBindBank; /// 是否绑定银行卡（0:否，1:是）
//@property (nonatomic, copy) NSString *authType;   /// 认证类型 1:个人 2:普通企业 3:个体工商户
@property (nonatomic, copy) NSString *customerType;   /// 用户类型 0:普通用户 1:商家
@property (nonatomic, copy) NSString *smallChange;
///已开通的业务线
@property (nonatomic, copy) NSArray <NSString *>*businessLines;
///回收业务线状态 1 显示  0 ：隐藏
@property (nonatomic, assign) BOOL recycleStatus;
///是否开通直播
@property (nonatomic, assign) BOOL hasOpenLiving;
///是够开通回收
@property (nonatomic, assign) BOOL hasOpenRecyle;
///是否开通优店
@property (nonatomic, assign) BOOL hasOpenExcellent;
///是否开通会话设置ID
@property (nonatomic, assign) BOOL hasOpenChat;
///是否可以开播 默认不可以
@property (nonatomic, assign) BOOL isCanOpenChannel;
//直播类型 0:卖场直播间 1:原石直播间 2:定制师直播间 3:回收直播间
@property (nonatomic, assign) int liveType;

///
/// 是否是 普通用户
@property (nonatomic, assign) BOOL blRole_default;
/// 是否是 鉴定主播
@property (nonatomic, assign) BOOL blRole_appraiseAnchor;
/// 是否是 普通卖场主播
@property (nonatomic, assign) BOOL blRole_saleAnchor;
/// 是否是 普通卖场主播助理
@property (nonatomic, assign) BOOL blRole_saleAnchorAssistant;
/// 是否是 社区商户
@property (nonatomic, assign) BOOL blRole_communityShop;
/// 是否是 马甲
@property (nonatomic, assign) BOOL blRole_maJia;
/// 是否是 社区商户+卖货商户
@property (nonatomic, assign) BOOL blRole_communityAndSaleAnchor;
/// 是否是 回血主播
@property (nonatomic, assign) BOOL blRole_restoreAnchor;
/// 是否是 回血主播助理
@property (nonatomic, assign) BOOL blRole_restoreAssistant;
/// 是否是 定制主播
@property (nonatomic, assign) BOOL blRole_customize;
/// 是否是 定制主播助理
@property (nonatomic, assign) BOOL blRole_customizeAssistant;
/// 是否是 回收主播
@property (nonatomic, assign) BOOL blRole_recycle;
/// 是否是 回收主播助理
@property (nonatomic, assign) BOOL blRole_recycleAssistant;


/// 是否是 回收商
@property (nonatomic, assign) BOOL blRole_recycleBusiness;
/// 是否是 图文鉴定师
@property (nonatomic, assign) BOOL blRole_imageAppraise;
@end




NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface UserRole : NSObject
@property (nonatomic, assign)int role; 
@property (nonatomic, copy) NSString * user_id;
NS_ASSUME_NONNULL_END
@end

