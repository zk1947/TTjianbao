//
//  JHVoucherCreateModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  创建代金券数据
//

#import "JHVoucherCreateModel.h"
#import "TTjianbaoHeader.h"

@interface JHVoucherCreateModel ()
@property (nonatomic, strong) NSArray<JHVoucherGroupItem *> *groupList;
@end

@implementation JHVoucherCreateModel

- (instancetype)initWithCarryTimeType:(NSString *)carryTimeType {
    self = [super init];
    if (self) {
        [self initObject];
        _carryTimeType = carryTimeType;
        [self configGroupList];
        
        _sellerId = [UserInfoRequestManager sharedInstance].user.customerId;
        _creatorId = [UserInfoRequestManager sharedInstance].user.customerId;
        _createUserName = [UserInfoRequestManager sharedInstance].user.name;
        _receiveMode = @"0";
    }
    return self;
}

//子类自动实现属性alloc的过程
- (void)initObject {
    unsigned int outCount;
    objc_property_t *properties =class_copyPropertyList([self class], &outCount);
    for ( int i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_name =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_name];
        
        const char *attri = property_getAttributes(property);
        NSString *attStr = [NSString stringWithUTF8String:attri] ;
        
        if ([attStr containsString:@"NSString"]) {
            [self setValue:@"" forKeyPath:propertyName] ;
        } else if ([attStr containsString:@"NSArray"] || [attStr containsString:@"NSMutableArray"]) {
            [self setValue:@[] forKeyPath:propertyName] ;
        } else if ([attStr containsString:@"NSDictionary"] || [attStr containsString:@"NSMutableDictionary"]) {
            [self setValue:@{} forKeyPath:propertyName] ;
        } else if ([attStr containsString:@"NSNumber"]) {
            [self setValue:@0 forKeyPath:propertyName] ;
        }
    }
    free(properties);
}

- (void)configGroupList {
    //Group 0
    JHVoucherCellItem *item0 = [JHVoucherCellItem
                                itemTitle:@"类型：" value:_type placeholder:@"请选择类型"];
    JHVoucherCellItem *item1 = [JHVoucherCellItem
                                itemTitle:@"代金券名称：" value:_name placeholder:@"最多十个字符以内"];
    JHVoucherCellItem *item2 = [JHVoucherCellItem
                                itemTitle:@"代金券面值：" value:_price placeholder:@"请输入1-100000之间的金额"];
    JHVoucherCellItem *item3 = [JHVoucherCellItem
                                itemTitle:@"满减条件：" value:_condition placeholder:@"请输入满减起步金额"];
    JHVoucherCellItem *item4 = [JHVoucherCellItem
                                itemTitle:@"发行数量：" value:_count placeholder:@"请输入1-9999999之间的数字"];
//    JHVoucherCellItem *item5 = [JHVoucherCellItem
//                                itemTitle:@"每名用户可领取数量：" value:_singleCount placeholder:@"请输入1-999999之间的数字"];
    //Group 1
    JHVoucherCellItem *item6 = [JHVoucherCellItem
                                itemTitle:@"领取方式：" value:_receiveMode placeholder:nil];
    JHVoucherCellItem *item7 = [JHVoucherCellItem
                                itemTitle:@"时间类型：" value:_timeType placeholder:@"有效期/有效时间"];
    JHVoucherCellItem *item8 = [JHVoucherCellItem
                                itemTitle:@"有效期：" value:_usableDays placeholder:@"请输入有效天数"];
    JHVoucherCellItem *item9 = [JHVoucherCellItem
                                itemTitle:@"开始时间：" value:_startTime placeholder:@"请选择时间"];
    JHVoucherCellItem *item10 = [JHVoucherCellItem
                                 itemTitle:@"结束时间：" value:_endTime placeholder:@"请选择时间"];
    
    item0.key = @"type";
    item1.key = @"name";
    item2.key = @"price";
    item3.key = @"condition";
    item4.key = @"count";
//    item5.key = @"singleCount";
    item6.key = @"receiveMode";
    item7.key = @"timeType";
    item8.key = @"usableDays";
    item9.key = @"startTime";
    item10.key = @"endTime";
    
    JHVoucherGroupItem *group0 = [JHVoucherGroupItem groupWithItems:@[item0,item1,item2,item3,item4]];
    if (_groupList.count == 2) {
        group0 = _groupList.firstObject;
        NSMutableArray *items = group0.cellItems.mutableCopy;
        JHVoucherCellItem *item = items[2];
        if ([self.type isEqualToString:@"OD"]) {
            item.title = @"代金券折扣：";
            item.placeholder = @"请输入0-10之间的折扣";
        } else {
            item.title = @"代金券面值：";
            item.placeholder = @"请输入1-100000之间的金额";
        }

    }
    
    
    JHVoucherGroupItem *group1 = [JHVoucherGroupItem groupWithItems:@[item6, item7,item8,item9,item10]];
    if ([self.carryTimeType isEqualToString:@"R"]) {
        group1 = [JHVoucherGroupItem groupWithItems:@[item6,item8]];
    } else if ([self.carryTimeType isEqualToString:@"A"]) {
        group1 = [JHVoucherGroupItem groupWithItems:@[item6, item9,item10]];
    } else {
        //两种都支持时 默认值为有效期
        if (_groupList.count == 2) {
            group0 = _groupList.firstObject;
            item6 = _groupList.lastObject.cellItems.firstObject;
        }
        NSString *value = [self valueForKey:item7.key];
        if ([value isEmpty]) {
            [self setValue:@"R" forKey:item7.key];
        }
        value = [self valueForKey:item7.key];
        if ([value isEqualToString:@"R"]) {
            item7.value = @"有效间";
            group1 = [JHVoucherGroupItem groupWithItems:@[item6,item7,item8]];
        } else if ([value isEqualToString:@"A"]) {
            item7.value = @"有效时间";
            group1 = [JHVoucherGroupItem groupWithItems:@[item6,item7, item9,item10]];
        }
    }
    if (![_carryTimeType isEmpty]) {
        [self setValue:_carryTimeType forKey:item7.key];
    }
    _groupList = @[group0, group1];
}

