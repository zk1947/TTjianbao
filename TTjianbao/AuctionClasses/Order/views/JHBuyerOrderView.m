//
//  JHBuyerOrderView.m
//  TTjianbao
//
//  Created by jiang on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBuyerOrderView.h"
#import "BYTimer.h"
#import "JHCouponListView.h"
#import "JHMallCoponListView.h"
#import "JHOrderViewModel.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoUtil.h"
#import "JHUIFactory.h"
#import "JHItemMode.h"
#import "JHWebViewController.h"
#import "JHStoreDetailViewController.h"
#import "JHOrderRemainTimeView.h"
#import "JHOrderAdressView.h"
#import "JHOrderProductView.h"
#import "JHOrderDetailAppraiseStepView.h"
#import "JHOrderShopTrolleyView.h"
#import "JHOrderGoodsPriceView.h"
#import "JHOrderFeeView.h"
#import "JHOrderDeductionView.h"
#import "JHOrderProcessDescView.h"
#import "JHOrderBuyerNoteView.h"
#import "JHOrderSellerNoteView.h"
#import "JHOrderPayListView.h"
#import "JHOrderStoneOriginalProductView.h"
#import "JHOrderInfoView.h"
#import "JHOrderButtonsView.h"
#import "JHOrderHeaderTipView.h"
#import "JHOrderFactory.h"
#import "JHAppBusinessModelManager.h"

@interface JHBuyerOrderView ()
{
    BYTimer *timer;
}
@property(nonatomic,strong) JHOrderHeaderTitleView * headerTitleView;
@property(nonatomic,strong) JHOrderHeaderTipView * headerTipView;
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
@property(nonatomic,strong) UIImageView *tipImgeView;
@end
@implementation JHBuyerOrderView
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
    [self initTipView];
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
    
    _headerTitleView=[[JHOrderHeaderTitleView alloc]init];
    [self.contentScroll addSubview:_headerTitleView];
    [_headerTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.width.offset(ScreenW);
    }];
    
}
-(void)initTipView{
    
    _headerTipView=[[JHOrderHeaderTipView alloc]init];
    [self.contentScroll addSubview:_headerTipView];
    [_headerTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTitleView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.width.offset(ScreenW-20);
    }];
}
-(void)initAddressView{
    
    _addressView=[[JHOrderAdressView alloc]init];
    [self.contentScroll addSubview:_addressView];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerTipView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(0);
    }];
}
-(void)initProductView{
    
    _productView=[[JHOrderProductView alloc]init];
    [self.contentScroll addSubview:_productView];
    _productView.userInteractionEnabled=YES;
    [_productView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productViewTap:)]];
    
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
        make.top.equalTo(self.orderInfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.height.offset(40);
        make.bottom.equalTo(self.contentScroll).offset(-10);
        
    }];
    
    _chatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_chatBtn setImage:[UIImage imageNamed:@"order_contactService_icon"] forState:UIControlStateNormal];//
    [_chatBtn setTitle:@"" forState:UIControlStateNormal];
    [_chatBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    _chatBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    _chatBtn.tag=JHOrderButtonTypeContact;
    [_chatBtn addTarget:self action:@selector(ClickService:) forControlEvents:UIControlEventTouchUpInside];
    [_serviceView addSubview:_chatBtn];
    [_chatBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                              imageTitleSpace:5];
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    //    if ([_orderMode.orderStatus isEqualToString:@"waitack"]||
    //        [_orderMode.orderStatus isEqualToString:@"waitpay"]||
    //        [_orderMode.orderStatus isEqualToString:@"refunding"]
    //        ) {
    //        [self timeCountDown];
    //    }
    
    //  #warning TODO:姜超  需要去掉
    //    if ([_orderMode.orderStatusString length]>0) {
    //        self.productView.orderStatusLabel.text=_orderMode.orderStatusString;
    //    }
    //    else{
    //        self.productView.orderStatusLabel.text=_orderMode.workorderDesc;
    //    }
    if (self.orderMode.buttons.count==0) {
        [self.buttonBackView setHidden:YES];
    }
    
    else{
        [self.buttonBackView setHidden:NO];
        [self.buttonBackView setupBuyerButtons:self.orderMode.buttons];
    }
    
}

-(void)setFriendAgentpayArr:(NSArray *)friendAgentpayArr{
    
    _friendAgentpayArr=friendAgentpayArr;
    if (_friendAgentpayArr.count>0) {
        [_payListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sellerNoteView.mas_bottom).offset(10);
        }];
    }
    [self.payListView initBuyerPayListSubviews:_friendAgentpayArr];
    
}

