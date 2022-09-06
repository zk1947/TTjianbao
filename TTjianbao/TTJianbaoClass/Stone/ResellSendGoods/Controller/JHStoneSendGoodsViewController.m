//
//  JHStoneSendGoodsViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneSendGoodsViewController.h"
#import "JHStoneSendGoodsView.h"
#import <IQKeyboardManager.h>
#import "CommAlertView.h"

@interface JHStoneSendGoodsViewController ()
@property(strong,nonatomic) JHStoneSendGoodsView* stoneSendGoodsView;
@property(strong,nonatomic) JHGoodSendAddressMode* addressModel;
@end

@implementation JHStoneSendGoodsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xffffff);
//    [self initToolsBar];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar setTitle:@"发货"];
    self.title = @"发货";
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
   // self.goodId=@"12";
    [self  initContentView];
    [self getAddress];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}
-(void)initContentView{
    _stoneSendGoodsView=[[JHStoneSendGoodsView alloc]init];
    [self.view addSubview:_stoneSendGoodsView];
    [_stoneSendGoodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self.view);
    }];
    JH_WEAK(self)
    _stoneSendGoodsView.completeBlock = ^(id obj) {
        JH_STRONG(self)
        [self commit];
    };
}
-(void)commit {
    
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    NSMutableArray * arr=[NSMutableArray array];
    for (OrderPhotoMode * mode  in self.stoneSendGoodsView.allPhotos) {
        [arr addObject:mode.url];
    }
     NSString *photostrings = [arr componentsJoinedByString:@","];
    
    [dic setObject:photostrings forKey:@"voucherUrls"];
    [dic setObject:self.goodId forKey:@"goodId"];
    [dic setObject:self.stoneSendGoodsView.expressCode forKey:@"expressNumber"];
    [dic setObject:self.stoneSendGoodsView.expressCompanyCode forKey:@"expressCompany"];
    [dic setObject:self.addressModel.depositoryId forKey:@"depositoryId"];
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/express/personSend") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
//        [[UIApplication sharedApplication].keyWindow makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"发货成功" andDesc:nil cancleBtnTitle:@"确定"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        
        [self.navigationController popViewControllerAnimated:YES];
        if (self.sendSuccessBlock) {
        self.sendSuccessBlock(respondObject.data[@"orderStatus"]);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    [SVProgressHUD show];
}

- (void)getAddress{
    
    NSString *url = FILE_BASE_STRING(@"/auth/express/getDepositoryInfoByGoodId?goodId=%@");
    [HttpRequestTool getWithURL:[NSString stringWithFormat:url,self.goodId] Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.addressModel=[JHGoodSendAddressMode mj_objectWithKeyValues:respondObject.data];
        [self.stoneSendGoodsView setAddressModel:self.addressModel];

    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message];
    }];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

