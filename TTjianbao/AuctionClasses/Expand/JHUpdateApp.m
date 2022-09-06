//
//  JHUpdateApp.m
//  TTjianbao
//
//  Created by mac on 2019/5/24.
//  Copyright © 2019 Netease. All rights reserved.
//


#import "JHUpdateApp.h"
#import "TTjianbaoMarcoKeyword.h"
#import "JHAppAlertViewManger.h"

@implementation JHUpdateAppModel

@end
@implementation JHUpdateApp

- (void)checkUpdate {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @"ios";
    dic[@"appVersion"] = JHAppVersion;
    dic[@"channel"] = JHAppChannel;
    NSLog(@"JHAppVersion===%@",JHAppVersion);
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/index/checkVersion") Parameters:dic successBlock:^(RequestModel *respondObject) {
        
        JHUpdateAppModel *app = [JHUpdateAppModel mj_objectWithKeyValues:respondObject.data];
        [self showAlertWithModel:app];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (void)showAlertWithModel:(JHUpdateAppModel *)model {
    if (model.isUpDate>0) {
        
        JHAppAlertModel *m = [JHAppAlertModel new];
        m.localType = JHAppAlertLocalTypeHome;
        m.type = JHAppAlertTypeAppUpdate;
        m.body = model;
        m.typeName = AppAlertUpdateVersion;
        [JHAppAlertViewManger addModelArray:@[m]];
    }

}
@end
