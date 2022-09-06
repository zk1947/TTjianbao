//
//  JHReportAddressManagerViewController.h
//  TTjianbao
//
//  Created by 张坤 on 2021/5/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "AdressMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHReportAddressManagerViewController : JHBaseViewController
/// 刷新上层页面数据
@property (nonatomic,strong) RACSubject *reloadUPData;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *workOrderId;
///工单状态
@property (nonatomic, copy) NSString *workOrderStatus;


/// 选择的地址信息
@property (nonatomic, copy) void (^selectedBlock) (AdressMode *model);

@end

NS_ASSUME_NONNULL_END


