//
//  JHRecycleOrderToolbarView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderToolbarView.h"

static const CGFloat FontSize = 13.f;

@interface JHRecycleOrderToolbarView()
/// 取消订单
@property (nonatomic, strong) UIButton *cancelButton;
/// 预约上门取件
@property (nonatomic, strong) UIButton *appointmentButton;
/// 查看取件预约
@property (nonatomic, strong) UIButton *checkAppointmentButton;
/// 订单追踪
@property (nonatomic, strong) UIButton *orderTrackButton;
/// 查看物流
@property (nonatomic, strong) UIButton *logisticsButton;
/// 确认交易
@property (nonatomic, strong) UIButton *dealButton;
/// 申请退回
@property (nonatomic, strong) UIButton *returnButton;
/// 申请仲裁
@property (nonatomic, strong) UIButton *arbitrationButton;
/// 查看仲裁
@property (nonatomic, strong) UIButton *checkArbitrationButton;
/// 申请销毁
@property (nonatomic, strong) UIButton *destructionButton;
/// 删除
@property (nonatomic, strong) UIButton *deleteButton;
/// 确认收货
@property (nonatomic, strong) UIButton *receivedButton;
/// 关闭交易
@property (nonatomic, strong) UIButton *closeButton;
/// 填写物流单号
@property (nonatomic, strong) UIButton *fillLogisticsButton;

@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, assign) CGFloat space;
@end
@implementation JHRecycleOrderToolbarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isHighlight = true;
        self.space = 15.f;
        [self setupUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Action functions

- (void)didClickAction : (UIButton *)sender {
    [self.viewModel didClickWithType:sender.tag];
}

#pragma mark - Private Functions
- (void)reMakeUIWithButtons : (NSArray<UIButton *> *)buttons {
    for (UIView *view in self.stackView.arrangedSubviews) {
        [self.stackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    for (UIButton *button in buttons) {
        [self.stackView addArrangedSubview:button];
    }
    if (self.stackView.arrangedSubviews.count >= 4) {
        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.lessThanOrEqualTo(self).offset(0);
            make.top.bottom.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
        }];
    }else {
        [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
        }];
    }
}

- (void)setupViewsWithList : (NSArray<NSNumber *> *) list {
    NSMutableArray<UIButton *> *buttons = [[NSMutableArray alloc]init];
    CGFloat contentWidth = 0;
    for (NSNumber *typen in list) {
        NSInteger type = [typen integerValue];
        UIButton *button = [self getButtonWithType:type];
        [buttons appendObject:button];
        CGFloat width = [self getWidthWithButton:button miniWidth:52 space:15];
        contentWidth += width + 10;
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
    }
    
    if (contentWidth - 10 > (ScreenW - self.leftSpace * 2)) {
        [self resetButtonWithButtons:buttons];
    }
    [self reMakeUIWithButtons:buttons];
}

- (CGFloat)getWidthWithButton : (UIButton *) button
                    miniWidth : (CGFloat) miniwidth
                        space : (CGFloat)space{
    
    NSString *title = button.titleLabel.text;
    UIFont *font = button.titleLabel.font;
    CGFloat width = [title getWidthWithFont:font constrainedToSize:CGSizeMake(1000, RecycleOrderArbitrationToolbarHeight)];
    CGFloat buttonWidth = width > miniwidth ? width + space * 2 : miniwidth + space * 2;
    return buttonWidth;
}
- (CGFloat)getMiniWidthWidthFontSize : (CGFloat)size {
    NSString *str = @"最小值哈";
    CGFloat width = [str getWidthWithFont:[UIFont fontWithName:kFontNormal size:size]
                        constrainedToSize:CGSizeMake(1000, RecycleOrderArbitrationToolbarHeight)];
    
    return width;
}
- (void)resetButtonWithButtons : (NSArray<UIButton *> *) buttons {

    CGFloat font = [self resetButtons:buttons fontSize:FontSize space:self.space];
    
    for (UIButton *button in buttons) {
        CGFloat width = [self getWidthWithButton:button miniWidth:[self getMiniWidthWidthFontSize : font] space:self.space];
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(RecycleOrderArbitrationToolbarHeight);
        }];
    }
}

- (CGFloat)resetButtons: (NSArray<UIButton *> *) buttons fontSize : (CGFloat)fontSize space : (CGFloat) space{
    CGFloat contentWidth = 0;
    for (UIButton *button in buttons) {
        button.titleLabel.font = [UIFont fontWithName:kFontNormal size:fontSize];
        CGFloat width = [self getWidthWithButton:button miniWidth:[self getMiniWidthWidthFontSize : fontSize] space:space];
        contentWidth += width + 10;
    }
    
    CGFloat sWidth = ScreenW - self.leftSpace * 2;
    if (contentWidth - 10 >= sWidth) {
        CGFloat sp = space - 0.5;
        if (sp < 10) {
            sp = 10;
        }
        return [self resetButtons:buttons fontSize:fontSize - 0.5 space:sp];
    }
    self.space = space;
    return fontSize;
}
- (UIButton *)getButtonWithType : (NSInteger)type {
    switch (type) {
        case RecycleOrderButtonTypeEnsure:
            return self.dealButton;
        case RecycleOrderButtonTypeCancel:
            return self.cancelButton;
        case RecycleOrderButtonTypeDelete:
            return self.deleteButton;
        case RecycleOrderButtonTypeReceived:
            return self.receivedButton;
        case RecycleOrderButtonTypePursue:
            return self.orderTrackButton;
        case RecycleOrderButtonTypeLogistics:
            return self.logisticsButton;
        case RecycleOrderButtonTypeAppointment:
            return self.appointmentButton;
        case RecycleOrderButtonTypeDestruction:
            return self.destructionButton;
        case RecycleOrderButtonTypeArbitration:
            return self.arbitrationButton;
        case RecycleOrderButtonTypeCheckAppointment:
            return self.checkAppointmentButton;
        case RecycleOrderButtonTypeCheckArbitration:
            return self.checkArbitrationButton;
        case RecycleOrderButtonTypeClose:
            return self.closeButton;
        case RecycleOrderButtonTypeReturn:
            return self.returnButton;
//        case RecycleOrderButtonTypeFillLogistics:
//            return self.fillLogisticsButton;
        default:
            return nil;
    }
}
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [[RACObserve(self.viewModel, buttonList)
     skip:0]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        NSArray *list = x;
        [self setupViewsWithList:list];
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    self.userInteractionEnabled = true;
    self.stackView.userInteractionEnabled = true;
    [self addSubview:self.stackView];
}
- (void)layoutViews {
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
}

