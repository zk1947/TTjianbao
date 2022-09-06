//
//  JHC2CUploadProductDetailModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface BackAttrRelationResponse : NSObject

//主键
@property (nonatomic, copy) NSString* keyID;
//后台分类id
@property (nonatomic, copy) NSString* backCateId;
//属性id
@property (nonatomic, copy) NSString* attrId;
//属性名称
@property (nonatomic, copy) NSString* attrName;
//属性值（逗号分隔）
@property (nonatomic, copy) NSString* attrValue;
//排序
@property (nonatomic, copy) NSString* sort;

@end

@interface BackProductPicConfResponse : NSObject

//主键id
@property (nonatomic, copy) NSString* keyID;
//图片类型 1-示例图 2-包装原则示例图
@property (nonatomic, copy) NSString* imgType;
//分类id
@property (nonatomic, copy) NSString* cateId;
//示例主表id
@property (nonatomic, copy) NSString* sampleId;
//示例名称
@property (nonatomic, copy) NSString* sampleName;
//示例图图片地址
@property (nonatomic, copy) NSString* imageUrl;
//商品排序
@property (nonatomic, copy) NSString* sort;

@end


@interface AppraisalCategoryAttrDTO : NSObject

//鉴定费用
@property (nonatomic, copy) NSString* appraisalFee;
//分类鉴定开关，true 开 false 关
@property (nonatomic, assign) BOOL hasOpen;
//分类鉴定开关，1 开 0 关
@property (nonatomic, copy) NSString* openFlag;
//预计鉴定完成时间 暂时不用
@property (nonatomic, copy) NSString* preAppraisalCompletedTime;


@end

@interface OrdermyCouponVoInfoResp : NSObject

@property (nonatomic, copy) NSString* couponId;

@property (nonatomic, copy) NSString* name;

@property (nonatomic, copy) NSString* price;

@end

@interface OrderDiscountListResp : NSObject

//name
@property (nonatomic, copy) NSArray<OrdermyCouponVoInfoResp*> * myCouponVoList;

@end



@interface JHC2CUploadProductDetailModel : NSObject

//分类属性
@property (nonatomic, strong) NSArray< BackAttrRelationResponse* > * backAttrRelationResponses;
//商品示例图
@property (nonatomic, strong) NSArray< BackProductPicConfResponse*> * backProductPicConfResponses;
//是否可以鉴定结果类
@property (nonatomic, strong) AppraisalCategoryAttrDTO* appraisalCategoryAttrDTO;

//是否可以鉴定结果类
@property (nonatomic, strong) OrderDiscountListResp * orderDiscountListResp;


@end


NS_ASSUME_NONNULL_END
