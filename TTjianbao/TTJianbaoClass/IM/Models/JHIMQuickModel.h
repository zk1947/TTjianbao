//
//  JHIMQuickModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHIMQuickModel : NSObject
/// 状态
@property (nonatomic, copy) NSString *status;
/// id
@property (nonatomic, assign) NSInteger replayId;
/// 默认回复文本
@property (nonatomic, copy) NSString *defaultReply;
/// 默认回复id
@property (nonatomic, assign) NSInteger defaultTermsId;
/// 快捷回复
@property (nonatomic, copy) NSString *quickReplyTerms;

+ (JHIMQuickModel *)getEvaluationQuickModel;
@end

NS_ASSUME_NONNULL_END
