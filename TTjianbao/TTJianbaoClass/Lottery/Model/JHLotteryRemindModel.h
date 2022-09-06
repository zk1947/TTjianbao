//
//  JHLotteryRemindModel.h
//  TTjianbao
//  Description:开启/关闭提醒
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHLotteryReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryRemindModel : JHRespModel

@property (nonatomic, copy) NSString* remindSwitch;// 1, //是否开启提醒（0:否、1:是）
@property (nonatomic, copy) NSString* buttonTxt;// "开启提醒" //按钮文案
@property (nonatomic, copy) NSString* toast; //"已关闭提醒" //操作提示文案

+ (void)asynRequestActivityCode:(NSString*)code resp:(JHActionBlocks)resp;
@end

@interface JHLotteryRemindReqModel : JHLotteryReqModel

@end

NS_ASSUME_NONNULL_END
