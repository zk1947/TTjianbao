//
//  JHLotteryShareModel.h
//  TTjianbao
//  Description:分享成功
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHLotteryReqModel.h"
#import "JHLotteryJoinModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryShareModel : JHLotteryJoinModel

@property (nonatomic, copy) NSString* subtitle;//  "新人助力抽奖码+3，普通用户助力+1" //按钮下方描述

+ (void)asynRequestActivityCode:(NSString*)code resp:(JHActionBlocks)resp;
@end

@interface JHLotteryShareReqModel : JHLotteryReqModel

@end

NS_ASSUME_NONNULL_END
