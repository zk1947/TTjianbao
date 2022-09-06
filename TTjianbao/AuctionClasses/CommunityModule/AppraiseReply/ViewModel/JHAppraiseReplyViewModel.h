//
//  JHAppraiseReplyViewModel.h
//  TTjianbao
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHAppraiserUserReplyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAppraiseReplyViewModel : NSObject



/// 获取鉴定贴回复标签
/// @param block 请求成功/失败的回调
+ (void)getAppraiseChannelList:(HTTPCompleteBlock)block;

/**
 获取鉴定贴列表

 @param is_comment 0 未回复 1已回复
 @param page page description
 @param success success description
 @param failure failure description
 */
+ (void)getAppraiseContentList:(NSInteger)is_comment
                          page:(NSInteger)page
                     channelId:(NSInteger)channelId
                       success:(void (^)(RequestModel *request))success
                       failure:(void (^)(RequestModel *request))failure;

///鉴定贴回复 - 获取宝友回复列表数据
+ (void)getUserReplyList:(JHAppraiserUserReplyModel *)model block:(HTTPCompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
