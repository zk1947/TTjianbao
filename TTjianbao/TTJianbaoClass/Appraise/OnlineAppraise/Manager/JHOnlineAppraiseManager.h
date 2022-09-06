//
//  JHOnlineAppraiseManager.h
//  TTjianbao
//
//  Created by lihui on 2020/12/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHOnlineAppraiseManager : NSObject

///获取在线鉴定固定用户id
+ (void)getOperationUserConfig:(HTTPCompleteBlock)block;

///获取在线鉴定话题列表数据
+ (void)getOnlineTopicListInfo:(NSString *)userId completeBlock:(HTTPCompleteBlock)block;

///获取在线鉴定固定用户帖子数据
+ (void)getOnlinePostInfo:(NSString *)userId
                     page:(NSInteger)page
                 lastDate:(NSString *)lastDate
            completeBlock:(HTTPCompleteBlock)block;







@end

NS_ASSUME_NONNULL_END
