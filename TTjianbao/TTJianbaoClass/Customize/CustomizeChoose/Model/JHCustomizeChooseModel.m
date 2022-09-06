//
//  JHCustomizeChooseModel.m
//  TTjianbao
//
//  Created by user on 2020/12/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeChooseModel.h"

@implementation JHCustomizeChooseTemplatesModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id"
    };
}
@end



@implementation JHCustomizeChooseListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"templates" : [JHCustomizeChooseTemplatesModel class]
    };
}
@end



@implementation JHCustomizeChooseRequestModel
@end


@implementation JHCustomizeChooseModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"fees" : [JHCustomizeChooseFeesModel class],
        @"opusList" : [JHCustomizeChooseOpusListModel class],
        @"materials" : [JHCustomizeChooseMaterialsModel class]

    };
}
@end


@implementation JHCustomizeChooseFeesModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id"
    };
}
@end


@implementation JHCustomizeChooseMaterialsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id"
    };
}
@end



@implementation JHCustomizeChooseFeesPriceWrapperModel

@end

@implementation JHCustomizeChooseOpusListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id",
        @"desc":@"description"
    };
}
@end




