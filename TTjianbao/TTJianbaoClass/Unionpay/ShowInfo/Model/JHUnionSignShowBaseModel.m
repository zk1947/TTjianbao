//
//  JHUnionSignShowBaseModel.m
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionSignShowBaseModel.h"

@implementation JHUnionSignShowBaseModel

+(JHUnionSignShowBaseModel *)creatWithTitle:(NSString *)title desc:(NSString *)desc type:(JHUnionSignShowType)type hiddenPushIcon:(BOOL)hiddenPushIcon{
  
    JHUnionSignShowBaseModel *model = [JHUnionSignShowBaseModel new];
    model.title = title;
    model.desc = desc;
    model.type = type;
    model.hiddenPushIcon = hiddenPushIcon;
    return model;
}

@end
