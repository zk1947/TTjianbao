//
//  JHRefundDetailBottomBtnView.m
//  TTjianbao
//
//  Created by hao on 2021/5/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRefundDetailBottomBtnView.h"
#import "CommAlertView.h"

@interface JHRefundDetailBottomBtnView ()
@property (nonatomic, strong) UIButton *deleteBtn;//删除
@property (nonatomic, strong) UIButton *applyInterventionBtn;//仲裁申请介入
@property (nonatomic, strong) UIButton *modifyApplyBtn;//修改申请
@property (nonatomic, strong) UIButton *revokApplyBtn;//撤销申请
@property (nonatomic, strong) UIButton *returnBtn;//去退货  --
@property (nonatomic, strong) UIButton *addlogisticsOrderNumBtn;//填写物流单号 --
@property (nonatomic, strong) UIButton *remindSellerBtn;//提醒卖家收货
@property (nonatomic, strong) UIButton *agreeRefundBtn;//同意退款 --
@property (nonatomic, strong) UIButton *refuseRefundBtn;//拒绝退款
@property (nonatomic, strong) UIButton *shippedRefuseRefundBtn;//已发货拒绝退款
@property (nonatomic, strong) UIButton *interventionResultBtn;//平台介入结果
@property (nonatomic, strong) UIButton *agreeReturnBtn;//同意退货
@property (nonatomic, strong) UIButton *refuseReturnBtn;//拒绝退货
@property (nonatomic, strong) UIButton *remindBuyerBtn;//提醒买家发货
@property (nonatomic, strong) UIButton *receiveAgreeRefundBtn;//收到货同意退款

@end

@implementation JHRefundDetailBottomBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    [self addSubview:self.deleteBtn];
    [self addSubview:self.applyInterventionBtn];
    [self addSubview:self.modifyApplyBtn];
    [self addSubview:self.revokApplyBtn];
    [self addSubview:self.returnBtn];
    [self addSubview:self.remindSellerBtn];
    [self addSubview:self.addlogisticsOrderNumBtn];
    [self addSubview:self.agreeRefundBtn];
    [self addSubview:self.refuseRefundBtn];
    [self addSubview:self.shippedRefuseRefundBtn];
    [self addSubview:self.interventionResultBtn];
    [self addSubview:self.agreeReturnBtn];
    [self addSubview:self.refuseReturnBtn];
    [self addSubview:self.remindBuyerBtn];
    [self addSubview:self.receiveAgreeRefundBtn];
    
    for (UIButton *button in @[self.deleteBtn, self.applyInterventionBtn, self.modifyApplyBtn, self.revokApplyBtn, self.returnBtn, self.remindSellerBtn, self.addlogisticsOrderNumBtn, self.agreeRefundBtn, self.refuseRefundBtn, self.shippedRefuseRefundBtn, self.interventionResultBtn, self.agreeReturnBtn, self.refuseReturnBtn, self.remindBuyerBtn, self.receiveAgreeRefundBtn]) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self);
        }];
    }
}

