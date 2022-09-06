//
//  JHSQManager.h
//  TTjianbao
//
//  Created by wuyd on 2019/9/28.
//  Copyright © 2019 Netease. All rights reserved.
//  社区管理类
//

#import <Foundation/Foundation.h>
#import "TTjianbaoMarcoEnum.h"
#import "JHContactListViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHAlertSheetControllerAction) {
    ///回复
    JHAlertSheetControllerActionReply = 1,
    ///复制
    JHAlertSheetControllerActionCopy,
    ///删除
    JHAlertSheetControllerActionDelete,
    ///举报
    JHAlertSheetControllerActionReport,
    ///警告
    JHAlertSheetControllerActionWarning,
    ///禁言
    JHAlertSheetControllerActionBanned,
    ///封号
    JHAlertSheetControllerActionBlockAccount,
    ///取消
    JHAlertSheetControllerActionCancel,
};

@class CBridgeData;
@class JHPublisher;
@class JHUserInfoModel;
@class JHPostDetailModel;
@class JHCommentModel;

@interface JHSQManager : NSObject

+ (instancetype)shareSQManger;

#pragma mark - 判断是否首次安装启动app
///是否首次安装启动
+ (BOOL)isFirstLaunch;

///校验社区文章是否合法
+ (BOOL)isValid:(CBridgeData *)data;

///检查是否需要选择社区频道
+ (void)checkSQChannelNeedToSelectCompleteBlock:(dispatch_block_t)completeBlock;

#pragma mark - 静音管理

///获取静音状态
+ (BOOL)isMute;
///开启静音模式
+ (void)setMute:(BOOL)isMute;

#pragma mark - 商家认证

///校验是否需要跳转商户认证
+ (BOOL)needAutoEnterMerchantVC;
///进入商家认证
+ (void)enterMerchantVC;

#pragma mark - 社区web页跳转
///进入帖子详情web页
/// @param itemType 帖子类型
/// @param itemId 帖子ID
/// @param scrollComment 0-不做处理   1-滚动到评论  2-滚动到评论+弹起评论框
/// @param pageFrom 页面来源
+ (void)enterPostDetailWebWithItemType:(JHPostItemType)itemType itemId:(NSString *)itemId pageFrom:(NSString *)pageFrom scrollComment:(NSInteger)scrollComment;

#pragma mark - 社区普通页面跳转
///进入用户个人主页<内部区分进入直播间、进入个人主页、进入鉴定师主页>
+ (void)enterUserInfoVCWithPublisher:(JHPublisher *)publisher;

///获取勋章信息
+ (NSArray *)getUserMedalInfo:(JHUserInfoModel *)userInfo;

///判断是否是用户本人
+ (BOOL)isAccount:(NSString *)userId;

+ (BOOL)needLogin;


/// 显示alertsheet
/// @param titles 需要展示的数组
/// @param actionBlock actionBlock description
+ (void)jh_showAlertSheetController:(NSArray <NSString *>*)titles isSelf:(BOOL)isSelf actionBlock:(void(^)(JHAlertSheetControllerAction sheetAction,NSString *reason, NSString *reasonId, NSInteger timeType))actionBlock;

///长按评论时弹框的事件title
+ (NSArray *)commentActions:(JHPostDetailModel *)postDetailInfo comment:(JHCommentModel *)comment;

/// 删除、警告、禁言 操作弹框
+ (void)jh_showAlertSheetReasonWithType:(JHAlertSheetControllerAction)type;

///输入@后跳转到选择联系人界面
+ (void)enterCallUsetListPage;
///带跳转结果的方法
+ (void)enterCallUsetListPage:(SelectRowBlock)block;

@end


#pragma mark - 页面跳转中间层数据（主要用于推送数据查询）
@interface CBridgeData : NSObject
@property (nonatomic,   copy) NSString *item_id;
@property (nonatomic, assign) JHSQItemType item_type; //item_id和item_type一起标识商品唯一性
@property (nonatomic, assign) JHSQLayoutType layout;
@property (nonatomic, assign) NSInteger cate_id;
@end

NS_ASSUME_NONNULL_END
