//
//  JHUnionPayModel.m
//  TTjianbao
//
//  Created by lihui on 2020/4/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionPayModel.h"
#import "UserInfoRequestManager.h"
#import "TTjianbao.h"

@implementation JHUnionPayModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    }
    return self;
}

@end

@implementation JHUnionPayTypeModel


@end

@implementation JHProcessModel


@end

@implementation JHUnionPayUserInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"listArray" : @"list",
        @"photoArray" : @"photo",
        @"legalArray" : @"legallist",
        @"beneficArray" : @"benificlist"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"listArray" : [JHUnionPayUserListModel class],
        @"photoArray" : [JHUnionPayUserPhotoModel class],
        @"legalArray" : [JHUnionPayUserListModel class],
        @"beneficArray" : [JHUnionPayUserListModel class]
    };
}

- (void)setMessage:(NSString *)message {
    _message = message;
   CGFloat messageHeight = [_message getHeightWithFont:[UIFont fontWithName:kFontMedium size:12] constrainedToSize:CGSizeMake(ScreenW - 40, MAXFLOAT)];
    _messageHeight = messageHeight+30;
}

- (void)setAlert:(NSString *)alert {
    _alert = alert;
    CGFloat alertHeight = [_alert getHeightWithFont:[UIFont fontWithName:kFontMedium size:12] constrainedToSize:CGSizeMake(ScreenW - 40, MAXFLOAT)];
    _alertHeight = alertHeight+30;
}


@end

@implementation JHUnionPayUserListModel


@end

@implementation JHUnionPayUserPhotoModel




@end

@implementation JHUnionPaySubBankModel


@end


