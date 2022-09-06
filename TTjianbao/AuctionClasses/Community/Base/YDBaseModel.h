//
//  YDBaseModel.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/1.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"
#import "JHShareInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDBaseModel : NSObject

/*! 是否首次请求，默认YES */
@property (nonatomic, assign) BOOL  isFirstReq;

/*! 正在加载、能否加载更多数据、是否即将加载更多 */
@property (nonatomic, assign) BOOL  isLoading, canLoadMore, willLoadMore;

/*! 第几页，默认从1开始 */
@property (nonatomic, assign) NSInteger page;

@end

NS_ASSUME_NONNULL_END
