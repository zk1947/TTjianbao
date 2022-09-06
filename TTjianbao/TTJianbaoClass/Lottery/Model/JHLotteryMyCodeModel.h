//
//  JHLotteryMyCodeModel.h
//  TTjianbao
//  Description:我的抽奖码
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHLotteryReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryMyCodeModel : JHRespModel

@property (nonatomic, copy) NSString* lotteryCode; //code="123456", //抽奖码
@property (nonatomic, copy) NSString* sourceUp; //"我的", //上面文案
@property (nonatomic, copy) NSString* sourceDown; //"抽奖码", //下面文案
@property (nonatomic, copy) NSString* img; //img

+ (void)asynRequestActivityCode:(NSString*)code unionId:(NSString*)unionId resp:(JHActionBlocks)resp;
@end

@interface JHLotteryMyCodeReqModel : JHLotteryReqModel

@property (nonatomic, copy) NSString* unionId; //e.g.123121,微信unionId，H5端调用时传递
@end

NS_ASSUME_NONNULL_END
