//
//  JHFansEquityListModel.h
//  TTjianbao
//
//  Created by liuhai on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//@ApiModelProperty(value = "奖励类别，0代金券，1专属商品，2进场特效，3专属粉丝牌")
//private String rewardType;
//@ApiModelProperty(value = "奖励名称")
//private String rewardName;
//@ApiModelProperty(value = "奖励图片上文案")
//private String rewardImgName;

@interface JHFansEquityInfoModel : NSObject
@property (nonatomic, copy) NSString *rewardType;
@property (nonatomic, copy) NSString *rewardName;
@property (nonatomic, copy) NSString *rewardImgName;
@end

@interface JHFansEquityLVModel : NSObject
@property (nonatomic, copy) NSString *levelName;
@property (nonatomic, copy) NSString *levelType;
@property (nonatomic, strong) NSArray *rewardVos;
@property (nonatomic, assign) BOOL isget;  //是否已获得权益
@property (nonatomic, copy) NSString *msgTitle; //5000弹窗用
@end

@interface JHFansEquityListModel : NSObject
@property (nonatomic, copy) NSString *anchorIcon;
@property (nonatomic, copy) NSString *anchorName;
@property (nonatomic, copy) NSString *fansClubId;
@property (nonatomic, copy) NSString *fansCount;
@property (nonatomic, assign) NSInteger userLevelType;
@property (nonatomic, copy) NSString *userLevelName;
@property (nonatomic, strong) NSArray *levelRewardVos;
@end

@interface JHFansEquityTipListModel : NSObject

@property (nonatomic, strong) NSArray *rewardVoList;
@property (nonatomic, copy) NSString *msgTitle;
@end
NS_ASSUME_NONNULL_END
