//
//  JHC2CProoductDetailModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProoductDetailModel.h"

@implementation JHC2CProoductDetailProductExt

@end

@implementation JHC2CProoductDetailAuctionFlow

@end

@implementation JHC2CProoductDetailImageModel

@end

@implementation JHC2CVoiceContentVOS

@end



@implementation JHC2CAppraisalResult
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"voiceContentVOS":JHC2CVoiceContentVOS.class};
}
@end

@implementation JHC2CCurrentCustomerAuction

@end

@implementation JHC2CProoductDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"mainImages":JHC2CProoductDetailImageModel.class,
             @"detailImages":JHC2CProoductDetailImageModel.class,
             @"allImages":JHC2CProoductDetailImageModel.class
    };
}

@end