#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderToolbarViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.spacing = 10;
        _stackView.alignment = UIStackViewAlignmentBottom;
        _stackView.distribution = UIStackViewDistributionFill;
    }
    return _stackView;
}
- (UIButton *)getButtonWithTitle : (NSString *)title tag : (RecycleOrderButtonType)tag bgColor : (BOOL)bgColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontNormal size:FontSize];
    if (bgColor && self.isHighlight) {
        button.backgroundColor = HEXCOLOR(0xffd70f);
    }else {
        [button jh_borderWithColor:HEXCOLOR(0xbdbfc2) borderWidth:0.5];
    }
    [button jh_cornerRadius:RecycleOrderArbitrationToolbarHeight / 2];
    [button addTarget:self  action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(RecycleOrderArbitrationToolbarHeight);
        make.size.mas_equalTo(CGSizeMake(0, RecycleOrderArbitrationToolbarHeight));
    }];
    
    return button;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [self getButtonWithTitle:@"取消订单" tag:RecycleOrderButtonTypeCancel bgColor:false];
    }
    return _cancelButton;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [self getButtonWithTitle:@"关闭交易" tag:RecycleOrderButtonTypeClose bgColor:false];
    }
    return _closeButton;
}
- (UIButton *)appointmentButton {
    if (!_appointmentButton) {
        _appointmentButton = [self getButtonWithTitle:@"预约上门取件" tag:RecycleOrderButtonTypeAppointment bgColor:true];
    }
    return _appointmentButton;
}
- (UIButton *)checkAppointmentButton {
    if (!_checkAppointmentButton) {
        _checkAppointmentButton = [self getButtonWithTitle:@"填写物流单号" tag:RecycleOrderButtonTypeCheckAppointment bgColor:true];
    }
    return _checkAppointmentButton;
}
- (UIButton *)orderTrackButton {
    if (!_orderTrackButton) {
        _orderTrackButton = [self getButtonWithTitle:@"订单追踪" tag:RecycleOrderButtonTypePursue bgColor:false];
    }
    return _orderTrackButton;
}
- (UIButton *)logisticsButton {
    if (!_logisticsButton) {
        _logisticsButton = [self getButtonWithTitle:@"查看物流" tag:RecycleOrderButtonTypeLogistics bgColor:true];
    }
    return _logisticsButton;
}
- (UIButton *)dealButton {
    if (!_dealButton) {
        _dealButton = [self getButtonWithTitle:@"确认交易" tag:RecycleOrderButtonTypeEnsure bgColor:true];
    }
    return _dealButton;
}
- (UIButton *)returnButton {
    if (!_returnButton) {
        _returnButton = [self getButtonWithTitle:@"申请寄回" tag:RecycleOrderButtonTypeReturn bgColor:false];
    }
    return _returnButton;
}
- (UIButton *)arbitrationButton {
    if (!_arbitrationButton) {
        _arbitrationButton = [self getButtonWithTitle:@"申请仲裁" tag:RecycleOrderButtonTypeArbitration bgColor:false];
    }
    return _arbitrationButton;
}
- (UIButton *)checkArbitrationButton {
    if (!_checkArbitrationButton) {
        _checkArbitrationButton = [self getButtonWithTitle:@"查看仲裁" tag:RecycleOrderButtonTypeCheckArbitration bgColor:false];
    }
    return _checkArbitrationButton;
}
- (UIButton *)destructionButton {
    if (!_destructionButton) {
        _destructionButton = [self getButtonWithTitle:@"申请销毁" tag:RecycleOrderButtonTypeDestruction bgColor:false];
    }
    return _destructionButton;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [self getButtonWithTitle:@"删除" tag:RecycleOrderButtonTypeDelete bgColor:false];
    }
    return _deleteButton;
}
- (UIButton *)receivedButton {
    if (!_receivedButton) {
        _receivedButton = [self getButtonWithTitle:@"确认收货" tag:RecycleOrderButtonTypeReceived bgColor:true];
    }
    return _receivedButton;
}
- (UIButton *)fillLogisticsButton {
    if (!_fillLogisticsButton) {
        _fillLogisticsButton = [self getButtonWithTitle:@"填写物流单号" tag:RecycleOrderButtonTypeReceived bgColor:true];
    }
    return _fillLogisticsButton;
}
@end
