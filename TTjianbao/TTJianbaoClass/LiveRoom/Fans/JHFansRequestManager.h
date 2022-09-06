//
//  JHFansRequestManager.h
//  TTjianbao
//
//  Created by liuhai on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHFansRequestManager : NSObject
+ (void)joinFansClubAction:(NSString *)fansId
             completeBlock:(HTTPCompleteBlock)block;

+ (void)getFansEquityInfoWithAnchorId : (NSString *)anchorId
                            successBlock:(succeedBlock) success
                            failureBlock:(failureBlock)failure;
@end

NS_ASSUME_NONNULL_END
