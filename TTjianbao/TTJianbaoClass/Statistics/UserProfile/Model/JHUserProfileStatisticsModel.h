//
//  JHUserProfileStatisticsModel.h
//  TTjianbao
//  Description:用户画像（第三套>统计）参数汇总
//  Created by Jesse on 2020/8/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"
#import "JHUserProfileModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserProfileStatisticsModel : JHReqModel

@property (nonatomic, strong) NSArray<JHUserProfileReportModel*>* report_info; //事件参数
@property (nonatomic, strong) JHUserProfileModel* base_info; //公共参数

//拼接所有参数,传入单个事件
- (void)setEventType:(NSString *)eventType bodyDict:(NSDictionary*)paramDict;
//拼接所有参数,通过数组传参(多个事件:适用于非实时情况)
- (void)setEventArray:(NSArray*)array;
//仅存储事件及对应参数,公参不需要存储
- (void)recordEventType:(NSString *)eventType bodyDict:(NSDictionary*)paramDict;
@end

NS_ASSUME_NONNULL_END

