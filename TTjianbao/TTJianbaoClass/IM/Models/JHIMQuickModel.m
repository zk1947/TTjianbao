//
//  JHIMQuickModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIMQuickModel.h"

@implementation JHIMQuickModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"replayId" : @"id"};
}

+ (JHIMQuickModel *)getEvaluationQuickModel {
    JHIMQuickModel *model = [[JHIMQuickModel alloc] init];
    model.replayId = -2;
    model.quickReplyTerms = @"服务评价";
    
    return model;
}
@end
