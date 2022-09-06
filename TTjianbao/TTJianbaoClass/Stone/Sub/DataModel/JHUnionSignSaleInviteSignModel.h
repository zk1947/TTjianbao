//
//  JHUnionSignSaleInviteSignModel.h
//  TTjianbao
//  Description:请他签约
//  Created by jesee on 27/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUnionSignSaleInviteSignModel : JHReqModel

@property (strong,nonatomic) NSString *customerId;// /signContract/auth/inviteSign;
@property (strong,nonatomic) NSString *roomId;

//请他签约~上行接口
+ (void)request:(NSString*)userId;
@end

NS_ASSUME_NONNULL_END
