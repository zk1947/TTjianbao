//
//  User.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/10.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "User.h"

@implementation User
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

- (NSString *)bountyBalance {
    if (_bountyBalance) {
        double d            = [_bountyBalance doubleValue];
        NSString *dStr      = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _bountyBalance      = [dn stringValue];
    }
    return _bountyBalance;
    
    
}

- (void)setSmallChange:(NSString *)smallChange {
    _smallChange = [smallChange copy];
    if (_smallChange.length == 0) {
        _smallChange = @"0";
    }
}
- (BOOL)hasOpenLiving {
    
    if (_type == 2||_type == 4||_type == 6||_type == 7||_type == 9){
    if (self.businessLines.count > 0 && [self.businessLines containsObject:living]) {
        ///包含直播的字段
        return YES;
       }
    }
    return NO;
}

- (BOOL)hasOpenRecyle {
    if (_type == 2||_type == 4||_type == 6||_type == 7||_type == 9){
        if (self.businessLines.count > 0 && [self.businessLines containsObject:recycle]){
            ///包含回收的字段
            return YES;
        }
    }
    return NO;
}
- (BOOL)hasOpenExcellent {
    if (_type == 2||_type == 4||_type == 6||_type == 7||_type == 9){
    if (self.businessLines.count > 0 && [self.businessLines containsObject:excellent]) {
        ///包含优店的字段
        return YES;
      }
    }
    return NO;
}
/// 是否是 普通用户
- (BOOL)blRole_default {
    if (_type == 0) {
        return YES;
    }
    return NO;
}

/// 是否是 鉴定主播
- (BOOL)blRole_appraiseAnchor {
    if (_type == 1) {
        return YES;
    }
    return NO;
}
/// 是否是 社区商户
- (BOOL)blRole_communityShop {
    if (_type == 4) {
        return YES;
    }
    return NO;
}

/// 是否是 马甲
- (BOOL)blRole_maJia {
    if (_type == 5) {
        return YES;
    }
    return NO;
}

/// 是否是 社区商户+卖货商户
- (BOOL)blRole_communityAndSaleAnchor {
    if (_type == 6) {
        return YES;
    }
    return NO;
}

/// 是否是 普通卖场主播
- (BOOL)blRole_saleAnchor {
    if (self.hasOpenLiving&&self.liveType == 0) {
        return YES;
    }
    return NO;
}
/// 是否是 回血主播
- (BOOL)blRole_restoreAnchor {
    
    if (self.hasOpenLiving&&self.liveType == 1) {
        return YES;
    }
    return NO;
}
/// 是否是 定制主播
- (BOOL)blRole_customize {
    if (self.hasOpenLiving&&self.liveType == 2) {
        return YES;
    }
    return NO;
}

/// 是否是 回收主播
- (BOOL)blRole_recycle {
    if (self.hasOpenLiving&&self.liveType == 3) {
        return YES;
    }
    return NO;
}
/// 是否是 普通卖场主播助理
- (BOOL)blRole_saleAnchorAssistant {
    if (_type == 3) {
        return YES;
    }
    return NO;
}
/// 是否是 回血主播助理
- (BOOL)blRole_restoreAssistant {
    if (_type == 8) {
        return YES;
    }
    return NO;
}
/// 是否是 定制主播助理
- (BOOL)blRole_customizeAssistant {
    if (_type == 10) {
        return YES;
    }
    return NO;
}
/// 是否是 回收主播助理
- (BOOL)blRole_recycleAssistant {
    if (_type == 12) {
        return YES;
    }
    return NO;
}

/// 是否是 图文鉴定师
- (BOOL)blRole_imageAppraise{
    if (_type == 13) {
        return YES;
    }
    return NO;
}


/// 是否是 回收商
- (BOOL)blRole_recycleBusiness {
    if (self.businessLines.count > 0 && [self.businessLines containsObject:recycle]){
        ///包含回收的字段
        return YES;
    }
    return NO;
}



@end

















@implementation UserRole
@end

