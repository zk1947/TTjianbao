//
//  JHVoucherListModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  代金券列表数据
//

#import "YDBaseModel.h"

@class JHVoucherListData;

NS_ASSUME_NONNULL_BEGIN

@interface JHVoucherListModel : YDBaseModel

@property (nonatomic, copy) NSString *sellerId; //自定义 - 卖家id
@property (nonatomic, strong) NSMutableArray<JHVoucherListData *> *list;

- (NSString *)toValidUrl; //直播间卖家可以发放给个人的代金券列表接口
- (void)configModel:(JHVoucherListModel *)model;

@end

@interface JHVoucherListData : NSObject
@property (nonatomic,   copy) NSString *creatorId; //(string, optional): 创建者id
@property (nonatomic, assign) NSInteger voucherId; //(integer, optional): 代金券id <id>
@property (nonatomic, assign) NSInteger count; //(integer, optional): 优惠券数量
@property (nonatomic,   copy) NSString *delFlag; //(string, optional): 优惠券状态。0正常1删除
@property (nonatomic,   copy) NSString *getType; //(string, optional): 领用方式： 0：领取券 1：发放
@property (nonatomic,   copy) NSString *name; // (string, optional): 代金券名称
@property (nonatomic,   copy) NSString *remark; // (string, optional): 代金券使用说明
@property (nonatomic, strong) NSNumber *price; // (number, optional): 满减金额
@property (nonatomic, strong) NSNumber *ruleFrCondition; // (number, optional): 满减条件
@property (nonatomic,   copy) NSString *ruleType; // (string, optional): 使用类型 FR:满减 ，OD:折扣券, EFR:每满减
@property (nonatomic,   copy) NSString *sellerId; // (string, optional): 卖家id
@property (nonatomic,   copy) NSString *showEndTime; // (string, optional): 结束领取时间
@property (nonatomic,   copy) NSString *timeType; // (string, optional): 使用时间类型:R相对时间,A:绝对时间
@property (nonatomic,   copy) NSString *timeTypeAEndTime; // (string, optional): 绝对时间结束时间
@property (nonatomic,   copy) NSString *timeTypeAStartTime; // (string, optional): 绝对时间开始时间
@property (nonatomic, assign) NSInteger timeTypeRDay; // (integer, optional): 相对时间可用天数
@property (nonatomic,   copy) NSString *viewValue; // (string, optional): 前端显示样式9，1折，200元

@property (nonatomic, assign) BOOL checkedStatus; //选中状态 默认NO

@end

NS_ASSUME_NONNULL_END