- (NSDictionary *)toParams {
    NSDictionary *params = @{@"sellerId" : [UserInfoRequestManager sharedInstance].user.customerId,
                             @"creatorId" : [UserInfoRequestManager sharedInstance].user.customerId,
                             @"createUserName" : [UserInfoRequestManager sharedInstance].user.name,
                             @"ruleType" : _type,
                             @"name" :_name,
                             @"price" : _price,
                             @"ruleFrCondition" : _condition,
                             @"count" : _count,
                             @"perNum" : _singleCount,
                             @"getType" : _receiveMode,
                             @"timeType" : _timeType,
                             @"timeTypeRDay" : _usableDays,
                             @"timeTypeAStartTime" : _startTime,
                             @"timeTypeAEndTime" : _endTime
    };
    return params;
}

@end


#pragma mark - JHVoucherGroupItem <列表分组数据>
@implementation JHVoucherGroupItem

+ (instancetype)groupWithItems:(NSArray<JHVoucherCellItem *> *)cellItems {
    JHVoucherGroupItem *group = [[JHVoucherGroupItem alloc] init];
    group.cellItems = cellItems.mutableCopy;
    return group;
}

@end

#pragma mark - JHVoucherCellItem <列表行数据>
@implementation JHVoucherCellItem

+ (instancetype)itemTitle:(NSString *)title
                    value:(NSString * _Nullable)value
              placeholder:( NSString * _Nullable)placeholder
{
    JHVoucherCellItem *item = [[JHVoucherCellItem alloc] init];
    item.title = title;
    item.value = value;
    item.placeholder = placeholder;
    return item;
}

- (void)setValue:(NSString *)value {
    _value = value;
    if ([_key isEqualToString:@"type"]) {
        //ruleType (string, optional): FR:满减 ，OD:折扣券, EFR:每满减 ,
        if ([value isEqualToString:@"满减"]) {
            [_createModel setValue:@"FR" forKey:_key];
        } else if ([value isEqualToString:@"每满减"]) {
            [_createModel setValue:@"EFR" forKey:_key];
        } else if ([value isEqualToString:@"折扣券"]) {
            [_createModel setValue:@"OD" forKey:_key];
        }
        
    } else if ([_key isEqualToString:@"receiveMode"]) {
        //getType (string, optional): 领取方式： 0：领取 1：发放
        if ([value isEqualToString:@"0"]) {
            [_createModel setValue:@"0" forKey:_key];
        } else if ([value isEqualToString:@"1"]) {
            [_createModel setValue:@"1" forKey:_key];
        }
        
    } else if ([_key isEqualToString:@"timeType"]) {
        //timeType (string, optional): 使用时间类型:R相对时间,A:绝对时间
        if ([value isEqualToString:@"有效期"]) {
            [_createModel setValue:@"R" forKey:_key];
        } else if ([value isEqualToString:@"有效时间"]) {
            [_createModel setValue:@"A" forKey:_key];
        }
        
    } else {
        [_createModel setValue:value forKey:_key];
    }
}

@end
