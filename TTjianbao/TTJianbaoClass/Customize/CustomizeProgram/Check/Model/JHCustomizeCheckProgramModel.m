//
//  JHCustomizeCheckProgramModel.m
//  TTjianbao
//
//  Created by user on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckProgramModel.h"

@implementation JHCustomizeCheckProgramModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"attachmentVOs" : [JHCustomizeCheckProgramPictsModel class]
    };
}



@end


@implementation JHCustomizeCheckProgramPictsModel
@end
