//
//  JHChatDateModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHIMHeader.h"

NS_ASSUME_NONNULL_BEGIN
@class JHChatCustomDateInfo;

@interface JHChatCustomDateModel : NSObject<NIMCustomAttachment>
@property (nonatomic, assign) JHChatCustomType type;
@property (nonatomic, strong) JHChatCustomDateInfo *body;
@end

@interface JHChatCustomDateInfo : NSObject
@property (nonatomic, copy) NSString *date;
@end
NS_ASSUME_NONNULL_END
