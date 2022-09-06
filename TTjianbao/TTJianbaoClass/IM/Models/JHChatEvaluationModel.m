//
//  JHChatEvaluationModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatEvaluationModel.h"

@implementation JHChatEvaluationModel

- (instancetype)initWithId : (NSString *)evaluationId icon : (NSString *)icon title : (NSString *)title {
    self = [super init];
    if (self) {
        self.evaluationId = evaluationId;
        self.icon = icon;
        self.title = title;
        self.isSelected = true;
        NSString *no = [NSString stringWithFormat:@"%@_non", icon];
        self.nonIcon = no;
    }
    return self;
}

+ (NSArray<JHChatEvaluationModel *> *)getEvaluationList {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSArray *titles = @[@"很满意",@"满意",@"一般",@"不满意"];
    
    int i = 0;
    for (NSString *title in titles) {
        NSString *icon = [NSString stringWithFormat:@"IM_Evaluation_icon_%d", i];
        NSString *evaId = [NSString stringWithFormat:@"%d", 4 - i];
        JHChatEvaluationModel *model = [[JHChatEvaluationModel alloc] initWithId:evaId icon:icon title:title];
        [list appendObject:model];
        i += 1;
    }
    
    return list;
}
@end
