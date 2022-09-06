//
//  ShareUserInfoModel.m
//  KGLibrary
//
//  Created by yaoyao on 2017/11/13.
//  Copyright © 2017年 yaoyao. All rights reserved.
//

#import "ShareUserInfoModel.h"

NSString *const JHShareLivingText = @"快来，大神正在开直播免费鉴宝，有尖儿货，快去看看！";
NSString *const JHSharePreviewLiveText = @"我正在天天鉴宝平台直播鉴宝，欢迎大家前来捧场！";
NSString *const JHShareSaleLivingText = @"谁还在商场买呀？这儿的翡翠、玉石超便宜，还有国检证书，保真！免费鉴定保证品质。";

@implementation ShareUserInfoModel

- (void)setGender:(NSString *)gender {
    if ([gender.lowercaseString isEqualToString:@"f"]) {
        _gender = @"2";
    }else if ([gender.lowercaseString isEqualToString:@"m"]){
        _gender = @"1";
    }
    
}

@end

