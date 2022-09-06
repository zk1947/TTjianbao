//
//  JHC2CWriteOrderNumViewController.m
//  TTjianbao
//
//  Created by hao on 2021/6/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#import "JHC2CWriteOrderNumViewController.h"
#import "UIImage+JHColor.h"
#import <IQKeyboardManager.h>
#import "JHQRViewController.h"
#import "CommAlertView.h"
#import "JHC2CSendServiceViewModel.h"
#import "JHRefundDetailBusiness.h"

@interface JHC2CWriteOrderNumViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *writeInfoView;
@property (nonatomic, strong) UIImageView *logisticsLogoImg;//快递logo
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UITextField *enterNumTF;
@property (nonatomic, strong) UIButton *scanBtn;//扫描

@property (nonatomic, strong) UIButton *cancelBtn;//取消寄件
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) JHC2CSendServiceViewModel *sendViewModel;
@end

@implementation JHC2CWriteOrderNumViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"填写物流单号";
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 60 + UI.bottomSafeAreaHeight, 0));
    }];
    
    //填写信息
    [self addWriteInfoView];
    //底部提交
    [self addBottomInfoView];
    
    [self loadData];
    [self configData];
}

#pragma mark - UI
///填写信息
- (void)addWriteInfoView{
    [self.contentView addSubview:self.writeInfoView];
    [self.writeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.width.offset(kScreenWidth-24);
    }];
    
    [self.writeInfoView addSubview:self.logisticsLogoImg];
    [self.logisticsLogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.writeInfoView).offset(23);
        make.centerX.equalTo(self.writeInfoView);
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(42);
    }];
    
    [self.writeInfoView addSubview:self.descriptionLabel];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsLogoImg.mas_bottom).offset(23);
        make.left.equalTo(self.writeInfoView).offset(12);
        make.right.equalTo(self.writeInfoView).offset(-12);
    }];
    
    UIView *enterView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.writeInfoView];
    [enterView jh_cornerRadius:5.0 borderColor:HEXCOLOR(0xF0F0F0) borderWidth:1.0];
    [enterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(10);
        make.left.equalTo(self.writeInfoView).offset(12);
        make.right.equalTo(self.writeInfoView).offset(-12);
        make.height.mas_offset(44);
        make.bottom.equalTo(self.writeInfoView).offset(-20);
    }];
    //添加快递单号输入框
    [enterView addSubview:self.enterNumTF];
    [self.enterNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(enterView).offset(10);
        make.top.bottom.equalTo(enterView);
        make.right.equalTo(enterView).offset(-45);
    }];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"请输入快递单号" attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x999999),NSFontAttributeName:[UIFont fontWithName:kFontNormal size:14]}];
    self.enterNumTF.attributedPlaceholder = attrString;

    //单号扫描
    [enterView addSubview:self.scanBtn];
    [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(enterView);
        make.right.equalTo(enterView).offset(-10);
        make.size.mas_offset(CGSizeMake(23, 21));
    }];
    
    //取消寄件
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.writeInfoView.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-12);
    }];
    ///只有从退款详情的“已发货拒绝退款”按钮过来需要传cancelWorkOrder处理
    if (self.cancelWorkOrder == 1) {
        self.cancelBtn.hidden = YES;
    }else{
        self.cancelBtn.hidden = NO;
    }

    
}

///底部提交
- (void)addBottomInfoView{
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(37);
        make.right.equalTo(self.view).offset(-37);
        make.bottom.equalTo(self.view.mas_bottom).offset(-8-UI.bottomSafeAreaHeight);
        make.height.mas_equalTo(44);
    }];

}
#pragma mark - LoadData
- (void)loadData{
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"appointmentSource"] = @(self.appointmentSource);
    dicData[@"orderId"] = @([self.orderId integerValue]);
    [self.sendViewModel.writeOrderCommand execute:dicData];
}

- (void)configData{
    @weakify(self)
    //获取快递信息
    [self.sendViewModel.writeOrderSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSDictionary *dataDic = x;
        NSString *logoImage = dataDic[@"logoImage"];
        [self.logisticsLogoImg jh_setImageWithUrl:logoImage placeHolder:@"newStore_default_placehold"];
        
        if (logoImage.length > 0) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoImage]];
            UIImage *image = [UIImage imageWithData:data];
            [self.logisticsLogoImg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(42*image.size.width/image.size.height);
            }];
        }
    }];
    //取消寄件
    [self.sendViewModel.cancelMailingSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //返回订单页面
        if (self.fromStatus == 1) {
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        //取消成功
        [self.writeSuccessSubject sendNext:@{@"isDelete":@"NO"}];
        JHTOAST(@"取消寄件成功");
    }];
    //确认邮寄
    [self.sendViewModel.confirmMailingSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //返回订单页面
        if (self.fromStatus == 1) {
            JHTOAST(@"提交成功");
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
            //填写确认成功
            [self.writeSuccessSubject sendNext:@{@"isDelete":@"NO"}];
        }else{
            if (self.cancelWorkOrder == 1) {
                NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
                dicData[@"orderId"] = self.orderId;
                dicData[@"flag"] = [NSString stringWithFormat:@"%ld",(long)self.customerFlag];
                dicData[@"workOrderId"] = self.workOrderId;
                [JHRefundDetailBusiness requestRefundCancelWorkOrderWithParams:dicData Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error) {
                        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
                        //撤销成功监听
                        [self.writeSuccessSubject sendNext:@{@"isDelete":@"NO"}];
                       
                    }else{
                        JHTOAST(@"撤销失败");
                    }
                }];
            }else{
                JHTOAST(@"提交成功");
                [self.navigationController popViewControllerAnimated:YES];
                //填写确认成功
                [self.writeSuccessSubject sendNext:@{@"isDelete":@"NO"}];
            }
        }
        
    }];

    
    
}

