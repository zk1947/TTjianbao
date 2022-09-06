//
//  JHMyCenterButtonModel.h
//  TTjianbao
//
//  Created by apple on 2020/4/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHMyCenterButtonType)
{
    /// 打赏
    JHMyCenterButtonTypeReward = 1,
    
    /// 设置直播封面
    JHMyCenterButtonTypeSetCover,
    
    /// 订单鉴定
    JHMyCenterButtonTypeOrderAppraisal,
    
    /// 鉴定记录
    JHMyCenterButtonTypeAppraisalRecord,
    
    /// 认领交易鉴定
    JHMyCenterButtonTypeGetAppraisal,
    
    /// 鉴定贴回复
    JHMyCenterButtonTypeAppraisalReply,
    
    /// 禁言
    JHMyCenterButtonTypeMute,
};

@interface JHMyCenterButtonModel : NSObject

/// 按钮图标
@property (nonatomic, copy) NSString *icon;

/// 按钮标题
@property (nonatomic, copy) NSString *name;

/// 跳转页面类型
@property (nonatomic, assign) JHMyCenterButtonType type;

+ (JHMyCenterButtonModel *)creatWithIcon:(NSString *)icon name:(NSString *)name type:(JHMyCenterButtonType)type;

/// 按钮 跳转
+ (void)pushWithType:(JHMyCenterButtonType)type;

@end

NS_ASSUME_NONNULL_END
