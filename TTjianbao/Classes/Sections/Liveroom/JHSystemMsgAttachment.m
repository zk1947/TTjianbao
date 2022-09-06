//
//  JHSystemMsgAttachment.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/19.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHSystemMsgAttachment.h"
#import "NTESCustomKeyDefine.h"

@implementation JHSystemMsgAttachment



- (nonnull NSString *)encodeAttachment {
    NSDictionary *attach = @{
                             @"type":@(self.type)
//                             @"body":@{
//                                     @"type" : @(self.type),
//                                     @"text": self.content?:@"",
//                                     @"nick":self.nick?:@"",
//                                     @"avatar":self.avatar?:@"",
//                                     @"giftInfo":self.giftInfo,
//                                     @"sender":self.sender,
//                                     @"receiver":self.receiver
//                                     }
                             };
    NSData *data = [NSJSONSerialization dataWithJSONObject:attach options:0 error:nil];
    NSString *str = @"{}";
    if (data) {
        str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return str;
}

- (NSString *)avatar {
    if (!_avatar) {
        if (_type == JHSystemMsgTypePresent) {
            _avatar = self.sender[@"icon"];

        }
    }
    return _avatar;
}

- (NSString *)content {
    if (!_content) {
        if (_type == JHSystemMsgTypePresent) {
            _content = [NSString stringWithFormat:@"%@ 赠送了%@", self.nick,self.giftInfo[@"giftName"]];
        }
    }
    return _content;
}

- (NSString *)nick {
    if (!_nick) {
        if (_type == JHSystemMsgTypePresent) {
            
            _nick = self.sender[@"nick"];
            
        }
    }
    return _nick;

}
@end

@implementation JHSystemMsg


- (void)setType:(JHSystemMsgType)type {
    _type = type;
    if (_content) {
        return;
    }
    switch (type) {
        case JHSystemMsgTypeFollow:
            _content = @"关注了主播";
            break;
        case JHSystemMsgTypeEndAppraisal:
            _content = @"结束鉴定";
            
            break;
            
        case JHSystemMsgTypeApplyAppraisal:
            _content = @"申请鉴定";
            break;
            
        case JHSystemMsgTypePresent:
            _content = [NSString stringWithFormat:@"赠送了%@", self.giftInfo[@"giftName"]];
            break;

        default:
            break;
    }
    if (!_content) {
        _content = @"";
    }
}

@end

