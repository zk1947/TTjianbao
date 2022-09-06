//
//  JHStealTowerModel.h
//  TTjianbao
//
//  Created by zk on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewStoreHomeModel.h"
#import "JHShareInfo.h"

NS_ASSUME_NONNULL_BEGIN
@class JHStealTowerHeadModel;
@class JHStealTowerContentModel;

@interface JHStealTowerModel : NSObject

@property (nonatomic, strong) JHStealTowerHeadModel *stealingTowerConfigResponse;//头部数据

@property (nonatomic, strong) JHStealTowerContentModel *closingProductResponse;//列表数据

@property (nonatomic, strong) NSArray *backFirstCateIds;//分类接口参数

@property (nonatomic, strong) JHShareInfo *shareInfoBean;//分享参数

@end

@interface JHStealTowerHeadModel : NSObject

@property (nonatomic, assign) int ID;

@property (nonatomic, copy) NSString *coverImg;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *label;

@property (nonatomic, assign) int timeRemain;

@end

@interface JHStealTowerContentModel : NSObject

@property (nonatomic, assign) int pageNo;

@property (nonatomic, assign) int pageSize;

@property (nonatomic, assign) int pages;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, assign) int sort;

@property (nonatomic, assign) int total;

@property (nonatomic, strong) NSArray *resultList;

@end

NS_ASSUME_NONNULL_END
