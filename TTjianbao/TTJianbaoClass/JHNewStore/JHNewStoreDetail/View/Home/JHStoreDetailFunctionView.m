//
//  JHStoreDetailFunctionView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 功能区（店铺、客服、收藏、购买）

#import "JHStoreDetailFunctionView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHStoreDetailConst.h"
static const NSUInteger TitleSpace = 7;
static const CGFloat ButtonWidth = 35;

@interface JHStoreDetailFunctionView ()
/// 店铺
@property (nonatomic, strong) UIButton *shopButton;
/// 客服
@property (nonatomic, strong) UIButton *serviceButton;
/// 收藏
@property (nonatomic, strong) UIButton *collectButton;
/// 购买
@property (nonatomic, strong) UIButton *buyButton;
/// viewModel
@property (nonatomic, strong) JHStoreDetailFunctionViewModel *viewModel;
/// UIStackView
@property (nonatomic, strong) UIStackView *stackView;

@property(nonatomic, strong) UIView * buyButtonLayerView;

//拍卖相关按钮
/// 出价按钮
@property (nonatomic, strong) UIButton *priceBtn;
/// 设置代理出价
@property (nonatomic, strong) UIButton *agentBtn;
///拍卖蒙层
@property(nonatomic, strong) UIView * auctionButtonLayerView;

@property(nonatomic, strong) UILabel * priceSmallLbl;


@end

@implementation JHStoreDetailFunctionView


