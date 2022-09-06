//
//  JHSellerOrderView.h
//  TTjianbao
//
//  Created by jiang on 2019/12/17.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSellerOrderView.h"
#import "BYTimer.h"
#import "JHCouponListView.h"
#import "JHMallCoponListView.h"
#import "JHOrderViewModel.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoUtil.h"
#import "JHUIFactory.h"
#import "JHItemMode.h"
#import "JHOrderRemainTimeView.h"
#import "JHOrderAdressView.h"
#import "JHOrderProductView.h"
#import "JHOrderDetailAppraiseStepView.h"
#import "JHStoreDetailViewController.h"
#import "JHOrderGoodsPriceView.h"
#import "JHOrderShopTrolleyView.h"
#import "JHOrderFeeView.h"
#import "JHOrderDeductionView.h"
#import "JHOrderProcessDescView.h"
#import "JHOrderBuyerNoteView.h"
#import "JHOrderSellerNoteView.h"
#import "JHOrderPayListView.h"
#import "JHOrderStoneOriginalProductView.h"
#import "JHOrderInfoView.h"
#import "JHOrderButtonsView.h"
@interface JHSellerOrderView ()
{
    BYTimer *timer;
}

@property(nonatomic,strong) JHOrderRemainTimeView * remainTimeView;
@property(nonatomic,strong) JHOrderAdressView * addressView;
@property(nonatomic,strong) JHOrderProductView *productView;
@property(nonatomic,strong) JHOrderDetailAppraiseStepView *appraiseStepView;
@property(nonatomic,strong) JHOrderShopTrolleyView *shopTrolleyView;

@property(nonatomic,strong) JHOrderGoodsPriceView *goodsPriceView;
@property(nonatomic,strong) JHOrderDeductionView *processDeductionView;

