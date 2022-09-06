//
//  JHCustomizeAddProgramModel.m
//  TTjianbao
//
//  Created by user on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAddProgramModel.h"

@implementation JHCustomizeAddProgramModel
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"planImgList" : @"JHCustomizeAddProgramPictsModel"
    };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"planImgList" : [JHCustomizeAddProgramPictsModel class]
    };
}
@end


@implementation JHCustomizeAddProgramPictsModel
@end
