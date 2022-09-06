//
//  JHBusinessFansMissionProgressView.h
//  TTjianbao
//
//  Created by user on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHBusinessFansMissionSettingStatus) {
    JHBusinessFansMissionSettingStatus_level = 0, /// 等级设置
    JHBusinessFansMissionSettingStatus_mission,  /// 任务设置
    JHBusinessFansMissionSettingStatus_equity,    /// 权益设置
};

typedef void(^settingProgressViewClickBlock)(NSInteger index);

@interface JHBusinessFansMissionProgressView : UIView
@property (nonatomic, assign) BOOL canClick;
@property (nonatomic,   copy) settingProgressViewClickBlock clickBlock;
- (void)setLabelStatus:(JHBusinessFansMissionSettingStatus)status;
@end

NS_ASSUME_NONNULL_END
