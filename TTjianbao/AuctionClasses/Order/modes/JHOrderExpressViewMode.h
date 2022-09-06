//
//  JHOrderExpressViewMode.h
//  TTjianbao
//
//  Created by jiangchao on 2021/2/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpressMode.h"
typedef NS_ENUM(NSUInteger, JHExpressSectionType) {
    /// 卖家发货部分
    JHExpressSectionSellerSend = 0,
    /// 平台鉴定部分
    JHExpressSectionPlatAppraise,
    /// 平台发货部分
    JHExpressSectionPlatSend,

};

typedef NS_ENUM(NSUInteger, JHExpressStepType) {
    /// 到卖家发货步骤
    JHExpressStepTypeSellerSend = 0,
    /// 到平台鉴定步骤
    JHExpressStepTypePlatAppraise,
    /// 到平台发货步骤
    JHExpressStepTypePlatSend,

};

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderExpressSectionMode : NSObject

//0 是卖家发货  1是平台查验   2是平台发货
@property (nonatomic, assign)  JHExpressSectionType  sectionType;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, assign) NSInteger rowIndex;

@end

@interface JHOrderExpressViewMode : NSObject
/// cell 集合- 存储类表所需所有  cellViewModel
@property (nonatomic, strong) NSMutableArray<JHOrderExpressSectionMode *> *sectionList;
- (void)getExpressInfo;
/// 刷新tableview
@property (nonatomic, strong) RACReplaySubject *refreshTableView;
@property (nonatomic, strong) NSArray<ExpressAppraiseMode *> *orderMlOptHisVos;//平台鉴定信息
@property (nonatomic, strong)  ExpressVo*platSendExpressVo;//平台发货物流信息
@property (nonatomic, strong)  ExpressOrderStatusModel *orderStatusModel;//卖家发货物流信息
//0 是到卖家发货  1是平台查验   2是到平台发货
@property (nonatomic, assign)  JHExpressStepType  expressStep;
@property (nonatomic, strong)  NSString *orderId;
@end

NS_ASSUME_NONNULL_END
