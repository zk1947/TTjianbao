//
//  JHRecyclePublishButtonView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHRecyclePublishedModel.h"
#import "JHRecyclePriceModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PublishButtonTagDetail = 100,     //详情
    PublishButtonTagOffShelves,       //下架
    PublishButtonTagDeal,             //确认交易
    PublishButtonTagDelete,           //删除
    PublishButtonTagOnSale,           //上架
} PublishButtonTag;

@interface JHRecyclePublishButtonView : BaseView
/** 发布状态*/
@property (nonatomic, assign) PublishedStatusType statusType;
/** 来源*/
@property (nonatomic, assign) NSInteger fromIndex;
/** 个别点击事件的回调*/
@property (nonatomic, copy) void(^clickActionBlock)(PublishButtonTag buttonTag);
/** 刷新主页面UI的回调*/
@property (nonatomic, copy) void(^refreshUIBlock)(void);
/** 商品id*/
@property (nonatomic, copy) NSString *productId;
/** 报价model*/
@property (nonatomic, strong) JHRecyclePriceModel *bidModel;
/** 商品model*/
@property (nonatomic, strong) JHRecyclePublishedModel *publishModel;

/// 根据状态来判断显示什么按钮
/// @param statusType 状态
/// @param fromIndex 来源 主要是列表和详情页 默认0 = 列表,1 = 详情页
- (void)setStatusType:(PublishedStatusType)statusType fromIndex:(NSInteger)fromIndex;
@end

NS_ASSUME_NONNULL_END
