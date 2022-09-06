//
//  JHCustomerDescInProcessModel.h
//  TTjianbao
//
//  Created by user on 2020/11/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class JHCustomizeCommentInfoVOModel;
@class JHCustomerDetailVOInfoShareDataModel;

@interface JHAttachmentVOModel : NSObject
@property (nonatomic, strong) NSString  *coverUrl; /// 视频封面
@property (nonatomic, assign) NSInteger  type;     /// 定制师图片类型 0 图片 1 视频 ,
@property (nonatomic, strong) NSString  *url;      /// 地址
@end


@interface JHCustomizeDetailVOModel : NSObject
@property (nonatomic, assign) NSInteger            authCustomize;     /// 是否认证 0未认证 1 已认证
@property (nonatomic, assign) NSInteger            canPraise;         /// 是否可以点赞
@property (nonatomic, assign) NSInteger            canPublish;        /// 是否可以发布 0 不可以 1 可以
@property (nonatomic, assign) NSInteger            channelLocalId;    /// 直播间id
@property (nonatomic, strong) NSString            *channelStatus;     /// 直播状态
@property (nonatomic, strong) NSArray<JHCustomizeCommentInfoVOModel *> *customizeCommentVOS;/// 定制详情

@property (nonatomic, strong) NSString            *customizeTitle;    /// 定制师支撑
@property (nonatomic, strong) NSString            *customizeUserImg;  /// 定制师头像
@property (nonatomic, strong) NSString            *customizeUserName; /// 定制师名字
@property (nonatomic, strong) NSArray<JHAttachmentVOModel *> *materialAttachments; /// 原料图片
@property (nonatomic, assign) BOOL                orderBy; /// 排序 true正 false倒
@property (nonatomic, assign) NSInteger            praiseNum;         /// 点赞数
@property (nonatomic, strong) NSString            *shareUrl;          /// 分享地址
@property (nonatomic, assign) NSInteger            showFlag;    /// 是否展示：0-隐藏、1-展示 ,
@property (nonatomic, assign) NSInteger            status;            /// 状态 1 进行中 2 已完成
@property (nonatomic, strong) NSArray<JHAttachmentVOModel *> *worksAttachments;    /// 完成图片
@property (nonatomic, strong) NSString            *worksDesc;          /// 作品信息
@property (nonatomic, assign) NSInteger            worksId;            /// 作品id
@property (nonatomic, strong) NSString            *worksName;         /// 作品名字
@property (nonatomic, strong) JHCustomerDetailVOInfoShareDataModel *shareDataVO; /// 分享
/// 新增
@property (nonatomic, strong) NSString            *addCommentFlag; /// 是否可以添加沟通信息 0 不可以 1 可以

@property (nonatomic, assign) BOOL                showHideFlag; /// 是否有隐藏按钮
@end


/// 分享
@interface JHCustomerDetailVOInfoShareDataModel : NSObject
@property (nonatomic,   copy) NSString *title;
@property (nonatomic,   copy) NSString *url;
@property (nonatomic,   copy) NSString *img;
@property (nonatomic,   copy) NSString *desc;
@end



/*
 * 时间轴
 */

@class JHCustomizeCommentItemVOSModel;
@class JHCustomizeCommentPublishImgList;

@interface JHCustomizeCommentInfoVOModel : NSObject
@property (nonatomic, strong) NSString *customerImg; /// 头像
@property (nonatomic, strong) NSString *customerName; /// 用户名字
@property (nonatomic, assign) NSInteger customizeCommentId;     /// 过程id
@property (nonatomic, strong) NSArray<JHCustomizeCommentItemVOSModel *> *customizeCommentItemVOS; /// 评论信息
@property (nonatomic, strong) NSString *publishDesc; /// 发布内容
@property (nonatomic, strong) NSArray<JHCustomizeCommentPublishImgList *> *publishImgList; /// 发布图片
@property (nonatomic, strong) NSString *publishType; /// 发布类型消息
@property (nonatomic, strong) NSString *pushTimeStr; /// 发布时间字符串
@property (nonatomic, assign) BOOL      isFirst;
@property (nonatomic, strong) NSString *finishFlag;  /// 是否完成 0 未完成 1 已完成
@end


/// 评论信息
@interface JHCustomizeCommentItemVOSModel : NSObject
@property (nonatomic, strong) NSArray<JHCustomizeCommentPublishImgList *> *commentItemImgList; /// 评论图片
@property (nonatomic, strong) NSString *content; /// 评论内容
@property (nonatomic, strong) NSString *customerName; /// 用户名字
@property (nonatomic, strong) NSString *pushTimeStr; /// 发布时间字符串
@end

/// 图片
@interface JHCustomizeCommentPublishImgList : NSObject
@property (nonatomic, strong) NSString *coverUrl; /// 视频封面
@property (nonatomic, strong) NSString *url; /// 地址
@property (nonatomic, assign) NSInteger type;     /// 定制师图片类型 0 图片 1 视频
@end









/// 添加补充信息
@interface JHCustomizeCommentRequestModel :NSObject
@property (nonatomic, strong) NSString *content; /// 发布内容
@property (nonatomic, assign) NSInteger customizeCommentId;  // 定制过程ID 评论信息必传
@property (nonatomic, assign) NSInteger customizeOrderId; /// 定制订单ID 过程消息必传
@property (nonatomic, strong) NSString *publishType;/// 发布类型 1 发布内容 2 创建定制服务 3 提交定制方案 4 完成制作提交了成品信息 5 删除定制方案
@property (nonatomic, strong) NSArray <JHAttachmentVOModel *>*imgList; /// 发布图片

@end



NS_ASSUME_NONNULL_END
