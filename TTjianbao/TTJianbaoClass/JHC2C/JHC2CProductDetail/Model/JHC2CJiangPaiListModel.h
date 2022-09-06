//
//  JHC2CJiangPaiListModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface JHC2CJiangPaiRecord : NSObject

//头像
@property (nonatomic, copy) NSString* img;

//分类鉴定开关，1 开 0 关
@property (nonatomic, copy) NSString* name;

///出价  分
@property (nonatomic) NSInteger price;

@property (nonatomic, copy) NSString* priceYuan;

//状态 拍卖状态（0无状态 1 失效 2出局 3领先 4中拍）
@property (nonatomic, copy) NSString* status;

//出价时间
@property (nonatomic, copy) NSString* createTime;

@property (nonatomic, copy) NSString* userId;


@property (nonatomic, copy) NSString* statusName;

@end


@interface JHC2CJiangPaiListModel : NSObject
//分类属性
@property (nonatomic, strong) NSArray< JHC2CJiangPaiRecord* > * records;

//预计鉴定完成时间 暂时不用
@property (nonatomic, copy) NSString* bid_increment;

@property (nonatomic) BOOL hasMore;

@end




@interface JHC2CSeeUserInfo : NSObject

@property (nonatomic, copy) NSString* img;

@property (nonatomic, copy) NSString* userId;


@end


@interface JHC2CProductDetailUserListModel : NSObject
@property (nonatomic, strong) NSArray< JHC2CSeeUserInfo* > * userResponses;

@property (nonatomic, copy) NSString* num;
@property (nonatomic, copy) NSString* time;


@end

NS_ASSUME_NONNULL_END