#pragma mark - Life Cycle Functions
- (instancetype)initWithViewModel : (JHStoreDetailFunctionViewModel *)viewModel {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.viewModel = viewModel;
        [self setupUI];
        [self bindData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Action functions
- (void) didClickButton : (UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [self pushShop];
            break;
        case 2:
            [self pushService];
            break;
        case 3:
            [self pushCollect];
            break;
        default:
            break;
    }
}
- (void) didClickBuyButton : (UIButton *)sender {
    [self.viewModel.buyAction sendNext:nil];
}
- (void) pushShop {
    [self.viewModel.shopAction sendNext:nil];
}
- (void) pushService {
    [self.viewModel.serviceAction sendNext:nil];
}
- (void) pushCollect {
    [self.viewModel.collectAction sendNext:nil];
}

- (void)priceBtnActionWithSender:(UIButton*)sender{
    [self.viewModel.buyPriceAction sendNext:nil];
}

- (void)agentBtnActionWithSender:(UIButton*)sender{
    [self.viewModel.agentSetAction sendNext:nil];
}

#pragma mark - Private Functions
- (UIButton *)getButton : (NSString *)imgName title : (NSString *)title tag : (NSUInteger)tag {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ButtonWidth, 32 + TitleSpace)];
    button.tag = tag;
    button.jh_title(title)
    .jh_imageName(imgName)
    .jh_fontNum(12)
    .jh_titleColor([UIColor colorWithHexString:@"333333"])
    .jh_action(self,@selector(didClickButton:));
    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:TitleSpace];
    return button;
}
/// 立即购买状态
- (void)setBuyState {
    NSString * str =  @"立即购买";
    switch (self.viewModel.functionView_type) {
        case JHStoreDetailFunctionView_Type_Auction:
            str  = @"立即付款";
            break;
        case JHStoreDetailFunctionView_Type_RushPurchase:
            str  = @"马上抢";
            break;
        default:
            break;
    }
    
    [self.buyButton setTitle:str forState:UIControlStateNormal];
    if (self.viewModel.discountPrice) {
        UIView *view = [self getBuyButtonLayerView:self.viewModel.discountPrice];
        self.buyButtonLayerView = view;
        [self.buyButton addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    [self setCanClickState];
}
/// 不可立即购买状态
- (void)setCantBuyState {
    NSString * str =  @"立即购买";
    switch (self.viewModel.functionView_type) {
        case JHStoreDetailFunctionView_Type_Auction:
            str  = @"立即付款";
            break;
        case JHStoreDetailFunctionView_Type_RushPurchase:
            str  = @"马上抢";
            break;
        default:
            break;
    }
    [self.buyButton setTitle:str forState:UIControlStateNormal];
    [self setCantClickState];
}
/// 开售提醒
- (void)setRemindState {
    NSString * str =   @"开售提醒";
    switch (self.viewModel.functionView_type) {
        case JHStoreDetailFunctionView_Type_Auction:
            str  = @"开拍提醒";
            break;
        case JHStoreDetailFunctionView_Type_RushPurchase:
            str  = @"开售提醒";
            break;
        default:
            break;
    }
    [self.buyButton setTitle:str forState:UIControlStateNormal];
    [self setCanClickState];
}
/// 已设置开售提醒
- (void)setRemindedState {
    NSString * str = @"已设置提醒";
    switch (self.viewModel.functionView_type) {
        case JHStoreDetailFunctionView_Type_Auction:
            str  = @"已设置开拍提醒";
            break;
        case JHStoreDetailFunctionView_Type_RushPurchase:
            str  = @"已设置提醒";
            break;
        default:
            break;
    }

    [self.buyButton setTitle:str forState:UIControlStateNormal];
    [self setCantClickState];
}
/// 已下架
- (void)setOffState {
    [self.buyButton setTitle:@"已下架" forState:UIControlStateNormal];
    [self setCantClickStateAndGrayColor];
}
/// 已抢光
- (void)setSoldoutState {
    [self.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
    [self setCantClickStateAndGrayColor];
}

- (void)setCanClickState {
    self.buyButton.selected = false;
    self.buyButton.backgroundColor = [UIColor colorWithHexString:@"FFD70F"];
}
- (void)setCantClickState {
    self.buyButton.selected = true;
    self.buyButton.backgroundColor = [UIColor colorWithHexString:@"FFD70F" alpha:0.6];
}

- (void)setCantClickStateAndGrayColor {
    self.buyButton.selected = true;
    self.buyButton.backgroundColor = HEXCOLOR(0xD8D8D8);
}


/// 拍卖流拍
- (void)auctionfinish {
    [self.buyButton setTitle:@"已结束" forState:UIControlStateNormal];
    [self setCantClickStateAndGrayColor];
}

/// 拍卖卖出
- (void)auctionSoldOut {
    [self.buyButton setTitle:@"已成交" forState:UIControlStateNormal];
    [self setCantClickState];
}

/// 拍卖进行中状态 未领先或没参加
- (void)auctionSelling {
    UIView *view = [self getAuctionBuyButtonLayerViewLingXian:NO];
    self.auctionButtonLayerView = view;
    [self.buyButton addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    if (self.viewModel.detailAuModel.earnestMoney == 0) {
        self.priceBtn.titleEdgeInsets =  UIEdgeInsetsZero;
        self.priceSmallLbl.hidden = YES;
    }
    self.priceSmallLbl.text = [NSString stringWithFormat:@"保证金￥%@",[CommHelp getPriceWithInterFen:self.viewModel.detailAuModel.earnestMoney]];
    [self setCanClickState];
}

/// 拍卖进行中状态 领先
- (void)auctionSelling_lingXian {
    UIView *view = [self getAuctionBuyButtonLayerViewLingXian:YES];
    self.auctionButtonLayerView = view;
    [self.buyButton addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self setCanClickState];
}

#pragma mark - Bind
- (void) bindData {
    @weakify(self)

    [RACObserve(self.viewModel, purchaseStatus) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        NSInteger status = [x integerValue];
        [self.buyButtonLayerView removeFromSuperview];
        [self.auctionButtonLayerView removeFromSuperview];
        if (status == PurchaseStateBuy) {
            [self setBuyState];
        }else if (status == PurchaseStateSalesRemind) {
            [self setRemindState];
        }else if (status == PurchaseStateSalesReminded) {
            [self setRemindedState];
        }else if (status == PurchaseStateOff) {
            [self setOffState];
        }else if (status == PurchaseStateSoldout) {
            [self setSoldoutState];
        }else if (status == PurchaseStateCantBuy) {
            [self setCantBuyState];
        }else if (status == PurchaseStateFinish) {
            [self auctionfinish];
        }else if (status == PurchaseStateFinish_Soldout) {
            [self auctionSoldOut];
        }else if (status == PurchaseStateAuction_Selling) {
            [self auctionSelling];
        }else if (status == PurchaseStateAuction_Selling_LingXian) {
            [self auctionSelling_lingXian];
        }
    }];
    
    [RACObserve(self.viewModel, collectState) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        NSUInteger state = [x unsignedIntegerValue];
        if (self.collectButtonClickBlock) {
            self.collectButtonClickBlock();
        }
        if (state == 1) {
            self.collectButton.selected = true;
        }else{
            self.collectButton.selected = false;
        }
        [self.collectButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:TitleSpace];
    }];

}
#pragma mark - UI
- (void) setupUI {
    [self addSubview:self.stackView];
//    [self addSubview:self.buyButton];
    
}
- (void) layoutViews {
    [self.shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ButtonWidth);
    }];
    [self.serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.shopButton);
    }];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.shopButton);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.right.equalTo(self).offset(-LeftSpace);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(217);
        make.height.mas_equalTo(40);
    }];
}
#pragma mark - Lazy
- (UIButton *)shopButton {
    if (!_shopButton){
        _shopButton = [self getButton:@"newStore_shop_icon" title:@"店铺" tag:1];
    }
    return _shopButton;
}
- (UIButton *)serviceButton {
    if (!_serviceButton) {
        _serviceButton = [self getButton:@"newStore_service_black_icon" title:@"客服" tag:2];
    }
    return _serviceButton;
}
- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [self getButton:@"newStore_collect_icon" title:@"收藏" tag:3];
        [_collectButton setTitle:@"已收藏"
                        forState:UIControlStateSelected];
        [_collectButton setImage:[UIImage imageNamed:@"newStore_collect_orange_icon"]
                        forState:UIControlStateSelected];
    }
    return _collectButton;
}
- (UIButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _buyButton.jh_boldFontNum(16)
        .jh_action(self,@selector(didClickBuyButton:));
        [_buyButton jh_cornerRadius:4];
        [_buyButton setTitleColor: kColor222 forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor colorWithHexString:@"222222" alpha:0.6]
                         forState:UIControlStateSelected];
        
    }
    return _buyButton;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
            self.shopButton,
            self.serviceButton,
            self.collectButton,
            self.buyButton]];
        
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
        
    }
    return _stackView;
}

