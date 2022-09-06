//
//  JHC2CJiangPaiListModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CJiangPaiListModel.h"
@implementation JHC2CJiangPaiRecord
- (NSString *)statusName{
    //状态 拍卖状态（0无状态 1 失效 2出局 3领先 4成交）
    
    if ([self.status isEqualToString:@"4"]) {
        return @"成交";
    }else if ([self.status isEqualToString:@"2"]) {
        return @"出局";
    }else if ([self.status isEqualToString:@"3"]) {
        return @"领先";
    }else {
        return @"失效";
    }
}
@end


@implementation JHC2CJiangPaiListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"records": JHC2CJiangPaiRecord.class};
}
@end


@implementation JHC2CSeeUserInfo

@end

@implementation JHC2CProductDetailUserListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"userResponses": JHC2CSeeUserInfo.class};
}
@end

