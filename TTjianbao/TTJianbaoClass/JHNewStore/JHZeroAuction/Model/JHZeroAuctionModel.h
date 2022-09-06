//
//  JHZeroAuctionModel.h
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewStoreHomeModel.h"
#import "JHShareInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class JHZeroAuctionHeadModel;
@class JHZeroAuctionContentModel;

@interface JHZeroAuctionModel : NSObject

@property (nonatomic, strong) JHZeroAuctionHeadModel *zeroAuctionConfBo;//头部数据

@property (nonatomic, strong) JHZeroAuctionContentModel *zeroAuctionProductPageResult;//列表数据

@property (nonatomic, strong) NSArray *backThirdCateIds;//分类接口参数

//backFirstCateIds
//@property (nonatomic, strong) JHShareInfo *shareInfoBean;//分享参数

@end

@interface JHZeroAuctionHeadModel : NSObject

@property (nonatomic, assign) int ID;

@property (nonatomic, copy) NSString *coverImg;

@property (nonatomic, copy) NSString *title;

//bidMaxIncrement    加价最大幅度    number
//bidMinIncrement    加价最小幅度    number
//startMaxPrice    起拍最高价    number
//startMinPrice    起拍最低价    number

@end

@interface JHZeroAuctionContentModel : NSObject

@property (nonatomic, assign) int pageNo;

@property (nonatomic, assign) int pageSize;

@property (nonatomic, assign) int pages;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, assign) int sort;

@property (nonatomic, assign) int total;

@property (nonatomic, strong) NSArray *resultList;

//cursor    生成当前页最后一条记录的信息    string

@end

NS_ASSUME_NONNULL_END