//初始化约束,设置宽度为0,按钮全部隐藏
- (void)initializeConstraints {
    for (UIButton *button in @[self.deleteBtn, self.applyInterventionBtn, self.modifyApplyBtn, self.revokApplyBtn, self.returnBtn, self.remindSellerBtn, self.addlogisticsOrderNumBtn, self.agreeRefundBtn, self.refuseRefundBtn, self.shippedRefuseRefundBtn, self.interventionResultBtn, self.agreeReturnBtn, self.refuseReturnBtn, self.remindBuyerBtn, self.receiveAgreeRefundBtn]) {
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

#pragma mark - LoadData
//按钮添加顺序如下:删除 撤销申请 修改申请 去退货 填写物流单号 提醒买家发货 申请平台介入 平台介入结果  提醒卖家收货 同意退款 拒绝退款 同意退货 拒绝退货 收到货,同意退款 已发货,拒绝发货
- (void)setRefundButtonShowModel:(JHRefundButtonShowModel *)refundButtonShowModel{
    _refundButtonShowModel = refundButtonShowModel;
    [self initializeConstraints];  //先初始化一下约束
    
    NSMutableArray *array = [NSMutableArray array];
    if ([refundButtonShowModel.deleteBtn boolValue]) {//删除
        [array addObject:self.deleteBtn];
    }
    if ([refundButtonShowModel.cancel boolValue]) {//撤销申请
        [array addObject:self.revokApplyBtn];
    }
    if ([refundButtonShowModel.update boolValue]) {//修改申请
        [array addObject:self.modifyApplyBtn];
    }
    if ([refundButtonShowModel.goRefundGoods boolValue]) {//去退货
        [array addObject:self.returnBtn];
    }
    if ([refundButtonShowModel.addlogisticsOrderNo boolValue]) {//填写物流单号
        [array addObject:self.addlogisticsOrderNumBtn];
    }
    if ([refundButtonShowModel.remindSend boolValue]) { //提醒买家发货
        [array addObject:self.remindBuyerBtn];
    }
    if ([refundButtonShowModel.applyArd boolValue]) { //申请平台介入
        [array addObject:self.applyInterventionBtn];
    }
    if ([refundButtonShowModel.ardDetail boolValue]) {//平台介入结果
        [array addObject:self.interventionResultBtn];
    }
    if ([refundButtonShowModel.remindReceiving boolValue]) {//提醒卖家收货
        [array addObject:self.remindSellerBtn];
    }
    if ([refundButtonShowModel.agreeRefund boolValue]) {//同意退款
        [array addObject:self.agreeRefundBtn];
    }
    if ([refundButtonShowModel.refuseRefund boolValue]) {//拒绝退款
        [array addObject:self.refuseRefundBtn];
    }
    if ([refundButtonShowModel.agreeRefundGoods boolValue]) {//同意退货
        [array addObject:self.agreeReturnBtn];
    }
    if ([refundButtonShowModel.refuseRefundGoods boolValue]) { //拒绝退货
        [array addObject:self.refuseReturnBtn];
    }
    if ([refundButtonShowModel.goodsAgreeRefund boolValue]) {//收到货,同意退款
        [array addObject:self.receiveAgreeRefundBtn];
    }
    if ([refundButtonShowModel.goodsRefuseRefund boolValue]) { //已发货,拒绝退款
        [array addObject:self.shippedRefuseRefundBtn];
    }

    [self remakeConstraintsWithArray:array];
}

// 重新定义button的约束,使该显示的显示 该隐藏的隐藏
- (void)remakeConstraintsWithArray:(NSArray <UIButton *>*)buttonsArray {
    UIButton *lastButton;
    for (int i = 0; i < buttonsArray.count; i++) {
        UIButton *button = buttonsArray[i];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (button.titleLabel.text.length > 4) {
                button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
            }else{
                make.width.mas_equalTo(78);
            }
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self);
            if (i == 0) {
                make.right.mas_equalTo(self);
            }else {
                make.right.mas_equalTo(lastButton.mas_left).offset(-10);
            }
        }];
        lastButton = button;
    }
}


#pragma mark - Action
// 按钮点击事件
- (void)buttonClickAction:(UIButton *)sender {
    if (self.clickActionBlock) {
        self.clickActionBlock(sender.tag);
    }
}


#pragma mark - Delegate


