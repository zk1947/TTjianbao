//
//  JHLadderApiManager.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHLadderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLadderApiManager : NSObject

/*获取用户津贴列表数据：/anon/red-packet/findLadderByCustomerId
 customerId(未传则代表未登录、登录后必传)
 如果未登录 则接口返回的阶梯列表中只包含第一阶梯数据
*/
+ (void)getLadderList:(JHLadderModel *)model block:(HTTPCompleteBlock)block;

///领取津贴
+ (void)sendReceiveRequest:(JHLadderModel *)model block:(HTTPCompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
