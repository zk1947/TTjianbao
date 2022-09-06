//
//  JHLadderModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDBaseModel.h"

@class JHLadderData;

NS_ASSUME_NONNULL_BEGIN

@interface JHLadderModel : YDBaseModel

//接口请求需要参数
@property (nonatomic,   copy) NSString *channelId; //直播间id
@property (nonatomic,   copy) NSString *customerId; //用户id
@property (nonatomic,   copy) NSString *ladderFlag; //阶梯标识
//接口返回数据
@property (nonatomic, strong) NSMutableArray <JHLadderData *> *list;

//获取用户津贴列表接口 & 参数
- (NSString *)toListUrl;
- (NSDictionary *)toListParams;

//领取津贴接口 & 参数
- (NSString *)toReceiveUrl;
- (NSDictionary *)toReceiveParams;

- (void)configModel:(JHLadderModel *)model;

@end


#pragma mark -
#pragma mark - 阶梯津贴列表数据
@interface JHLadderData : NSObject
@property (nonatomic,   copy) NSString  *ladderFlag; //阶梯标识
@property (nonatomic, assign) NSInteger timeValue; //倒计时秒数
@end

NS_ASSUME_NONNULL_END
