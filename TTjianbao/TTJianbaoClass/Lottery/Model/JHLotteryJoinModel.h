//
//  JHLotteryJoinModel.h
//  TTjianbao
//  Description:参加活动
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHLotteryReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryDialogModel : NSObject

@property (nonatomic, copy) NSString* title;// "恭喜你！获得1张抽奖码", //标题
@property (nonatomic, copy) NSString* buttonTxt;// "好友助力，得抽奖码", //按钮文案
@property (nonatomic, copy) NSString* subtitle;// "新人助力抽奖码+3，普通用户助力+1" //按钮下方描述
@end

@interface JHLotteryJoinModel : JHRespModel

@property (nonatomic, strong) JHLotteryDialogModel* dialog;
@property (nonatomic, copy) NSString* buttonTxt;// "好友助力，得抽奖码", //页面按钮文案

+ (void)asynRequestActivityCode:(NSString*)code resp:(JHActionBlocks)resp;
@end

@interface JHLotteryJoinReqModel : JHLotteryReqModel

@end

NS_ASSUME_NONNULL_END
