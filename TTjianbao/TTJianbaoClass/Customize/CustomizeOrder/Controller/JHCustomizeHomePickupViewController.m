//
//  JHCustomizeHomePickupViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/1/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCustomizeHomePickupViewController.h"
#import "JHCustomizeNotHomePickupView.h"
#import "JHCustomizeHomePickupView.h"
#import <IQKeyboardManager.h>
#import "OrderMode.h"
#import "UIView+Toast.h"

@interface JHCustomizeHomePickupViewController ()
@property (nonatomic, strong) JHCustomizeHomePickupView *homePickupView;
@property (nonatomic, strong) JHCustomizeNotHomePickupView *notHomePickupView;
@end

@implementation JHCustomizeHomePickupViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约上门取件";
    [self getAddress];
}

//自行邮寄
- (void)initContentView{
    _notHomePickupView = [[JHCustomizeNotHomePickupView alloc]init];
    _notHomePickupView.isSeller = self.isSeller;
    _notHomePickupView.orderId = self.orderId;
    _notHomePickupView.orderMode = self.orderMode;
    [self.view addSubview:_notHomePickupView];
    [_notHomePickupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self.view);
    }];
}
//上门取件
- (void)initHomePickupContentView{
    //来源：订单支付成功页，订单列表，订单详情
    [JHGrowingIO trackEventId:@"dz_smqj_in" from:self.fromString];
    _homePickupView = [[JHCustomizeHomePickupView alloc]init];
    _homePickupView.orderId = self.orderId;
    _homePickupView.orderMode = self.orderMode;
    [self.view addSubview:_homePickupView];
    [_homePickupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self.view);
    }];
}
- (void)getAddress{
    
    NSString *string = [NSString stringWithFormat:@"/auth/customizeExpress/%@",self.orderId];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(string) Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHCustomizeSendOrderModel *model = [JHCustomizeSendOrderModel mj_objectWithKeyValues: respondObject.data];
        //预约状态 0 未预约 1 已预约 2 预约成功 3 不支持 4 发货成功
        if ([model.expressReserveStatus intValue] == 3) {
            [self initContentView];
            [_notHomePickupView setModel:model];
        }else{
            [self initHomePickupContentView];
            [_homePickupView setSendOrderModel:model];
            //邮寄成功状态提示
            if ([model.expressReserveStatus intValue] == 4) {
                [self.view makeToast:@"预约成功，定制原料已邮寄" duration:1.5 position:CSToastPositionCenter];
            }
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}



@end