@property(nonatomic,strong) JHOrderFeeView *feeView;
@property(nonatomic,strong) JHOrderDeductionView *deductionView;
@property(nonatomic,strong) JHOrderProcessDescView *processDescView;//加工描述
@property(nonatomic,strong) JHOrderBuyerNoteView *buyerNoteView;
@property(nonatomic,strong) JHOrderSellerNoteView *sellerNoteView;
@property(nonatomic,strong) JHOrderInfoView *orderInfoView;
@property(nonatomic,strong) JHOrderStoneOriginalProductView *stoneOriginalProductView;
@property(nonatomic,strong) JHOrderPayListView *payListView;
@property(nonatomic,strong) JHOrderButtonsView *buttonBackView;
@property(nonatomic,strong) UIView *serviceView;
@end
@implementation JHSellerOrderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollview];
    }
    return self;
}
-(void)initScrollview{
    
    self.contentScroll=[[UIView alloc]init];
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initTitleView];
    [self initAddressView];
    [self initProductView];
    [self initAppraiseStepView];
    [self initShopTrolleyView];
    [self initGoodsPriceView];
    [self initProcessDeductionView];
    
    [self initFeeView];
    [self initDeductionView];
    [self initProcessDescView];
    [self initBuyerNoteView];
    [self initSellerNoteView];
    [self initPayListView];
    [self initStoneOriginalProductView];
    [self initOrderInfoView];
    [self initServeView];
    
}
-(void)initTitleView{
    
    _remainTimeView=[[JHOrderRemainTimeView alloc]init];
    [self.contentScroll addSubview:_remainTimeView];
    [_remainTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(0);
        make.width.offset(ScreenW-20);
    }];
    
}
-(void)initAddressView{
    
    _addressView=[[JHOrderAdressView alloc]init];
    [self.contentScroll addSubview:_addressView];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remainTimeView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(0);
    }];
}
-(void)initProductView{
    
    _productView=[[JHOrderProductView alloc]init];
    _productView.userInteractionEnabled=YES;
    [_productView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productViewTap:)]];
    [self.contentScroll addSubview:_productView];
    
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        //        make.height.offset(120);
    }];
}
-(void)initAppraiseStepView{
    
    _appraiseStepView=[[JHOrderDetailAppraiseStepView alloc]init];
    [self.contentScroll addSubview:_appraiseStepView];
    
    [_appraiseStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(63);
    }];
    
}
-(void)initShopTrolleyView{
    
    _shopTrolleyView=[[JHOrderShopTrolleyView alloc]init];
    [self.contentScroll addSubview:_shopTrolleyView];
    
    [_shopTrolleyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_appraiseStepView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(0);
    }];
    
}
-(void)initGoodsPriceView{
    
    _goodsPriceView=[[JHOrderGoodsPriceView alloc]init];
    [self.contentScroll addSubview:_goodsPriceView];
    [_goodsPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shopTrolleyView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(0);
    }];
}
-(void)initProcessDeductionView{
    _processDeductionView =[[JHOrderDeductionView alloc]init];
    [self.contentScroll addSubview:_processDeductionView];
    [_processDeductionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsPriceView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initFeeView{
    
    _feeView=[[JHOrderFeeView alloc]init];
    [self.contentScroll addSubview:_feeView];
    
    [_feeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_processDeductionView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
}
-(void)initDeductionView{
    _deductionView=[[JHOrderDeductionView alloc]init];
    [self.contentScroll addSubview:_deductionView];
    [_deductionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feeView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initProcessDescView{
    _processDescView=[[JHOrderProcessDescView alloc]init];
    [self.contentScroll addSubview:_processDescView];
    [_processDescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deductionView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initBuyerNoteView{
    _buyerNoteView=[[JHOrderBuyerNoteView alloc]init];
    [self.contentScroll addSubview:_buyerNoteView];
    [_buyerNoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_processDescView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initSellerNoteView{
    _sellerNoteView=[[JHOrderSellerNoteView alloc]init];
    [self.contentScroll addSubview:_sellerNoteView];
    [_sellerNoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buyerNoteView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initPayListView{
    
    _payListView=[[JHOrderPayListView alloc]init];
    [self.contentScroll addSubview:_payListView];
    [_payListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sellerNoteView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
    JH_WEAK(self)
    _payListView.buttonHandle = ^(id obj) {
        JH_STRONG(self)
        UIButton *button=(UIButton*)obj;
        OrderFriendAgentPayMode * mode=self.friendAgentpayArr[button.tag];
        if (self.shareHandle) {
            self.shareHandle(mode, nil);
        }
    };
}
-(void)initStoneOriginalProductView{
    
    _stoneOriginalProductView=[[JHOrderStoneOriginalProductView alloc]init];
    [self.contentScroll addSubview:_stoneOriginalProductView];
    [_stoneOriginalProductView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payListView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
}
-(void)initOrderInfoView{
    
    _orderInfoView=[[JHOrderInfoView alloc]init];
    [self.contentScroll addSubview:_orderInfoView];
    
    [_orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stoneOriginalProductView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
}
-(void)initServeView{
    
    _serviceView=[[UIView alloc]init];
    _serviceView.backgroundColor=[UIColor whiteColor];
    _serviceView.layer.cornerRadius = 8;
    _serviceView.layer.masksToBounds = YES;
    [self.contentScroll addSubview:_serviceView];
    
    [_serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderInfoView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(0);
        make.bottom.equalTo(self.contentScroll).offset(-10);
    }];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"order_jiesuan_icon"] forState:UIControlStateNormal];//
    [button setTitle:@"结算详情" forState:UIControlStateNormal];
    [button setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:13];
    button.tag=JHOrderButtonTypeAccountDetail;
    [button addTarget:self action:@selector(ClickService:) forControlEvents:UIControlEventTouchUpInside];
    [_serviceView addSubview:button];
    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                            imageTitleSpace:5];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_serviceView);
    }];
    
}
-(void)initBottomView{
    
    _buttonBackView=[[JHOrderButtonsView alloc]init];
    _buttonBackView.backgroundColor=[CommHelp toUIColorByStr:@"#ffffff"];
    [self.viewController.view addSubview:_buttonBackView];
    [_buttonBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.viewController.view).offset(0);
        make.height.offset(50);
        make.bottom.equalTo(self.viewController.view).offset(-UI.bottomSafeAreaHeight);
    }];
    JH_WEAK(self)
    _buttonBackView.buttonHandle = ^(id obj) {
        JH_STRONG(self)
        UIButton *button=(UIButton*)obj;
        if (self.delegate) {
            [self.delegate buttonPress:button];
        }
    };
}

-(void)initStoneOriginalProductSubviews{
    
    [self.stoneOriginalProductView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payListView.mas_bottom).offset(10);
    }];
    [self.stoneOriginalProductView initStoneOriginalProductSubviews:self.orderMode];
    
}
-(void)initFeeSubvies{
    NSMutableArray * titles=[self.feeView handleFeeData:self.orderMode];
    if (titles.count>0) {
        [self.feeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.feeView initFeeSubViews:titles];
        [self.feeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processDeductionView.mas_bottom).offset(10);
        }];
    }
}
-(void)initCustomizeFeeSubvies{
    
    NSMutableArray * titles=[self.feeView handleCustomizeFeeData:self.orderMode];
    if (titles.count>0) {
        [self.feeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.feeView initFeeSubViews:titles];
        [self.feeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.processDeductionView.mas_bottom).offset(10);
        }];
    }
}
-(void)initProcessDeductionSubviews{
    
    NSMutableArray * titles=[self.processDeductionView handleProcessDeductionwData:self.orderMode];
    if (titles.count>0) {
        [self.processDeductionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.processDeductionView initDeductionSubViews:titles];
        [self.processDeductionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsPriceView.mas_bottom).offset(10);
        }];
    }
    
}
-(void)initDeductionSubviews{
    
    NSMutableArray * titles=[self.deductionView handleDeductionwData:self.orderMode];
    if (titles.count>0) {
        [self.deductionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.deductionView initDeductionSubViews:titles];
        [self.deductionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.feeView.mas_bottom).offset(10);
        }];
    }
    
}
-(void)initProcessDescSubViews{
    
    [_processDescView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deductionView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    [self.processDescView initProcessDescSubViews:self.orderMode];
    
}
-(void)initBuyerNoteSubViews{
    
    [_buyerNoteView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_processDescView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    [self.buyerNoteView initBuyerNoteSubViews:self.orderMode];
    
}
-(void)initSellerNoteSubViews{
    
    [_sellerNoteView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyerNoteView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    [self.sellerNoteView setOrderMode:self.orderMode];
    [self.sellerNoteView initSellerNoteSubViews];
    
}
-(void)initOrderInfoSubviews{
    NSMutableArray * titles=[self.orderInfoView handleOrderData:self.orderMode];
    self.orderInfoView.orderMode=self.orderMode;
    [self.orderInfoView setupOrderInfo:titles];
    
}
-(void)handleOrderButtons:(JHOrderDetailMode*)mode{
    
    if ([_orderMode.orderStatus isEqualToString:@"waitack"]||
        [_orderMode.orderStatus isEqualToString:@"waitpay"]||
        [_orderMode.orderStatus isEqualToString:@"waitsellersend"]
        ) {
        [self timeCountDown];
    }
    if ([_orderMode.orderStatusString length]>0) {
        self.productView.orderStatusLabel.text=_orderMode.orderStatusString;
    }
    else {
        self.productView.orderStatusLabel.text=_orderMode.workorderDesc;
    }
    if (self.orderMode.buttons.count==0) {
        [self.buttonBackView setHidden:YES];
    }
    else {
        if ([self.orderMode.orderCategory isEqualToString:@"mallAuctionDepositOrder"]) {
            [self.buttonBackView setHidden:YES];
        } else {
            [self.buttonBackView setHidden:NO];
            [self.buttonBackView setupSellerButtons:self.orderMode.buttons];
        }
    }
}
-(void)setIsProblem:(BOOL)isProblem{
    if (isProblem) {
        NSMutableArray * buttons=[NSMutableArray array];
        [buttons addObject:@{@"buttonTitle":@"问题详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeQuestionDetail]}];
        
        [self.buttonBackView setupSellerButtons:buttons];
    }
}
-(void)setFriendAgentpayArr:(NSArray *)friendAgentpayArr{
    
    _friendAgentpayArr=friendAgentpayArr;
    if (_friendAgentpayArr.count>0) {
        [_payListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sellerNoteView.mas_bottom).offset(10);
        }];
    }
    [self.payListView initSellerPayListSubviews:_friendAgentpayArr];
    
}

-(void)setOrderMode:(JHOrderDetailMode *)orderMode{
    
    _orderMode=orderMode;
    _orderMode.isSeller = YES;
    _deductionView.orderCategory = _orderMode.orderCategory;
    [self.productView setOrderMode:_orderMode];
    [self.productView ConfigCategoryTagTitle:_orderMode];
    
    if (_orderMode.shippingReceiverName) {
        [_addressView setOrderMode:_orderMode];
        [_addressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_remainTimeView.mas_bottom).offset(10);
            make.height.offset(90);
        }];
    }
    //加工服务单或者加工单显示加工费 原石回血单也可能有加工费
    if (self.orderMode.orderCategoryType==JHOrderCategoryProcessing||
        self.orderMode.orderCategoryType==JHOrderCategoryProcessingGoods||
        self.orderMode.orderCategoryType==JHOrderCategoryRestore||
        self.orderMode.orderCategoryType==JHOrderCategoryRestoreProcessing) {
        [self initFeeSubvies];
    }
    //定制单
    if (self.orderMode.orderCategoryType==JHOrderCategoryCustomizedOrder||
        self.orderMode.orderCategoryType==JHOrderCategoryCustomizedIntentionOrder) {
        [self initCustomizeFeeSubvies];
    }
    
    if (self.orderMode.isDirectDelivery == 1) { //商家直发
        [_appraiseStepView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_productView.mas_bottom).offset(0);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
            make.height.offset(0);
        }];
    }
    
    //加工服务单或者加工单显示单独的抵扣信息模块 显示商品价格一栏
