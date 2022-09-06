//
//  JHBusinessGoodsAttributeModel.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessGoodsAttributeSelectModel : NSObject
//属性名称
@property (nonatomic, strong) NSString *attrName;
//是否选中（0否 1是）
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSString *textStr;
@end

@interface JHBusinessGoodsAttributeModel : NSObject
//主键
@property (nonatomic, assign) long id;
//后台分类id
@property (nonatomic, assign) long backCateId;
//属性id
@property (nonatomic, assign) long attrId;
//属性名称
@property (nonatomic, strong) NSString *attrName;
//是否必填（0否 1是）
@property (nonatomic, assign) int attrRequired;
//属性值类型（0单选项、1自定义、2枚举值、3单选项+自定义、4复选项）
@property (nonatomic, assign) NSInteger attrValueType;
//属性值（逗号分隔）
@property (nonatomic, copy) NSString * attrValue;

@property (nonatomic, copy) NSString * showValue;//显示值
//排序
@property (nonatomic, assign) NSInteger sort;
@end

NS_ASSUME_NONNULL_END
