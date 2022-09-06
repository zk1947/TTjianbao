//
//  JHVoucherCreateModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  创建代金券数据
//

#import <Foundation/Foundation.h>

@class JHVoucherGroupItem;
@class JHVoucherCellItem;

NS_ASSUME_NONNULL_BEGIN

@interface JHVoucherCreateModel : NSObject

@property (nonatomic, strong) NSString *sellerId; //卖家id <sellerId>
@property (nonatomic, strong) NSString *creatorId; //创建者id <creatorId>
@property (nonatomic, strong) NSString *createUserName; //创建人名字 <createUserName>
@property (nonatomic, strong) NSString *type; //代金券类型 <ruleType>
@property (nonatomic, strong) NSString *name; //名称 <name>
@property (nonatomic, strong) NSString *price; //代金券面值 <price> NSNumber
@property (nonatomic, strong) NSString *condition; //满减条件 <ruleFrCondition> NSNumber
@property (nonatomic, strong) NSString *count; //发行数量 <count> NSNumber
@property (nonatomic, strong) NSString *singleCount; //每名用户可领取数量 <perNum> NSNumber
@property (nonatomic, strong) NSString *receiveMode; //领取方式 <getType>
@property (nonatomic, strong) NSString *timeType; //时间类型：R相对时间，A绝对时间 <timeType>
@property (nonatomic, strong) NSString *usableDays; //有效期、可用天数 <timeTypeRDay> NSNumber
@property (nonatomic, strong) NSString *startTime; //开始时间 <timeTypeAStartTime>
@property (nonatomic, strong) NSString *endTime; //结束时间 <timeTypeAEndTime>

//列表静态显示数据
@property (nonatomic, strong, readonly) NSArray<JHVoucherGroupItem *> *groupList;

- (NSDictionary *)toParams;


/// 客户端支持的时间类型 R有效期 A有效时间 nil两种都支持
@property (nonatomic, copy) NSString *carryTimeType;

/// 初始化支持某种时间类型
/// @param carryTimeType 同上参数
- (instancetype)initWithCarryTimeType:(NSString *)carryTimeType;
- (void)configGroupList;
@end


#pragma mark - JHVoucherGroupItem <列表分组数据>
@interface JHVoucherGroupItem : NSObject
@property (nonatomic, strong) NSArray<JHVoucherCellItem *> *cellItems;
+ (instancetype)groupWithItems:(NSArray<JHVoucherCellItem *> *)cellItems;
@end

#pragma mark - JHVoucherCellItem <列表行数据>
@interface JHVoucherCellItem : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) JHVoucherCreateModel *createModel;

+ (instancetype)itemTitle:(NSString *)title
                    value:(NSString * _Nullable)value
              placeholder:( NSString * _Nullable)placeholder;
@end

NS_ASSUME_NONNULL_END
