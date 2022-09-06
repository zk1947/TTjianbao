//
//  JHStoneMessageModel.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/8.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneMessageModel.h"

#import "JHMainLiveSmartModel.h"
@implementation JHStoneMessageModel


+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"splitStoneList" : [JHMainLiveSplitDetailModel class]
    };
}
@end

@implementation JHCustomChannelMessageModel

- (nonnull NSString *)encodeAttachment {
    return @"";
}
@end

@implementation JHCustomAlertMessageModel

- (nonnull NSString *)encodeAttachment {
    return @"";
}

@end

@implementation JHRedPacketMessageModel
- (nonnull NSString *)encodeAttachment {
    return @"";
}

@end

@implementation JHSystemMsgCustomizeOrder

@end
