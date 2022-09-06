//
//  JHBaseOperationView.h
//  TTjianbao
//
//  Created by apple on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHBaseOperationViewCollectionView.h"
#import "JHSQModel.h"
#import "JHBaseOperationAction.h"
#import "JHPostDetailModel.h"

//NS_ASSUME_NONNULL_BEGIN

@interface JHBaseOperationView : BaseView


/// 分享等操作面板 （空置一排 JHOperationTypeNone）
/// @param upOperationType 第一排
/// @param downOperationType 第二排
/// @param operationBlock 按钮点击回调
+ (JHBaseOperationView *)operationWithUpOperationType:(JHOperationType)upOperationType
                midOperationType:(JHOperationType)midOperationType
                downOperationType:(JHOperationType)downOperationType
                  operationBlock:(void (^)(JHOperationType operationType))operationBlock;


/// 社区交互弹窗
/// @param mode mode description
/// @param operationBlock 点击回调
+ (void)creatSQOperationView:(JHPostData*)mode  Block:(void (^)(JHOperationType operationType))operationBlock;

/// 针对不同模型临时写的方法 等到后面模型统一后 整合方法
/// @param mode mode description
/// @param operationBlock 点击回调
+ (void)creatSQPostDetailOperationView:(JHPostDetailModel*)mode  Block:(void (^)(JHOperationType operationType))operationBlock;

/// 分享面板
/// @param mode mode description
+ (void)creatShareOperationView:(JHShareInfo*)shareInfo object_flag:(NSString *)object_flag;
///新增webpage分享接口，替换umeng分享，跟原来不冲突
+ (void)showShareView:(JHShareInfo*)shareInfo objectFlag:(id)objectFlag;
///新增image分享接口，objectFlag统计使用
+ (void)showShareImageView:(JHShareInfo*)shareInfo objectFlag:(id)objectFlag;

///带回调的分享面板
+ (void)showShareView:(JHShareInfo*)shareInfo objectFlag:(id)objectFlag completion:(void(^)(JHOperationType operationType))block;

/// 板块、话题交互弹窗
/// @param mode mode description
+ (void)creatPlateOperationView:(JHPostData*)shareInfo  Block:(void (^)(JHOperationType operationType))operationBlock;
@end

//NS_ASSUME_NONNULL_END