- (UIView *)getBuyButtonLayerView:(NSString*)price{
    UIView *view = [UIView new];
    view.userInteractionEnabled = NO;
    view.layer.cornerRadius = 4;
    view.backgroundColor = HEXCOLOR(0xFFD70F);
    
    UILabel *topLbl = [UILabel new];
    topLbl.font = JHMediumFont(14);
    topLbl.text = @"领券购买";
    topLbl.textAlignment = NSTextAlignmentCenter;
    topLbl.textColor = HEXCOLOR(0x222222);
    
    
    UILabel *desLbl = [UILabel new];
    desLbl.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"到手价"
                                                                            attributes:@{NSFontAttributeName : JHFont(9),NSForegroundColorAttributeName :HEXCOLOR(0x222222)}];
    NSString *str = [NSString stringWithFormat:@"￥%@",price];
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:str
                                                                attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontBoldDIN size:10],NSForegroundColorAttributeName :HEXCOLOR(0x222222)}]];
    desLbl.attributedText = att;
    
    
    [view addSubview:topLbl];
    [view addSubview:desLbl];
    [topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@0).offset(4);
    }];
    
    [desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(topLbl.mas_bottom);
    }];
    return view;
}

///拍卖出价状态浮层
- (UIView *)getAuctionBuyButtonLayerViewLingXian:(BOOL)lingXian{
    UIView *view = [UIView new];
    view.backgroundColor = UIColor.whiteColor;
    [view addSubview:self.priceBtn];
    [view addSubview:self.agentBtn];
    self.priceBtn.enabled = !lingXian;
    self.priceBtn.backgroundColor = lingXian ? HEXCOLOR(0xEBEBEB) : HEXCOLOR(0xFFD70F);
    
    self.priceBtn.titleEdgeInsets = lingXian ? UIEdgeInsetsZero : UIEdgeInsetsMake(-5, 0, 5, 0);
    self.priceSmallLbl.hidden = lingXian;
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0).inset(2);
        make.right.equalTo(@0);
        make.width.equalTo(@90);
    }];
    
    [self.agentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0).inset(2);
        make.left.equalTo(@0);
        make.width.equalTo(@116);
    }];
    
    return view;
}


- (UIButton *)priceBtn{
    if (!_priceBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"立即出价" forState:UIControlStateNormal];
        [btn setTitle:@"您已领先" forState:UIControlStateDisabled];
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0xFF6A00) forState:UIControlStateDisabled];
        btn.titleLabel.font = JHMediumFont(16);
        [btn addTarget:self action:@selector(priceBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = HEXCOLOR(0xFFD70F);
        [btn addSubview:self.priceSmallLbl];
        [self.priceSmallLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0).inset(2);
            make.centerX.equalTo(@0);
        }];
        _priceBtn = btn;
    }
    return _priceBtn;
}

- (UIButton *)agentBtn{
    if (!_agentBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"设置代理出价" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(16);
        [btn addTarget:self action:@selector(agentBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 4;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = HEXCOLOR(0xcccccc).CGColor;

        _agentBtn = btn;
    }
    return _agentBtn;
}

- (UILabel *)priceSmallLbl{
    if (!_priceSmallLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(9);
        label.textColor = HEXCOLOR(0x222222);
        _priceSmallLbl = label;
        label.hidden = YES;
    }
    return _priceSmallLbl;
}
@end