#pragma mark - Lazy
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [self getButtonWithColor:NO name:@"删除" tag:RefundDetailBottomBtnTagDelete];
    }
    return _deleteBtn;
}
- (UIButton *)applyInterventionBtn {
    if (!_applyInterventionBtn) {
        _applyInterventionBtn = [self getButtonWithColor:NO name:@"申请平台介入" tag:RefundDetailBottomBtnTagApplyIntervention];
    }
    return _applyInterventionBtn;
}
- (UIButton *)interventionResultBtn {
    if (!_interventionResultBtn) {
        _interventionResultBtn = [self getButtonWithColor:NO name:@"平台介入结果" tag:RefundDetailBottomBtnTagInterventionResult];
    }
    return _interventionResultBtn;
}
- (UIButton *)modifyApplyBtn {
    if (!_modifyApplyBtn) {
        _modifyApplyBtn = [self getButtonWithColor:NO name:@"修改申请" tag:RefundDetailBottomBtnTagModifyApply];
    }
    return _modifyApplyBtn;
}
- (UIButton *)revokApplyBtn {
    if (!_revokApplyBtn) {
        _revokApplyBtn = [self getButtonWithColor:NO name:@"撤销申请" tag:RefundDetailBottomBtnTagRevokApply];
    }
    return _revokApplyBtn;
}
- (UIButton *)returnBtn {
    if (!_returnBtn) {
        _returnBtn = [self getButtonWithColor:YES name:@"去退货" tag:RefundDetailBottomBtnTagReturn];
    }
    return _returnBtn;
}
- (UIButton *)addlogisticsOrderNumBtn {
    if (!_addlogisticsOrderNumBtn) {
        _addlogisticsOrderNumBtn = [self getButtonWithColor:YES name:@"填写物流单号" tag:RefundDetailBottomBtnTagAddOrderNum];
    }
    return _addlogisticsOrderNumBtn;
}
- (UIButton *)remindSellerBtn {
    if (!_remindSellerBtn) {
        _remindSellerBtn = [self getButtonWithColor:NO name:@"提醒卖家收货" tag:RefundDetailBottomBtnTagRemindSeller];
    }
    return _remindSellerBtn;
}

- (UIButton *)agreeRefundBtn {//查看介入结果
    if (!_agreeRefundBtn) {
        _agreeRefundBtn = [self getButtonWithColor:YES name:@"同意退款" tag:RefundDetailBottomBtnTagAgreeRefund];
    }
    return _agreeRefundBtn;
}
- (UIButton *)refuseRefundBtn {//查看介入结果
    if (!_refuseRefundBtn) {
        _refuseRefundBtn = [self getButtonWithColor:NO name:@"拒绝退款" tag:RefundDetailBottomBtnTagRefuseRefund];
    }
    return _refuseRefundBtn;
}
- (UIButton *)shippedRefuseRefundBtn {
    if (!_shippedRefuseRefundBtn) {
        _shippedRefuseRefundBtn = [self getButtonWithColor:NO name:@"已发货，拒绝退款" tag:RefundDetailBottomBtnTagShippedRefuseRefund];
    }
    return _shippedRefuseRefundBtn;
}

- (UIButton *)agreeReturnBtn {
    if (!_agreeReturnBtn) {
        _agreeReturnBtn = [self getButtonWithColor:NO name:@"同意退货" tag:RefundDetailBottomBtnTagAgreeReturn];
    }
    return _agreeReturnBtn;
}
- (UIButton *)refuseReturnBtn {
    if (!_refuseReturnBtn) {
        _refuseReturnBtn = [self getButtonWithColor:NO name:@"拒绝退货" tag:RefundDetailBottomBtnTagRefuseReturn];
    }
    return _refuseReturnBtn;
}
- (UIButton *)remindBuyerBtn {
    if (!_remindBuyerBtn) {
        _remindBuyerBtn = [self getButtonWithColor:NO name:@"提醒买家发货" tag:RefundDetailBottomBtnTagRemindBuyer];
    }
    return _remindBuyerBtn;
}
- (UIButton *)receiveAgreeRefundBtn {
    if (!_receiveAgreeRefundBtn) {
        _receiveAgreeRefundBtn = [self getButtonWithColor:NO name:@"收到货，同意退款" tag:RefundDetailBottomBtnTagReceiveAgreeRefund];
    }
    return _receiveAgreeRefundBtn;
}

// 初始化按钮
- (UIButton *)getButtonWithColor:(BOOL )backColor name:(NSString *)name tag:(RefundDetailBottomBtnTag )tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    button.layer.cornerRadius = 15;
    button.clipsToBounds = YES;
    if (backColor) { //需要填充按钮颜色
        button.backgroundColor = HEXCOLOR(0xffd70f);
    }else {
        button.layer.borderColor = HEXCOLOR(0xbdbfc2).CGColor;
        button.layer.borderWidth = 0.5;
    }
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}



@end
