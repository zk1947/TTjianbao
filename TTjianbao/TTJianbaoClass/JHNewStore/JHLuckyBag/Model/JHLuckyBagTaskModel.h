//
//  JHLuckyBagTaskModel.h
//  TTjianbao
//
//  Created by zk on 2021/11/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHLuckyBagTaskInfoModel;

@interface JHLuckyBagTaskModel : NSObject

@property (nonatomic, copy) NSString *bagKey;//评论口令

@property (nonatomic, copy) NSString *bagTitle;//活动名称

@property (nonatomic, copy) NSString *buttonTitle;//按钮文案

@property (nonatomic, assign) int buttonType;//按钮类型 0 已参与 1 关注 2 发布评论

@property (nonatomic, assign) int countdownSeconds;//倒计时

@property (nonatomic, copy) NSString *imgUrl;//显示福袋图片

@property (nonatomic, assign) int joinNumber;//参与人数

@property (nonatomic, assign) int prizeNumber;//福袋数量

@property (nonatomic, strong) JHLuckyBagTaskInfoModel *taskInfos;

@end
              
@interface JHLuckyBagTaskInfoModel : NSObject
              
@property (nonatomic, assign) int taskOrder;//任务顺序

@property (nonatomic, assign) int taskStatus;//状态

@property (nonatomic, assign) int taskType;//任务类型 1 关注 2 发布评论

@property (nonatomic, copy) NSString *taskTile;//任务名称

@end
      
@interface JHLuckyBagTaskRewardModel : NSObject

@property (nonatomic, copy) NSArray *customerIds;

@property (nonatomic, copy) NSArray *nonCustomerIds;

@property (nonatomic, copy) NSString *winPrizeDesc;

@property (nonatomic, copy) NSString *failPrizeDesc;

@property (nonatomic, copy) NSString *bagOverDesc;

@end

@interface CustomerBagTagModel : NSObject

@property (nonatomic, assign) int countdownSeconds;//开奖倒计时/秒
                               
@property (nonatomic, assign) NSInteger sellerConfigId;//商家福袋配置id
                             
@property (nonatomic, assign) NSInteger ID;//商家福袋配置id

@property (nonatomic, assign) BOOL showTag;//是否展示福袋 true：展示 false：不展示



@end

NS_ASSUME_NONNULL_END
