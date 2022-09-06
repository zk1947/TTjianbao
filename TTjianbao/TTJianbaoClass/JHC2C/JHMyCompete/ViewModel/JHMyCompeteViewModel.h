//
//  JHMyCompeteViewModel.h
//  TTjianbao
//
//  Created by miao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "JHNewStoreHomeModel.h"
#import "JHMyAuctionListItemModel.h"
@class JHMyCompeteModel;

typedef NS_ENUM(NSUInteger, JHMyCompeteSubjectState) {
    JHMyCompeteSubject_Update = 1,         // 加载成功
    JHMyCompeteSubject_ErrorRefresh, // 加载失败
};

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCompeteViewModel : NSObject

/// 我的参拍数据
@property (nonatomic, strong) NSMutableArray *myCompeteDataArray;

/// 网络请求
@property (nonatomic, strong) RACCommand *myCompeteCommand;

/// 请求结果
@property (nonatomic, strong) RACSubject<NSNumber *> *myCompeteSubject;

///单刷单条参拍纪录
+ (void)reLoadMyAcutionStatus:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, JHMyAuctionListItemModel *model))completion;

@end

NS_ASSUME_NONNULL_END
