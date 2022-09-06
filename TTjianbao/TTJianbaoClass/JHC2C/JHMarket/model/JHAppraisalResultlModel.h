//
//  JHAppraisalResultlModel.h
//  TTjianbao
//
//  Created by 张坤 on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHAppraisalAttrsResultlModel,JHAppraisalAttrValuesModel;

@interface JHAppraisalResultlModel : NSObject
/// 取消理由类型
@property (nonatomic, copy) NSString *appraisalResultCode;
/// 取消理由
@property (nonatomic, copy) NSString *appraisalResultName;
@property(strong,nonatomic) NSArray<JHAppraisalAttrsResultlModel *> *attrs;

@end

@interface JHAppraisalAttrsResultlModel : NSObject
/// 取消理由类型
@property (nonatomic, copy) NSString *attrName;
/// 属性值类型 0 固定值 显示  key  value /  1 自定义-输入框 2 单选- 单选按钮 3 枚举值-下拉框 4 单选+输入
@property (nonatomic, copy) NSString *attrValueType;
/// 取消理由类型
@property (nonatomic, copy) NSString *categoryAttrId;
/// 取消理由
@property (nonatomic, copy) NSString *categoryFirstId;
/// 取消理由类型
@property (nonatomic, copy) NSString *categorySecondId;
/// 取消理由
@property (nonatomic, copy) NSString *fieldName;
/// 取消理由类型
@property (nonatomic, copy) NSString *fieldType;
/// 取消理由
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *otherDesc;
@property (nonatomic, copy) NSString *required;
@property (nonatomic, copy) NSArray *selectedAttrValues;
@property (nonatomic, strong) NSArray<JHAppraisalAttrValuesModel *> *attrValues;
@property (nonatomic, copy) NSString *sortFlag;
@end

@interface JHAppraisalAttrValuesModel : NSObject
/// 取消理由类型
@property (nonatomic, copy) NSString *name;
/// 取消理由
@property (nonatomic, copy) NSString *code;

@end

NS_ASSUME_NONNULL_END
