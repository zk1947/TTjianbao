//
//  JHUnionSignSaleInviteSignModel.m
//  TTjianbao
//
//  Created by jesee on 27/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionSignSaleInviteSignModel.h"


@implementation JHUnionSignSaleInviteSignModel

- (NSString *)uriPath
{
    return @"/signContract/signContract/auth/inviteSign";
}

+ (void)request:(NSString*)userId
{
    JHUnionSignSaleInviteSignModel *model = [JHUnionSignSaleInviteSignModel new];
    model.customerId = userId;
    model.roomId = JHRootController.serviceCenter.channelModel.roomId ?: @"";
    [JH_REQUEST asynPost:model success:^(id respData) {
        
    } failure:^(NSString *errorMsg) {
        NSLog(@"requestInviteSignFail:%@", errorMsg);
    }];
}

@end