#warning 回血单如果有加工费怎么处理
    if (self.orderMode.orderCategoryType==JHOrderCategoryProcessing||
        self.orderMode.orderCategoryType==JHOrderCategoryProcessingGoods||
        self.orderMode.orderCategoryType==JHOrderCategoryRestoreProcessing) {
        [self initProcessDeductionSubviews];
        
        [_goodsPriceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shopTrolleyView.mas_bottom).offset(10);
            make.height.offset(50);
        }];
        [_goodsPriceView setOrderMode:_orderMode];
    }
    
    //抵扣信息
    [self initDeductionSubviews];
    //加工描述
    if([self.orderMode.processingDes length]>0 ){
        [self initProcessDescSubViews];
    }
    //买家留言
    if([self.orderMode.orderDesc length]>0 ){
        [self initBuyerNoteSubViews];
    }
    //卖家留言
    if([self.orderMode.complementVo.remark length]>0||
       [self.orderMode.complementVo.pics count]>0 ){
        [self initSellerNoteSubViews];
    }
    
    //订单支付时间信息
    [self initOrderInfoSubviews];
    //底部按钮
    [self handleOrderButtons:_orderMode];
    //原石订单
    if (_orderMode.orderCategoryType==JHOrderCategoryRestore||
        _orderMode.orderCategoryType==JHOrderCategoryRestoreProcessing)
    {
        [self.productView initStoneProductViews];
        //原石 母订单
        if (_orderMode.hasParent) {
            [self initStoneOriginalProductSubviews];
        }
    }
    //特卖订单显示购买数量
    if (_orderMode.goodsCount&&
        _orderMode.goodsCount>0&&
        ( self.orderMode.orderCategoryType==JHOrderCategoryLimitedTime||
         self.orderMode.orderCategoryType==JHOrderCategoryLimitedShop||
         self.orderMode.orderCategoryType==JHOrderCategoryMallOrder)
        ){
        [_shopTrolleyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_appraiseStepView.mas_bottom).offset(10);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
            make.height.offset(48);
        }];
        [self.shopTrolleyView  setOrderMode:_orderMode];
        self.shopTrolleyView.hidden = NO;
        
        
    }
    else
    {
        self.shopTrolleyView.hidden = YES;
    }
    
