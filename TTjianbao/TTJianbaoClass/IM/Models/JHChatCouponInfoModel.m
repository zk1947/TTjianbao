//
//  JHChatCouponModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatCouponInfoModel.h"

@implementation JHChatCustomCouponModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = JHChatCustomTypeCoupon;
    }
    return self;
}
- (NSString *)encodeAttachment
{
    return [self mj_JSONString];
}
@end

@implementation JHChatCouponInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"couponId" : @"id"};
}
- (id)copyWithZone:(NSZone *)zone{
    JHChatCouponInfoModel *copyModel = [[[self class] allocWithZone:zone] init];
    copyModel.couponId = self.couponId;
    copyModel.sellerId = self.sellerId;
    copyModel.name = self.name;
    copyModel.ruleType = self.ruleType;
    copyModel.ruleFrCondition = self.ruleFrCondition;
    copyModel.price = self.price;
    copyModel.timeType = self.timeType;
    copyModel.timeTypeRDay = self.timeTypeRDay;
    copyModel.timeTypeAStartTime = self.timeTypeAStartTime;
    copyModel.timeTypeAEndTime = self.timeTypeAEndTime;
    copyModel.supplySellerType = self.supplySellerType;
    copyModel.isSelected = self.isSelected;
    return copyModel;
}

- (NSString *)getCouponRuleText {
    NSString *ruleText = @"";
    if (self.ruleType == nil || self.ruleType.length <= 0) return @"";
    if (self.ruleFrCondition == nil || self.ruleFrCondition.length <= 0) return @"";
    
    if ([self.ruleType isEqualToString:@"FR"]) { // 满减
        ruleText = [NSString stringWithFormat:@"满%@元可用", self.ruleFrCondition];
    }else if ([self.ruleType isEqualToString:@"EFR"]) { // 每满减
        ruleText = [NSString stringWithFormat:@"每满%@元可用", self.ruleFrCondition];
    }else if ([self.ruleType isEqualToString:@"OD"]) { // 折扣
        ruleText = [NSString stringWithFormat:@"满%@元可用", self.ruleFrCondition];
    }
    return ruleText;
}

- (NSString *)getCouponDescText {
    NSString *title = @"";
    if (self.supplySellerType == 1) {
        title = @"适用范围: 直播间、商城均可用";
    }else if (self.supplySellerType == 2) {
        title = @"适用范围: 限直播间可用";
    }else if (self.supplySellerType == 3) {
        title = @"适用范围: 限商城可用";
    }
    return title;
}

- (NSAttributedString *)getMoneyText : (UIFont *)leftFont rightFont : (UIFont *) rightFont {
    if ([self.ruleType isEqualToString:@"OD"]) {
        return [self getSaleMoney:self.price leftFont : leftFont rightFont : rightFont];
    }else {
        return [self getMoney:self.price leftFont : leftFont rightFont : rightFont];
    }
}
- (NSAttributedString *)getSaleMoney : (NSString *)money leftFont: (UIFont *)leftFont rightFont : (UIFont *) rightFont{
    if (money == nil || money.length <= 0) return nil;
    
    NSString *newMoney = [NSString stringWithFormat:@"%@", money];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:newMoney attributes:@{NSFontAttributeName : rightFont}];
    
    NSAttributedString *disCount = [[NSAttributedString alloc] initWithString:@"折" attributes:@{NSFontAttributeName : leftFont}];
    [text appendAttributedString:disCount];
    return text;
}
- (NSAttributedString *)getMoney : (NSString *)money leftFont: (UIFont *)leftFont rightFont : (UIFont *) rightFont{
    if (money.length == 0) return nil;
    NSMutableAttributedString *attPrice = [[NSMutableAttributedString alloc] initWithString:money attributes:@{NSFontAttributeName : rightFont}];
    
    NSAttributedString *xx = [[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName : leftFont}];
    [attPrice insertAttributedString:xx atIndex:0];
    return attPrice;
}
@end


@implementation JHChatCouponSendModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"coupons" : [JHChatCouponSendInfo class],
    };
}
@end

@implementation JHChatCouponSendInfo

@end
