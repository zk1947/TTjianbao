//
//  JHStonePersonReSellPublishModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStonePersonReSellPublishMediaModel : NSObject

 /// 资源路径
@property (nonatomic, copy) NSString *url;

/// 封面路径
@property (nonatomic, copy) NSString *coverUrl;

/// 1图片   2视频
@property (nonatomic, assign) NSInteger type;

@end

@interface JHStonePersonReSellPublishModel : NSObject

@property (nonatomic, strong) NSMutableArray <JHStonePersonReSellPublishMediaModel *> *urlList;

/// 原石个人转售Id
@property (nonatomic, copy) NSString *stoneResaleId;

/// 源订单id
@property (nonatomic, copy) NSString *sourceOrderId;

/// 源订单code
@property (nonatomic, copy) NSString *sourceOrderCode;

/// 标题
@property (nonatomic, copy) NSString *title;

/// 描述
@property (nonatomic, copy) NSString *memo;

/// 重量
@property (nonatomic, copy) NSString *weight;

/// 数量
@property (nonatomic, copy) NSString *count;

/// 售价
@property (nonatomic, copy) NSString *salePrice;

/// 转售原石来源：0-原石（从已完成订单过来的）、1-回血（从买入原石列表过来的），默认1 ,
@property (nonatomic, copy) NSString *sourceTypeFlag;

@end

NS_ASSUME_NONNULL_END