//    //特卖订单显示鉴定步骤提示
//    if (
//        self.orderMode.orderCategoryType==JHOrderCategoryLimitedTime||
//        self.orderMode.orderCategoryType==JHOrderCategoryLimitedShop||
//        self.orderMode.orderCategoryType==JHOrderCategoryMallOrder){
//        [_appraiseStepView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_productView.mas_bottom).offset(10);
//            make.left.equalTo(self.contentScroll).offset(10);
//            make.right.equalTo(self.contentScroll).offset(-10);
//            make.height.offset(63);
//        }];
//    }
//    else{
//        [_appraiseStepView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_productView.mas_bottom).offset(0);
//            make.left.equalTo(self.contentScroll).offset(10);
//            make.right.equalTo(self.contentScroll).offset(-10);
//            make.height.offset(0);
//        }];
//
//    }
    
    if (self.orderMode.isNewSettle) {
        [_serviceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderInfoView.mas_bottom).offset(10);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
            make.height.offset(40);
            make.bottom.equalTo(self.contentScroll).offset(-10);
        }];
    }
    
    /// 保证金不显示倒计时
    if ([_orderMode.orderCategory isEqualToString:@"mallAuctionDepositOrder"]) {
        self.remainTimeView.hidden = YES;
        [_remainTimeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
            make.top.offset(0);
        }];
    } else {
        self.remainTimeView.hidden = NO;
    }
}
-(void)timeCountDown{
    
    if (self.orderMode) {
        NSString * expireTime;
        if ([self.orderMode.orderStatus isEqualToString:@"waitack"]||[self.orderMode.orderStatus isEqualToString:@"waitpay"]) {
            expireTime=self.orderMode.payExpireTime;
            self.remainTimeView.title=@"剩余支付时间:";
            
        }
        else if ([self.orderMode.orderStatus isEqualToString:@"refunding"]) {
            expireTime=self.orderMode.refundExpireTime;
            self.remainTimeView.title=@"剩余退货时间:";
        }
        
        //  待发货
        else if ([self.orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
            
            expireTime=self.orderMode.sellerSentExpireTime;
            self.remainTimeView.title=@"剩余发货时间:";
        }
        [_remainTimeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.top.offset(10);
        }];
        self.remainTimeView.time=[CommHelp getHMSWithSecond:[CommHelp dateRemaining:expireTime]];
        //没过期
        if ([CommHelp dateRemaining:expireTime]>0) {
            JH_WEAK(self)
            if (!timer) {
                timer=[[BYTimer alloc]init];
            }
            [timer createTimerWithTimeout:[CommHelp dateRemaining:expireTime] handlerBlock:^(int presentTime) {
                JH_STRONG(self)
                self.remainTimeView.time=[CommHelp getHMSWithSecond:presentTime];
            } finish:^{
                JH_STRONG(self)
                [self showExpireTimeTitle];
            }];
        }
        
        else{
            
            [self showExpireTimeTitle];
            
        }
        
    }
}
-(void)showExpireTimeTitle{
    
    self.remainTimeView.time = @"";
    if ([self.orderMode.orderStatus isEqualToString:@"waitack"]||[self.orderMode.orderStatus isEqualToString:@"waitpay"]) {
        self.remainTimeView.title = @"订单过期未支付！";
    }
    else if ([self.orderMode.orderStatus isEqualToString:@"refunding"]) {
        self.remainTimeView.title = @"订单过期未退回！";
    }
    else if ([self.orderMode.orderStatus isEqualToString:@"waitsellersend"]) {
        self.remainTimeView.title = @"发货已延期";
    }
}
-(void)setViewHeightChangeBlock:(JHFinishBlock)viewHeightChangeBlock{
    
    _viewHeightChangeBlock = viewHeightChangeBlock;
    _feeView.viewHeightChangeBlock = _viewHeightChangeBlock;
}
- (void)ClickService:(UIButton*)button{
    
    if (self.delegate) {
        [self.delegate buttonPress:button];
    }
    
}
-(void)productViewTap:(UIGestureRecognizer*)gestureRecognizer{
    
    if (self.orderMode.orderCategoryType == JHOrderCategoryMallOrder) {
        JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
        detailVC.productId = self.orderMode.onlyGoodsId;
        [self.viewController.navigationController pushViewController:detailVC animated:YES];
    }
}
- (void)dealloc
{
    [timer stopGCDTimer];
    NSLog(@"dealloc");
}
@end


