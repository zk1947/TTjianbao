//
//  JHRecyclePublishedModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHRecyclePriceModel;
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PublishedStatusTypeNoPrice,      //无报价
    PublishedStatusTypeHavePrice,    //有报价
    PublishedStatusTypeFailure,      //失效的
    PublishedStatusTypeRefused,      //平台拒绝
} PublishedStatusType;


// 图片模型,大中小图
@interface JHRecycleImageModel : NSObject
/** 小图*/
@property(nonatomic, strong) NSString *small;
/** 中图*/
@property(nonatomic, strong) NSString *medium;
/** 大图*/
@property(nonatomic, strong) NSString *big;
@end

@interface JHRecyclePublishedModel : NSObject
/** 发布的状态*/
@property (nonatomic, assign)PublishedStatusType statusType;
/** 小贴士倒计时初始时间*/
@property (nonatomic, copy) NSString *tipInitCountdownTime;
/** 时间差*/
@property (nonatomic, assign) NSInteger timeDuring;

/** 商品报价数量*/
@property (nonatomic, assign) NSInteger bidCount;
/** 商品报价数组*/
@property (nonatomic, strong) NSArray <JHRecyclePriceModel *>*bidVOs;
/** 宝贝分类id*/
@property (nonatomic, copy) NSString *categoryId;
/** 分类名称*/
@property (nonatomic, copy) NSString *categoryName;
/** 宝贝描述*/
@property (nonatomic, copy) NSString *productDesc;
/** 宝贝id*/
@property (nonatomic, copy) NSString *productId;
/** 宝贝图片地址*/
@property (nonatomic, strong) JHRecycleImageModel *productImgUrl;
/** 商品状态 1上架 2下架 3已售出 4禁售 5失效*/
@property (nonatomic, assign) NSInteger productStatus;
/** 小贴士描述信息*/
@property (nonatomic, copy) NSString *tipDesc;
@end

NS_ASSUME_NONNULL_END