-(void)setOrderMode:(JHOrderDetailMode *)orderMode{
    
    _orderMode=orderMode;
    [self.productView setOrderMode:_orderMode];
    [self.productView ConfigCategoryTagTitle:_orderMode];
    
    //头信息
    [self.headerTitleView setOrderMode:_orderMode];
    //提示信息
    [self showTipView];
    
    
    if (_orderMode.shippingReceiverName) {
        [_addressView setOrderMode:_orderMode];
        [_addressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerTipView.mas_bottom).offset(10);
            make.height.offset(90);
        }];
    }
    
    // 直发商品买家待收货隐藏天天鉴宝品控流程
    // 获得订单状态
    JHBusinessModel bModel = _orderMode.directDelivery ? JHBusinessModel_SH : JHBusinessModel_De;
    JHVariousStatusOfOrders orderStatusType = [JHOrderFactory getVariousStatusOfOrders:_orderMode.orderStatus];
    BOOL  isHideConditions = NO;
    if (orderStatusType == JHVariousStatusOfOrders_WaitReceiving||
        orderStatusType == JHVariousStatusOfOrders_WaitPay) {
        isHideConditions = YES;
    }
    BOOL isHideAppraiseStepView = (isHideConditions  && bModel == JHBusinessModel_SH) ? YES : NO;
    if (isHideAppraiseStepView) {
        [_shopTrolleyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_productView.mas_bottom).offset(0);
        }];
    }
    [_appraiseStepView setHidden:isHideAppraiseStepView];
    
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
    // 原石订单
    if (_orderMode.orderCategoryType==JHOrderCategoryRestore||
        _orderMode.orderCategoryType==JHOrderCategoryRestoreProcessing)
    {
        [self.productView initStoneProductViews];
        //原石 母订单
        if (_orderMode.hasParent) {
            
            [self initStoneOriginalProductSubviews];
        }
    }
    if (orderMode.isDirectDelivery == 1) { //商家直发
        [_appraiseStepView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_productView.mas_bottom).offset(0);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
            make.height.offset(0);
        }];
    }
    
    //特卖订单显示购买数量
    if (_orderMode.goodsCount&&
        _orderMode.goodsCount>0&&
        ( self.orderMode.orderCategoryType==JHOrderCategoryLimitedTime||
         self.orderMode.orderCategoryType==JHOrderCategoryLimitedShop||
         self.orderMode.orderCategoryType==JHOrderCategoryMallOrder)
        ){
        [_shopTrolleyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (isHideAppraiseStepView) {
                make.top.equalTo(_productView.mas_bottom).offset(10);
            } else {
                make.top.equalTo(_appraiseStepView.mas_bottom).offset(10);
            }
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
    
    
    
    [self showReportTipImage];
    
}
-(void)showTipView{
    
    if ([_orderMode.orderStatus isEqualToString:@"waitack"]||
        [_orderMode.orderStatus isEqualToString:@"waitpay"]) {
        //提示
        JHChangeDesCondition condition = JHChangeDesCondition_None;
        if (_orderMode.directDelivery) {
            condition = JHChangeDesCondition_Buyers_WaitPay_SH;
        }
        OrderStatusTipModel *tipModel = [UserInfoRequestManager findNewTip:condition
                                                                    status:_orderMode.orderStatus];
        if (tipModel) {
            [_headerTipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_headerTitleView.mas_bottom).offset(-15);
                make.left.equalTo(self.contentScroll).offset(10);
                make.right.equalTo(self.contentScroll).offset(-10);
                make.width.offset(ScreenW-20);
            }];
            [self.headerTipView initContent:tipModel.title andDesc:tipModel.desc];
        }
    }else if(_orderMode.partialRefundFlag){
        [_headerTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerTitleView.mas_bottom).offset(-15);
            make.left.equalTo(self.contentScroll).offset(0);
            make.right.equalTo(self.contentScroll).offset(-0);
        }];
        [self.headerTipView initContentWithPrice:[NSString stringWithFormat:@"该订单已完成部分退款，退款金额为￥%@",_orderMode.partialRefundAmount]];
    }
    else{
        [_headerTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerTitleView.mas_bottom).offset(0);
            make.left.equalTo(self.contentScroll).offset(10);
            make.right.equalTo(self.contentScroll).offset(-10);
            make.width.offset(ScreenW-20);
        }];
        
    }
}
-(void)showReportTipImage{
    
    [_tipImgeView removeFromSuperview];
    _tipImgeView=nil;
    
    if (!self.orderMode.reportReadFlag) {
        for (id obj in self.buttonBackView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton * button =(UIButton*)obj;
                //JHOrderButtonTypeDetail
                if (button.tag == JHOrderButtonTypeDetail) {
                    [self.viewController.view addSubview:self.tipImgeView];
                    [self.tipImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(button.mas_left).offset(30);
                        make.bottom.equalTo(button.mas_top).offset(7);
                        make.size.mas_equalTo(CGSizeMake(40, 19));
                    }];
                }
            }
            break;
        }
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
        detailVC.fromPage = @"";
        [self.viewController.navigationController pushViewController:detailVC animated:YES];
    }
    
}
-(UIImageView*)tipImgeView{
    
    if (!_tipImgeView) {
        _tipImgeView=[[UIImageView alloc]init];
        _tipImgeView.contentMode = UIViewContentModeScaleAspectFit;
        _tipImgeView.image=[UIImage imageNamed:@"order_show_report_img"];
    }
    return _tipImgeView;
    
}
- (void)dealloc
{
    [timer stopGCDTimer];
    NSLog(@"dealloc");
}

- (void)setOrderCategory:(NSString *)orderCategory{
    _orderCategory = orderCategory;
    _deductionView.orderCategory = _orderCategory;
}

@end

