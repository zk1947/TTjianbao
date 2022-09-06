//
//  JHCustomizeSendGoodsViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeSendGoodsViewController.h"
#import "JHCustomizeSendGoodsView.h"
#import "JHCustomizeHomePickupView.h"
#import <IQKeyboardManager.h>

@interface JHCustomizeSendGoodsViewController ()
@property (nonatomic, strong) JHCustomizeHomePickupView *homePickupView;
@property (nonatomic, strong) JHCustomizeSendGoodsView *orderView;
@end

@implementation JHCustomizeSendGoodsViewController

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
    self.title = @"填写发货信息";
    [self initContentView];
    [self getAddress];
}

- (void)initContentView{
    _orderView=[[JHCustomizeSendGoodsView alloc]init];
    _orderView.isSeller = self.isSeller;
    _orderView.orderId = self.orderId;
    [self.view addSubview:_orderView];
    [_orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self.view);
    }];
}

- (void)getAddress{
    
    NSString *string = [NSString stringWithFormat:@"/auth/customizeExpress/%@",self.orderId];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(string) Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHCustomizeSendOrderModel *model = [JHCustomizeSendOrderModel mj_objectWithKeyValues: respondObject.data];
        [_orderView setModel:model];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}


@end