#pragma mark - Action
- (void)backActionButton:(UIButton *)sender{
    if (self.fromStatus == 1) {
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
        
        [self.writeSuccessSubject sendNext:@YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///快递号扫描
- (void)clickScanBtnAction:(UIButton *)sender{
    @weakify(self);
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    vc.titleString = @"扫描快递单号";
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
        @strongify(self);
        self.enterNumTF.text = scanString;
        
        [obj.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

///取消寄件
- (void)clickCancelBtnAction:(UIButton *)sender{
    [self.enterNumTF resignFirstResponder];
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"确认取消上门取件？" andDesc:@"" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
        dicData[@"orderCode"] = self.orderCode;
        dicData[@"orderId"] = @([self.orderId integerValue]);
        dicData[@"productId"] = @([self.productId integerValue]);
        [self.sendViewModel.cancelMailingCommand execute:dicData];
    };

}
///确认提交
- (void)clickSubmitBtnAction:(UIButton *)sender{
    [self.enterNumTF resignFirstResponder];
    if (self.enterNumTF.text.length <= 0) {
        JHTOAST(@"请输入快递单号");
        return;
    }
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"appointmentSource"] = @(self.appointmentSource);
    dicData[@"orderCode"] = self.orderCode;
    dicData[@"orderId"] = @([self.orderId integerValue]);
    dicData[@"productId"] = @([self.productId integerValue]);
    dicData[@"expressNumber"] = self.enterNumTF.text;
    [self.sendViewModel.confirmMailingCommand execute:dicData];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Delegate
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];

    if ([string isEqualToString:filtered]) {
        if (textField == self.enterNumTF) {
            // 这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
            if (range.length == 1 && string.length == 0) {
                return YES;
            }  else if (self.enterNumTF.text.length >= 30) {
                self.enterNumTF.text = [textField.text substringToIndex:30];
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.enterNumTF resignFirstResponder];
    return NO;
}


#pragma mark - Lazy
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = HEXCOLOR(0xF5F6FA);
    }
    return _contentView;
}
- (UIView *)writeInfoView{
    if (!_writeInfoView) {
        _writeInfoView = [[UIView alloc] init];
        _writeInfoView.backgroundColor = UIColor.whiteColor;
        _writeInfoView.layer.cornerRadius = 5;
        _writeInfoView.layer.masksToBounds = YES;
    }
    return _writeInfoView;
}
- (UIImageView *)logisticsLogoImg{
    if (!_logisticsLogoImg) {
        _logisticsLogoImg = [[UIImageView alloc] init];
    }
    return _logisticsLogoImg;
}
- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = HEXCOLOR(0x333333);
        _descriptionLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.text = @"如您的快递已经被快递小哥完成揽收，请尽快在下方完成快递单号的填写，以便您和买家能随时追踪物流。";
    }
    return _descriptionLabel;
}
- (UITextField *)enterNumTF{
    if (!_enterNumTF) {
        _enterNumTF = [[UITextField alloc] init];
        _enterNumTF.placeholder = @"请输入快递单号";
        _enterNumTF.textColor = HEXCOLOR(0x333333);
        _enterNumTF.font = [UIFont fontWithName:kFontNormal size:14];
        _enterNumTF.keyboardType = UIKeyboardTypeASCIICapable;
        _enterNumTF.textAlignment = NSTextAlignmentLeft;
        _enterNumTF.delegate = self;

    }
    return _enterNumTF;
}
- (UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanBtn setBackgroundImage:JHImageNamed(@"c2c_scan_iocn") forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(clickScanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消寄件" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_cancelBtn setTitleColor:HEXCOLOR(0x007AFF) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(clickCancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [_submitBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_submitBtn setBackgroundImage:[UIImage gradientThemeImageSize:CGSizeMake(kScreenWidth-74, 44) radius:22] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(clickSubmitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (JHC2CSendServiceViewModel *)sendViewModel{
    if (!_sendViewModel) {
        _sendViewModel = [[JHC2CSendServiceViewModel alloc] init];
    }
    return _sendViewModel;
}
- (RACSubject *)writeSuccessSubject{
    if (!_writeSuccessSubject) {
        _writeSuccessSubject = [[RACSubject alloc] init];
    }
    return _writeSuccessSubject;
}
@end
