//
//  JHTestTableViewCellViewModel.m
//  TTjianbao
//
//  Created by user on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTestTableViewCellViewModel.h"
#import "JHTestModel.h"


@implementation JHTestTableViewCellViewModel

+ (NSArray<JHTestTableViewCellViewModel *>*)setTestViewModelImpl:(JHCustomizeLogisticsModelTestModel *)model {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    /// 用户
    JHTestTableViewCellViewModel *userModel = [[JHTestTableViewCellViewModel alloc] init];
    
    NSMutableArray *userArr = [[NSMutableArray alloc] init];
    if (!isEmpty(model.userExpressTitle)) { /// 名称
        [userArr addObject:model.userExpressTitle];
    }
    if (!isEmpty(model.userExpressInfo.com)) {  /// 物流
        NSString *str = [NSString stringWithFormat:@"物流公司：%@",model.userExpressInfo.com];
        [userArr addObject:str];
    }
    if (!isEmpty(model.userExpressInfo.nu)) {  /// 单号
        NSString *str = [NSString stringWithFormat:@"物流单号：%@",model.userExpressInfo.nu];
        [userArr addObject:str];
    }
    if (!isEmpty(model.userSendTime)) {  /// 发货时间
        NSString *str = [NSString stringWithFormat:@"发货时间：%@",model.userSendTime];
        [userArr addObject:str];
    }
    if (!isEmpty(model.userReceiveTime)) {  /// 收货时间
        NSString *str = [NSString stringWithFormat:@"收货时间：%@",model.userReceiveTime];
        [userArr addObject:str];
    }
    if (model.userExpressInfo.data.count >0) {
        [userArr addObjectsFromArray:model.userExpressInfo.data];
    }
    if (userArr.count >0) {
        userModel.dataArr = userArr;
        [arr addObject:userModel];
    }
    
    
    /// 商家
    JHTestTableViewCellViewModel *sellerModel = [[JHTestTableViewCellViewModel alloc] init];
    NSMutableArray *sellerArr = [[NSMutableArray alloc] init];
    if (!isEmpty(model.sellerExpressTitle)) { /// 名称
        [sellerArr addObject:model.sellerExpressTitle];
    }
    if (!isEmpty(model.sellerExpressInfo.com)) {  /// 物流
        NSString *str = [NSString stringWithFormat:@"物流公司：%@",model.sellerExpressInfo.com];
        [sellerArr addObject:str];
    }
    if (!isEmpty(model.sellerExpressInfo.nu)) {  /// 单号
        NSString *str = [NSString stringWithFormat:@"物流单号：%@",model.sellerExpressInfo.nu];
        [sellerArr addObject:str];
    }
    if (!isEmpty(model.sellerSendTime)) {  /// 发货时间
        NSString *str = [NSString stringWithFormat:@"发货时间：%@",model.sellerSendTime];
        [sellerArr addObject:str];
    }
    if (!isEmpty(model.sellerReceiveTime)) {  /// 收货时间
        NSString *str = [NSString stringWithFormat:@"收货时间：%@",model.sellerReceiveTime];
        [sellerArr addObject:str];
    }
    if (model.sellerExpressInfo.data.count >0) {
        [sellerArr addObjectsFromArray:model.sellerExpressInfo.data];
    }
    if (sellerArr.count >0) {
        sellerModel.dataArr = sellerArr;
        [arr addObject:sellerModel];
    }
    
    
    /// 平台
    JHTestTableViewCellViewModel *platModel = [[JHTestTableViewCellViewModel alloc] init];
    NSMutableArray *platArr = [[NSMutableArray alloc] init];
    if (!isEmpty(model.platformExpressTitle)) { /// 名称
        [platArr addObject:model.platformExpressTitle];
    }
    if (!isEmpty(model.platformExpressInfo.com)) {  /// 物流
        NSString *str = [NSString stringWithFormat:@"物流公司：%@",model.platformExpressInfo.com];
        [platArr addObject:str];
    }
    if (!isEmpty(model.platformExpressInfo.nu)) {  /// 单号
        NSString *str = [NSString stringWithFormat:@"物流单号：%@",model.platformExpressInfo.nu];
        [platArr addObject:str];
    }
    if (!isEmpty(model.platformSendTime)) {  /// 发货时间
        NSString *str = [NSString stringWithFormat:@"发货时间：%@",model.platformSendTime];
        [platArr addObject:str];
    }
    if (!isEmpty(model.platformReceiveTime)) {  /// 收货时间
        NSString *str = [NSString stringWithFormat:@"收货时间：%@",model.platformReceiveTime];
        [platArr addObject:str];
    }
    if (model.platformExpressInfo.data.count >0) {
        [platArr addObjectsFromArray:model.platformExpressInfo.data];
    }
    if (platArr.count >0) {
        platModel.dataArr = platArr;
        [arr addObject:platModel];
    }
    NSArray *modelsArr = arr;
    return modelsArr;
}


@end
