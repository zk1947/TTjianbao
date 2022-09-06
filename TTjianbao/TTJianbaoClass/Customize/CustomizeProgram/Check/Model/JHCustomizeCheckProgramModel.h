//
//  JHCustomizeCheckProgramModel.h
//  TTjianbao
//
//  Created by user on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JHCustomizeCheckProgramPictsModel;
@interface JHCustomizeCheckProgramModel : NSObject
@property (nonatomic,   copy) NSString *createTime;       ///  创建时间
@property (nonatomic, assign) NSInteger customizeFeeId;   /// 类别id
@property (nonatomic,   copy) NSString *customizeFeeName; /// 类别名字
@property (nonatomic, assign) NSInteger customizeOrderId; /// 定制订单id
@property (nonatomic, strong) NSString *extPrice;         /// 金额 单位分
@property (nonatomic, assign) NSInteger ID;               /// id
@property (nonatomic,   copy) NSString *planDesc;         /// 方案说明
@property (nonatomic, strong) NSArray<JHCustomizeCheckProgramPictsModel *> *attachmentVOs;  /// 方案设计图像信息
@property (nonatomic, strong) NSString *planPrice;        /// 金额 单位分
@property (nonatomic, strong) NSString *status;           /// 状态 0 待提交 1 待确认 2 已确认 3 拒绝 ,
@end

/// 图片
@interface JHCustomizeCheckProgramPictsModel : NSObject
@property (nonatomic, strong) NSString *coverUrl; /// 封面图片
@property (nonatomic, assign) NSInteger type;     /// 定制师图片类型 0 图片 1 视频
@property (nonatomic, strong) NSString *url;      /// 地址
@end









NS_ASSUME_NONNULL_END
