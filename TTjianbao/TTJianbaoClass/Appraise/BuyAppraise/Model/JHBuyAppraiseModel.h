//
//  JHBuyAppraiseModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAppraiseUrlModel : NSObject
/** 小图*/
@property (nonatomic, copy) NSString *thumbsPictureUrl;
/** 中图*/
@property (nonatomic, copy) NSString *mediumPictureUrl;
/** 大图*/
@property (nonatomic, copy) NSString *largePictureUrl;
@end

@interface JHAppraiseUrlArrayModel : NSObject
/** 小图*/
@property (nonatomic, strong) NSArray *thumbsPictureUrls;
/** 中图*/
@property (nonatomic, strong) NSArray *mediumPictureUrls;
/** 大图*/
@property (nonatomic, strong) NSArray *largePictureUrls;
@end

@interface JHAppraiseTrueModel : NSObject
/** 性价比分值*/
@property (nonatomic, copy) NSString *scoreCost;
/** 工艺分值*/
@property (nonatomic, copy) NSString *scoreCraft;
/** 保值空间分值*/
@property (nonatomic, copy) NSString *scoreHedging;
/** 稀有度分值*/
@property (nonatomic, copy) NSString *scoreRare;
/** 价值*/
@property (nonatomic, copy) NSString *amount;
@end

@interface JHAppraiseFalseModel : NSObject
/** 处理商家*/
@property (nonatomic, copy) NSString *businessName;
/** 问题件种类*/
@property (nonatomic, copy) NSString *qualitySecondType;
/** 处理时间*/
@property (nonatomic, copy) NSString *time;
/** 退款方式  0 - 全退  1 -部分退*/
@property (nonatomic, copy) NSString *handleType;
/** 价值*/
@property (nonatomic, copy) NSString *amount;
@end

@interface JHAppraiseInfoModel : NSObject
/** 头像*/
@property (nonatomic, strong) JHAppraiseUrlModel *appraiserHeader;
/** 名字*/
@property (nonatomic, copy) NSString *appraiserName;
/** id*/
@property (nonatomic, copy) NSString *appraiserId;
@end

@interface JHBuyAppraiseModel : NSObject

/** 商品id*/
@property (nonatomic, copy) NSString *shoppingId;
/** 展示类型 0 = 视频 1= 图片*/
@property (nonatomic, copy) NSString *showType;
/** 描述*/
@property (nonatomic, copy) NSString *appraiseDesc;
/** 时间戳*/
@property (nonatomic, copy) NSString *datetime;
/** 视频地址*/
@property (nonatomic, copy) NSString *videoUrl;
/** 视频封面*/
@property (nonatomic, strong) JHAppraiseUrlModel *videoImgUrl;
/** 图片地址列表*/
@property (nonatomic, strong) JHAppraiseUrlArrayModel *pictureUrls;
/** 鉴定真假 0 = 真 1 = 假*/
@property (nonatomic, copy) NSString *appraiseType;
/** 鉴定人信息模型*/
@property (nonatomic, strong) JHAppraiseInfoModel *appraiser;
/** 鉴定为真模型*/
@property (nonatomic, strong) JHAppraiseTrueModel *positive;
/** 鉴定为假模型*/
@property (nonatomic, strong) JHAppraiseFalseModel *negative;
/**自定义属性:列表中的下标*/
@property (nonatomic, assign) NSInteger listIndex;
@end

NS_ASSUME_NONNULL_END
