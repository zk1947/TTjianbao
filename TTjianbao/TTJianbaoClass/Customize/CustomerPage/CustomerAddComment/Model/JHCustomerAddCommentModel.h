//
//  JHCustomerAddCommentModel.h
//  TTjianbao
//
//  Created by user on 2020/11/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface JHCustomerAddCommentAttachmentVOModel:NSObject
@property (nonatomic, strong) NSString *coverUrl; /// 视频封面
@property (nonatomic, strong) NSString *url;      /// 地址
@property (nonatomic, assign) NSInteger type;     /// 定制师图片类型 0 图片 1 视频
@end


@interface JHCustomerAddCommentModel : NSObject
@property (nonatomic, strong) NSString *content; /// 发布内容
@property (nonatomic, assign) NSInteger customizeCommentId; /// 定制过程ID 评论信息必传
@property (nonatomic, assign) NSInteger customizeOrderId;   /// 定制订单ID 过程消息必传
@property (nonatomic, strong) NSArray<JHCustomerAddCommentAttachmentVOModel *> *imgList; /// 发布图片
/// 发布类型 1 发布内容 2 创建定制服务 3 提交定制方案 4 完成制作提交了成品信息 5 删除定制方案
@property (nonatomic, strong) NSString *publishType;
@end






NS_ASSUME_NONNULL_END
