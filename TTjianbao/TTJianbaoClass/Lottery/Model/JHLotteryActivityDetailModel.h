//
//  JHLotteryActivityDetailModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  活动详情数据
//

#import "JHLotteryModel.h"
#import "JHLotteryReqModel.h"

@class JHLotteryAddress;
@class JHLotteryLogistics;
@class JHLotteryInviter;


NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryActivityDetailReqModel : JHLotteryReqModel

@property (nonatomic, copy) NSString* inviter; //邀请人ID，H5端传递
@property (nonatomic, copy) NSString* unionId; //微信unionId，H5端调用时传递
@end

@interface JHLotteryActivityDetailModel : JHLotteryActivityData
@property (nonatomic, strong) JHLotteryAddress *address;
@property (nonatomic, strong) JHLotteryLogistics *logistics;
@property (nonatomic, strong) JHLotteryInviter *inviter;

- (CGFloat)statusViewHeight;

@end

#pragma mark -
#pragma mark - 收货地址
@interface JHLotteryAddress : NSObject
@property (nonatomic,   copy) NSString *name; //收货人
@property (nonatomic,   copy) NSString *phone; //联系电话
@property (nonatomic,   copy) NSString *address; //详细地址
@property (nonatomic,   copy) NSString *region;
@end

#pragma mark -
#pragma mark - 物流信息
@interface JHLotteryLogistics : NSObject
@property (nonatomic,   copy) NSString *status; //物流状态："已发货"
@property (nonatomic,   copy) NSString *company; //快递公司："申通"
@property (nonatomic,   copy) NSString *expressNo; //快递单号："8976896783239"
@end

#pragma mark -
#pragma mark - 邀请人信息
@interface JHLotteryInviter : NSObject
@property (nonatomic,   copy) NSString *img; //头像
@property (nonatomic,   copy) NSString *nickname; //昵称
@end


NS_ASSUME_NONNULL_END
