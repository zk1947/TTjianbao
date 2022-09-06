//
//  JHRoomRedPacketModel.m
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRoomRedPacketModel.h"

@implementation JHRoomRedPacketModel

-(void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues
{
    _continueViewTime = _continueViewTime * 60;
}

@end

@implementation JHGetRoomRedPacketReqModel

- (NSString *)uriPath
{
    return @"/app/opt/red-packet/list";
}


@end
