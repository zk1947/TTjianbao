//
//  JHLotteryDataManager.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHLotteryModel.h"
#import "JHLotteryActivityDetailModel.h"
#import "JHLotteryJoinModel.h"
#import "JHLotteryMyCodeModel.h"
#import "JHLotteryRemindModel.h"
#import "JHLotteryEditAddressModel.h"
#import "JHLotteryShareModel.h"
#import "JHLotteryReqModel.h"
#import "YDMediaData.h"
#import "JHLotteryActivityDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryDataManager : NSObject

#pragma mark -
#pragma mark - 数据处理
///返回媒体播放组件需要的类型数据
+ (NSMutableArray<YDMediaData *> *)mediaSourceFromMediaList:(NSMutableArray<JHLotteryMediaData *> *)mediaList;


#pragma mark -
#pragma mark - 网络请求
///获取0元购首页活动列表
+ (void)getLotteryList:(JHLotteryModel *)model block:(HTTPCompleteBlock)block;

///参与抽奖
+ (void)sendJoinRequestWithActivityCode:(NSString *)code block:(HTTPCompleteBlock)block;

///分享成功后发起请求
+ (void)sendShareCommpleteRequestWithCode:(NSString *)code block:(HTTPCompleteBlock)block;

///获取往期活动详情
+ (void)getLotteryListDetailWithActivityCode:(NSString*)code inviter:(NSString*)inviter unionId:(NSString*)unionId resp:(JHActionBlocks)resp;

@end

NS_ASSUME_NONNULL_END
