//
//  JH99FreeModel.h
//  TTjianbao
//
//  Created by lihui on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHGoodsInfoMode;
@class JHStoreHomeShowcaseModel;

@interface JH99FreeModel : NSObject
///商品信息
@property (nonatomic, strong) NSMutableArray <JHGoodsInfoMode *>*goodsList;
///用户登录时间
@property (nonatomic, assign) long long login_time;
///结束时间
@property (nonatomic, assign) long long finish_time;
///服务器时间
@property (nonatomic, assign) long long server_time;
///专题信息
@property (nonatomic, strong) JHStoreHomeShowcaseModel *showcaseInfo;
///是否需要弹出弹窗
@property (nonatomic, assign) BOOL is_pop;

- (instancetype)initWith99FreeInfo:(id)responseObj;

@end

NS_ASSUME_NONNULL_END
