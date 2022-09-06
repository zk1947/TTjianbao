//
//  JHChatCustomTipModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHIMHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    /// 默认-显示文本
    JHChatCustomTipTypeNormal = 0,
    /// 评价-商家给用户推送评价
    JHChatCustomTipTypeEvaluate = 1,
} JHChatCustomTipType;

@class JHChatCustomTipInfo;

@interface JHChatCustomTipModel : NSObject<NIMCustomAttachment>

@property (nonatomic, assign) JHChatCustomType type;
@property (nonatomic, strong) JHChatCustomTipInfo *body;

@end
@interface JHChatCustomTipInfo : NSObject
/// tip 自定义类型
@property (nonatomic, assign) JHChatCustomTipType type;
/// 发送方显示内容
@property (nonatomic, copy) NSString *senderTip;
/// 接收方显示内容
@property (nonatomic, copy) NSString *receiverTip;

@end
NS_ASSUME_NONNULL_END
